
resource "azurerm_resource_group" "tfstate" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "NonProd"
    Purpose     = "TerraformRemoteState"
    ManagedBy   = "Terraform"

    # Subscription-level policy requirements
    Criticality        = "Low"
    DataClassification = "Internal"

    # mg-railconnect policy requirements
    Application  = "RailConnect"
    Owner        = "PlatformEngineering"
    CostCenter   = "CC-IT-001"
    BusinessUnit = "Technology"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_account" "tfstate" {
  name                = var.storage_account_name
  resource_group_name = azurerm_resource_group.tfstate.name
  location            = azurerm_resource_group.tfstate.location

  account_tier               = "Standard"
  account_replication_type   = "LRS"
  account_kind               = "StorageV2"
  min_tls_version            = "TLS1_2"
  https_traffic_only_enabled = true

  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false

  # Prefer Microsoft Entra ID authentication.
  # Shared-key access remains enabled only for bootstrap
  # until Entra ID/RBAC access has been verified.
  default_to_oauth_authentication = true
  local_user_enabled              = false
  shared_access_key_enabled       = true


  network_rules {
    default_action = "Deny"
    bypass         = ["None"]
    ip_rules       = var.approved_client_ip_rules
  }

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 30
    }

    container_delete_retention_policy {
      days = 30
    }
  }

  tags = azurerm_resource_group.tfstate.tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}
