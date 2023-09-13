resource "azurerm_key_vault" "this" {
  name                       = "${local.resource_name}-kv"
  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  enable_rbac_authorization  = true

  sku_name = "standard"
}

resource "azurerm_key_vault_certificate" "this" {
  name         = var.certificate_name
  key_vault_id = azurerm_key_vault.this.id

  depends_on = [
    azurerm_kubernetes_cluster.this,
    azurerm_role_assignment.deployer_kv_access
  ]

  certificate {
    contents = var.certificate_base64_encoded
    password = var.certificate_password
  }

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
}