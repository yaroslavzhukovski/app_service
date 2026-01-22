import os
import socket
from flask import Flask, jsonify
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient

app = Flask(__name__)

ACCOUNT = os.getenv("AZURE_STORAGE_ACCOUNT_NAME")
CONTAINER = os.getenv("AZURE_STORAGE_CONTAINER_NAME", "appdata")
BLOB_NAME = os.getenv("AZURE_STORAGE_BLOB_NAME", "hello.txt")


def _blob_host_public() -> str:
    if not ACCOUNT:
        raise RuntimeError("Missing AZURE_STORAGE_ACCOUNT_NAME app setting")
    return f"{ACCOUNT}.blob.core.windows.net"


def _blob_host_privatelink() -> str:
    if not ACCOUNT:
        raise RuntimeError("Missing AZURE_STORAGE_ACCOUNT_NAME app setting")
    return f"{ACCOUNT}.privatelink.blob.core.windows.net"


def _resolve_all(host: str):
    try:
        # Returns (hostname, aliaslist, ipaddrlist)
        return socket.gethostbyname_ex(host)[2]
    except Exception as e:
        return [f"ERROR: {e}"]


def _blob_service() -> BlobServiceClient:
    # IMPORTANT:
    # In real apps you keep using the public FQDN (blob.core.windows.net).
    # Private DNS makes it resolve to the private IP when running inside the VNet-integrated app.
    url = f"https://{_blob_host_public()}"
    cred = DefaultAzureCredential()
    return BlobServiceClient(account_url=url, credential=cred)


@app.get("/")
def root():
    return "OK - App Service is running"


@app.get("/health")
def health():
    return jsonify({"status": "ok"})


@app.get("/debug/dns")
def debug_dns():
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
    )


@app.get("/blob/write")
def write_blob():
    svc = _blob_service()
    container = svc.get_container_client(CONTAINER)

    # Create container if it doesn't exist
    try:
        container.create_container()
    except Exception:
        pass

    blob = container.get_blob_client(BLOB_NAME)
    blob.upload_blob(
        "Hello from Managed Identity over Private Endpoint.\n",
        overwrite=True,
    )

    return jsonify({"status": "written", "container": CONTAINER, "blob": BLOB_NAME})


@app.get("/blob/read")
def read_blob():
    svc = _blob_service()
    container = svc.get_container_client(CONTAINER)
    blob = container.get_blob_client(BLOB_NAME)

    data = blob.download_blob().readall().decode("utf-8", errors="replace")
    return jsonify({"status": "read", "content": data})

