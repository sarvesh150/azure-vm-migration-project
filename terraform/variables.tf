variable "subscription_id" {
    type = string
    description = "Azure subscription ID"
}
variable "location" {
    type = string
    default = "East US"
    description = "Azure region"
}
variable "environment" {
    type = string
    default = "production"
}
