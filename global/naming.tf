locals {
  naming_convention = "${var.application_name}-${var.environment}-{component}-${var.location_short}"

  resource_names = {
    vnet              = "${var.application_name}-vnet-${var.environment}-${var.location_short}"
    aks               = "${var.application_name}-aks-${var.environment}-${var.location_short}"
    acr               = "${lower(var.application_name)}acr${var.environment}${var.location_short}"
    key_vault         = "${var.application_name}-kv-${var.environment}-${var.location_short}"
    storage_account   = "${lower(var.application_name)}st${var.environment}${var.location_short}"
    app_gateway       = "${var.application_name}-appgw-${var.environment}-${var.location_short}"
    nsg               = "${var.application_name}-nsg-{subnet}-${var.environment}-${var.location_short}"
    nic               = "${var.application_name}-nic-{role}-${var.environment}-${var.location_short}"
    public_ip         = "${var.application_name}-pip-{role}-${var.environment}-${var.location_short}"
    vm                = "${var.application_name}-vm-{role}-${var.environment}-${var.location_short}"
    log_analytics     = "${var.application_name}-la-${var.environment}-${var.location_short}"
    recovery_vault    = "${var.application_name}-rsv-${var.environment}-${var.location_short}"
    redis             = "${lower(var.application_name)}-redis-${var.environment}-${var.location_short}"
    sql_server        = "${lower(var.application_name)}-sql-${var.environment}-${var.location_short}"
    sql_database      = "${var.application_name}-sqldb-{database}-${var.environment}"
    service_bus_ns    = "${lower(var.application_name)}-sb-${var.environment}-${var.location_short}"
  }
}
