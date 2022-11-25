module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.16.2"

  name        = var.rds.db_identifier
  description = "Security Group for PostgreSQL RDS"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  tags = merge(var.tags, { Name = var.rds.db_identifier }, { env = var.env_type })
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.1.1"

  identifier = var.rds.db_identifier

  engine            = var.rds.db_engine
  engine_version    = var.rds.db_version
  instance_class    = var.rds.db_instance_class
  allocated_storage = var.rds.db_storage

  db_name  = var.rds.db_name
  username = var.rds.db_user
  port     = var.rds.db_port

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  create_cloudwatch_log_group     = true

  backup_retention_period = var.rds.db_backup_retention_days
  skip_final_snapshot     = true

  create_monitoring_role = false
  multi_az               = true

  tags = merge(var.tags, { Name = var.rds.db_identifier }, { env = var.env_type })

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = module.vpc.database_subnets

  # DB parameter group
  family = var.rds.db_family

  # DB option group
  major_engine_version = var.rds.db_major_version

  # Database Deletion Protection
  deletion_protection = var.rds.db_deletion_protection

  parameters = [
    {
      name  = "autovacuum"
      value = "1"
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]

  db_parameter_group_tags = merge(var.tags, { Name = var.rds.db_identifier }, { env = var.env_type })
}