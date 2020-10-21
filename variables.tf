variable vm_name {
  type        = string
  default     = "lvslab"
  description = "description"
}

variable location {
  type        = string
  default     = "westus2"
  description = "Location for deploying the Azure resources"
}


variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}