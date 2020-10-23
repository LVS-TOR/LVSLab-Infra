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
  default     = {Environment = "Lab"}
}

variable subscription_id {
  type        = string
  description = "The ID for the Azure subscription where the LAB infrastructure will be deployed to"
}
