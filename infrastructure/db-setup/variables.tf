variable "aws_region" {
  description = "AWS Regions"
  type = object({
    primary_region   = string
    secondary_region = string
  })
}

variable "vpc" {
  description = "Configuration for VPC"
  type = object({
    primary_vpc_id   = string
    secondary_vpc_id = string
  })
}

variable "tags" {
  description = "Tags for all cloud resources"
  type        = map(string)
}

variable "prefix" {
  description = "Prefix applied to all cloud resources"
  type        = string
  default     = ""
}

variable "env_type" {
  description = "Environment type (dev, prod, ...)"
  type        = string
  default     = ""
}

variable "aurora" {
  description = "Aurora postgreSQL DB configuration"
  type = object({
    engine                = string
    engine_version        = string
    instance_class        = string
    db_param_group_family = string
    db_name               = string
  })
}

variable "eks" {
  description = "EKS configuration"
  type = object({
    primary_cluster   = string
    secondary_cluster = string
  })
}

variable "todo_app" {
  description = "todo app configuration"
  type = object({
    region1_url = string
    region2_url = string
  })
}