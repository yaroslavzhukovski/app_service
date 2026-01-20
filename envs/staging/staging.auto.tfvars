location = "swedencentral"

rg_name   = "rg-appsvc-stg-swc-001"
vnet_name = "vnet-appsvc-stg-swc-001"

vnet_address_space = ["10.40.0.0/16"]

subnets = {
  appgw = {
    name             = "snet-appgw"
    address_prefixes = ["10.40.0.0/24"]
  }

  app = {
    name             = "snet-app"
    address_prefixes = ["10.40.1.0/24"]
  }

  appsvc_int = {
    name             = "snet-appsvc-int"
    address_prefixes = ["10.40.2.0/24"]

    delegation = {
      name = "delegation-web"
      service_delegation = {
        name = "Microsoft.Web/serverFarms"
      }
    }
  }

  pe = {
    name             = "snet-pe"
    address_prefixes = ["10.40.3.0/24"]

    # Required for Private Endpoints
    private_endpoint_network_policies_enabled = false
  }
}


tags = {
  env     = "staging"
  owner   = "yaroslav"
  project = "app_service"
}
asp_name               = "asp-appsvc-stg-swc-001"
asp_sku_name           = "S1"
webapp_name            = "app-appsvc-stg-swc-001"
storage_name           = "stappsvcstgswc001y"
storage_container_name = "appdata"
