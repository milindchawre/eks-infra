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

variable "cluster_version" {
  description = "kubernetes version"
  type        = string
  default     = "1.24"
}

variable "tags" {
  description = "Tags for all cloud resources"
  type        = map(string)
}

variable "oidc_iam_role" {
  description = "OIDC IAM role associated with github actions"
  type        = string
}

variable "node_pool_app" {
  description = "App nodepool"
  type = object({
    min_nodes = number
    max_nodes = number
    vm_type   = list(string)
    name      = string
  })
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

# alb controller config
variable "aws_alb_controller" {
  description = "AWS ALB Controller configuration"
  type = object({
    namespace       = string
    chart_version   = string
    timeout_seconds = number
    config_file     = string
    config_content  = string
    replica_count   = number
  })
}

# PostgreSQL RDS config
variable "rds" {
  description = "Configuration for PostgreSQL RDS"
  type = object({
    db_identifier            = string
    db_engine                = string
    db_version               = string
    db_instance_class        = string
    db_storage               = number
    db_name                  = string
    db_user                  = string
    db_port                  = number
    db_backup_retention_days = number
    db_family                = string
    db_major_version         = string
    db_deletion_protection   = bool
  })
}