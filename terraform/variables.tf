variable "subscription_id" {
  description = "The subscription ID for the Azure resources."
  type        = string
}
variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = "West US 2"
}
variable "environment" {
  description = "The environment for the resources (e.g., dev, prod)."
  type        = string
  default     = "production"
}