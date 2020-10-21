output vm_password {
  value       = random_password.password.result
  sensitive   = false
  description = "Password setup for the VM"
  depends_on  = [azurerm_virtual_machine.compute-vm1]
}

