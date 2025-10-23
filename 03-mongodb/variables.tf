variable "project_name" {
  default = "roboshop"
}

variable "env" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project = "roboshop"
    Component = "MongoDB"
    Environment = "DEV"
    Terraform = "true"
  }
}

variable "zone_name" {
  default = "kpdigital.fun"
}

variable "zone_id" {
  default = "Z076395711MSQ2ORVF678"
}