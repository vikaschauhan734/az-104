#Storage Blob
resource "azurerm_storage_blob" "mysb" {
  name = "imp-doc"
  storage_account_name = azurerm_storage_account.mysasrc.name
  storage_container_name = azurerm_storage_container.myscsrc.name
  type = "Block"
  source = "Vikas's Resume.pdf"
}