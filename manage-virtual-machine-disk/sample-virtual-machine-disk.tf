data "azurerm_client_config" "current" {}


#Virtual Machine Disk
resource "azurerm_managed_disk" "myvmmd" {
  name                 = "clouddisk"
  location             = azurerm_resource_group.myrg.location
  resource_group_name  = azurerm_resource_group.myrg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "4" 
}

#Virtual Machine Disk Attachment
resource "azurerm_virtual_machine_data_disk_attachment" "myvmda" {
  managed_disk_id    = azurerm_managed_disk.myvmmd.id
  virtual_machine_id = azurerm_linux_virtual_machine.mylinuxvm.id
  lun                = "10"
  caching            = "ReadWrite"
}

#Key Vault
resource "azurerm_key_vault" "mykv" {
  name                        = "disk-keyvault779195626"
  location                    = azurerm_resource_group.myrg.location
  resource_group_name         = azurerm_resource_group.myrg.name
  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name                    = "premium"
  enabled_for_disk_encryption = true
  purge_protection_enabled    = true
}

#Key Vault Key
resource "azurerm_key_vault_key" "mykvk" {
  name         = "disk-keyvault-key"
  key_vault_id = azurerm_key_vault.mykv.id
  key_type     = "RSA"
  key_size     = 2048
  depends_on = [
    azurerm_key_vault_access_policy.mykvap-user
  ]
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

#Disk Encryption Set
resource "azurerm_disk_encryption_set" "mydes" {
  name                = "mydes-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  key_vault_key_id    = azurerm_key_vault_key.mykvk.id

  identity {
    type = "SystemAssigned"
  }
}

#Key Vault Access Policy
resource "azurerm_key_vault_access_policy" "mykvap-disk" {
  key_vault_id = azurerm_key_vault.mykv.id
  tenant_id = azurerm_disk_encryption_set.mydes.identity.0.tenant_id
  object_id = azurerm_disk_encryption_set.mydes.identity.0.principal_id
  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "Recover",
    "Update",
    "List",
    "Decrypt",
    "Sign"
  ]
}

#Key Vault Access Policy
resource "azurerm_key_vault_access_policy" "mykvap-user" {
  key_vault_id = azurerm_key_vault.mykv.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id
  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "Recover",
    "Update",
    "List",
    "Decrypt",
    "Sign"
  ]
}

#Role Assignment
resource "azurerm_role_assignment" "myra" {
  scope                = azurerm_key_vault.mykv.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id = azurerm_disk_encryption_set.mydes.identity.0.principal_id
}