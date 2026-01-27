import os
import socket
from typing import Any, Dict, Tuple

from flask import Flask, jsonify

app = Flask(__name__)

ACCOUNT = os.getenv("AZURE_STORAGE_ACCOUNT_NAME")
CONTAINER = os.getenv("AZURE_STORAGE_CONTAINER_NAME", "appdata")
BLOB_NAME = os.getenv("AZURE_STORAGE_BLOB_NAME", "hello.txt")


# ---------- helpers (no azure SDK imports here) ----------

def _blob_host_public() -> str:
    if not ACCOUNT:
        raise ValueError("Missing AZURE_STORAGE_ACCOUNT_NAME app setting")
    return f"{ACCOUNT}.blob.core.windows.net"


def _blob_host_privatelink() -> str:
    if not ACCOUNT:
        raise ValueError("Missing AZURE_STORAGE_ACCOUNT_NAME app setting")
    return f"{ACCOUNT}.privatelink.blob.core.windows.net"


def _resolve_all(host: str):
    try:
        return socket.gethostbyname_ex(host)[2]  # ipaddrlist
    except Exception as e:
        return [f"ERROR: {e}"]


def _load_azure_clients() -> Tuple[Any, Any]:
    """
    Import azure SDK lazily so the app can still start and serve /health
    even if dependencies are missing or build didn't run.
    """
    try:
        from azure.identity import DefaultAzureCredential
        from azure.storage.blob import BlobServiceClient
    except Exception as e:
        raise ImportError(f"Azure SDK import failed: {e}")

    url = f"https://{_blob_host_public()}"
    cred = DefaultAzureCredential()
    svc = BlobServiceClient(account_url=url, credential=cred)
    return svc, cred


def _error(message: str, status_code: int = 500, **extra: Dict[str, Any]):
    payload = {"error": message, **extra}
    return jsonify(payload), status_code


# ---------- endpoints ----------

@app.get("/")
def root():
    return "OK - App Service is running", 200


@app.get("/health")
def health():
    # Liveness: must be cheap and never depend on Storage/MI/DNS.
    return jsonify({"status": "ok"}), 200


@app.get("/ready")
def ready():
    """
    Readiness: optional deeper check.
    We don't hit Storage (could be slow/flaky),
    but we validate config + that azure SDK imports work.
    """
    if not ACCOUNT:
        return _error("Not ready: missing AZURE_STORAGE_ACCOUNT_NAME", 503)

    try:
        _load_azure_clients()
    except Exception as e:
        return _error("Not ready: azure dependencies not available", 503, details=str(e))

    return jsonify({"status": "ready"}), 200


@app.get("/debug/dns")
def debug_dns():
    if not ACCOUNT:
        return _error("Missing AZURE_STORAGE_ACCOUNT_NAME", 400)

    pub = _blob_host_public()
    pl = _blob_host_privatelink()

    return jsonify(
        {
            "storage_account": ACCOUNT,
            "container": CONTAINER,
            "blob": BLOB_NAME,
            "public_host": pub,
            "public_ips": _resolve_all(pub),
            "privatelink_host": pl,
            "privatelink_ips": _resolve_all(pl),
        }
    ), 200


@app.get("/debug/deps")
def debug_deps():
    """
    Shows whether the azure SDKs are importable.
    Useful when Oryx/pip install didn't run.
    """
    try:
        _load_azure_clients()
        return jsonify({"azure_sdk": "ok"}), 200
    except Exception as e:
        return _error("azure_sdk_missing_or_broken", 500, details=str(e))


@app.get("/blob/write")
def write_blob():
    # This endpoint is allowed to fail if deps/network/MI are broken.
    try:
        svc, _ = _load_azure_clients()
    except Exception as e:
        return _error("Azure SDK not available", 500, details=str(e))

    try:
        container = svc.get_container_client(CONTAINER)
        try:
            container.create_container()
        except Exception:
            pass

        blob = container.get_blob_client(BLOB_NAME)
        blob.upload_blob(
            "Hello from Managed Identity over Private Endpoint.\n",
            overwrite=True,
        )
        return jsonify({"status": "written", "container": CONTAINER, "blob": BLOB_NAME}), 200

    except Exception as e:
        return _error("Blob write failed", 500, details=str(e))


@app.get("/blob/read")
def read_blob():
    try:
        svc, _ = _load_azure_clients()
    except Exception as e:
        return _error("Azure SDK not available", 500, details=str(e))

    try:
        container = svc.get_container_client(CONTAINER)
        blob = container.get_blob_client(BLOB_NAME)
        data = blob.download_blob().readall().decode("utf-8", errors="replace")
        return jsonify({"status": "read", "content": data}), 200
    except Exception as e:
        return _error("Blob read failed", 500, details=str(e))
