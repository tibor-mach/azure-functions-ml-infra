# Input variable: Web App
variable "location" {
  description = "Location of the resource"
  default     = "West Europe"
}

variable "environment" {
  description = "Environment tag of the resource"
  default     = "test"
}

variable "prefix" {
  description = "A prefix to be used for all resources that need to have unique names"
  default     = "myprecious"
}