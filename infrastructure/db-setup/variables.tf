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