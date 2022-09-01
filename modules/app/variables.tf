# general resource variables

variable "location" {
  description = "Location of the resource"
  default     = "West Europe"
}

variable "environment" {
  description = "Environment tag of the resource"
  default     = "test"
}

variable "app_name" {
  description = "Azure functions app name."
  default     = "azfapp"
}

variable "prefix" {
  description = "A prefix to be used for all resources that need to have unique names"
  default     = "myprecious"
}

# image variables

variable "image_name" {
  description = "Name of the image from the registry to be used"
}

variable "image_tag" {
  description = "Tag of the image from the registry to be used"
  default     = "latest"
}

# Azure container registry variables
variable "acr_name" {
  description = "ACR container name where images are hosted."
}

variable "acr_id" {
  description = "ACR container id where images are hosted."
}

variable "acr_url" {
  description = "ACR container login URL."
}
