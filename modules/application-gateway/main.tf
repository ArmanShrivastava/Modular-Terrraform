# Azure Application Gateway Module
# Enterprise-grade application gateway with WAF, backend pools, listeners, routing rules

resource "azurerm_application_gateway" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.capacity
  }

  gateway_ip_configuration {
    name      = var.gateway_ip_config_name
    subnet_id = var.subnet_id
  }

  # Frontend ports
  dynamic "frontend_port" {
    for_each = var.frontend_ports

    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }

  # Frontend IP configuration
  frontend_ip_configuration {
    name                          = var.frontend_ip_config_name
    public_ip_address_id          = var.public_ip_address_id
    private_ip_address_allocation = try(var.private_ip_allocation, null)
    private_ip_address            = try(var.private_ip_address, null)
    subnet_id                     = try(var.private_subnet_id, null)
  }

  # Backend address pools
  dynamic "backend_address_pool" {
    for_each = var.backend_pools

    content {
      name         = backend_address_pool.value.name
      fqdns        = try(backend_address_pool.value.fqdns, null)
      ip_addresses = try(backend_address_pool.value.ip_addresses, null)
    }
  }

  # Backend HTTP settings
  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings

    content {
      name                  = backend_http_settings.value.name
      cookie_based_affinity = try(backend_http_settings.value.cookie_based_affinity, "Disabled")
      port                  = backend_http_settings.value.port
      protocol              = backend_http_settings.value.protocol
      request_timeout       = try(backend_http_settings.value.request_timeout, 30)
      host_name             = try(backend_http_settings.value.host_name, null)
      pick_host_name_from_backend_address = try(backend_http_settings.value.pick_host_name_from_backend_address, false)

      dynamic "connection_draining" {
        for_each = try(backend_http_settings.value.connection_draining, null) != null ? [backend_http_settings.value.connection_draining] : []
        content {
          enabled           = connection_draining.value.enabled
          drain_timeout_sec = try(connection_draining.value.drain_timeout_sec, 300)
        }
      }

      dynamic "authentication_certificate" {
        for_each = try(backend_http_settings.value.authentication_certificates, [])
        content {
          name = authentication_certificate.value.name
        }
      }

      dynamic "trusted_root_certificate_names" {
        for_each = try(backend_http_settings.value.trusted_root_certificate_names, null) != null ? [backend_http_settings.value.trusted_root_certificate_names] : []
        content {
          names = trusted_root_certificate_names.value
        }
      }
    }
  }

  # HTTP listeners
  dynamic "http_listener" {
    for_each = var.http_listeners

    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = var.frontend_ip_config_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol
      host_names                     = try(http_listener.value.host_names, null)
      require_sni                    = try(http_listener.value.require_sni, false)
      ssl_certificate_name           = try(http_listener.value.ssl_certificate_name, null)
      ssl_profile_name               = try(http_listener.value.ssl_profile_name, null)
      firewall_policy_id             = try(http_listener.value.firewall_policy_id, null)
    }
  }

  # Request routing rules
  dynamic "request_routing_rule" {
    for_each = var.request_routing_rules

    content {
      name                       = request_routing_rule.value.name
      rule_type                  = try(request_routing_rule.value.rule_type, "Basic")
      http_listener_name         = request_routing_rule.value.http_listener_name
      backend_address_pool_name  = try(request_routing_rule.value.backend_address_pool_name, null)
      backend_http_settings_name = try(request_routing_rule.value.backend_http_settings_name, null)
      redirect_configuration_name = try(request_routing_rule.value.redirect_configuration_name, null)
      rewrite_rule_set_name      = try(request_routing_rule.value.rewrite_rule_set_name, null)
      url_path_map_name          = try(request_routing_rule.value.url_path_map_name, null)
      priority                   = try(request_routing_rule.value.priority, null)
    }
  }

  # SSL certificates (optional)
  dynamic "ssl_certificate" {
    for_each = var.ssl_certificates

    content {
      name                = ssl_certificate.value.name
      data                = try(ssl_certificate.value.data, null)
      password            = try(ssl_certificate.value.password, null)
      key_vault_secret_id = try(ssl_certificate.value.key_vault_secret_id, null)
    }
  }

  # SSL policy
  dynamic "ssl_policy" {
    for_each = var.ssl_policy != null ? [var.ssl_policy] : []
    content {
      disabled_protocols   = try(ssl_policy.value.disabled_protocols, null)
      policy_type          = try(ssl_policy.value.policy_type, null)
      policy_name          = try(ssl_policy.value.policy_name, null)
      min_protocol_version = try(ssl_policy.value.min_protocol_version, null)
      cipher_suites        = try(ssl_policy.value.cipher_suites, null)
    }
  }

  # Redirect configurations (optional)
  dynamic "redirect_configuration" {
    for_each = var.redirect_configurations

    content {
      name                 = redirect_configuration.value.name
      redirect_type        = redirect_configuration.value.redirect_type
      target_listener_name = try(redirect_configuration.value.target_listener_name, null)
      target_url           = try(redirect_configuration.value.target_url, null)
      include_path         = try(redirect_configuration.value.include_path, true)
      include_query_string = try(redirect_configuration.value.include_query_string, true)
    }
  }

  enable_http2 = try(var.enable_http2, false)
  enable_fips  = try(var.enable_fips, false)
  force_firewall_policy_association = try(var.force_firewall_policy_association, false)

  tags = merge(
    var.tags,
    try(var.additional_tags, {})
  )

  lifecycle {
    ignore_changes = [
      tags["CreatedDate"]
    ]
  }

  depends_on = []
}

# Autoscaling (optional)
resource "azurerm_monitor_autoscale_setting" "this" {
  count = var.enable_autoscaling ? 1 : 0

  name                = "${var.name}-autoscale"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_application_gateway.this.id

  profile {
    name = "default"

    capacity {
      minimum = var.autoscale_min_capacity
      maximum = var.autoscale_max_capacity
      default = var.autoscale_default_capacity
    }
  }
}
