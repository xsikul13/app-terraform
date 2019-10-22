variable "environment_tag" {
    default="dev"
}

variable "resource_group_name" {
    default = "nc19app"
}

variable "target_location" {
    default = "westeurope"
}

variable "cr_resource_group" {
    default = "nc19-dev"
}

variable "docker_registry" {}

variable "docker_repository" {}

variable "docker_tag" {}