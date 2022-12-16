# Retrieve subnet ids
data "aws_subnet_ids" "primary_db" {
  vpc_id = var.vpc.primary_vpc_id

  tags = {
    subnet_type = "database"
  }
}

data "aws_subnet_ids" "secondary_db" {
  provider = aws.secondary_region
  vpc_id   = var.vpc.secondary_vpc_id

  tags = {
    subnet_type = "database"
  }
}

# Create aurora postgresdb global cluster
resource "aws_rds_global_cluster" "aurora_db" {
  global_cluster_identifier = "${var.prefix}-aurora-postgresdb-${var.env_type}"
  engine                    = var.aurora.engine
  engine_version            = var.aurora.engine_version
  database_name             = var.aurora.db_name
  storage_encrypted         = false
}

module "aurora_primary_db_cluster" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.6.0"

  name           = local.primary_dbcluster_name
  engine         = var.aurora.engine
  engine_version = var.aurora.engine_version
  #engine_mode    = "global"
  instance_class = var.aurora.instance_class
  instances = {
    one = {}
  }
  #db_cluster_instance_class = var.aurora.instance_class
  global_cluster_identifier = aws_rds_global_cluster.aurora_db.global_cluster_identifier

  is_primary_cluster = true

  #allocated_storage = 10
  #master_password = "xyz"
  master_username = "postgres"
  network_type    = "IPV4"
  #port = 5432
  publicly_accessible = false
  #replication_source_identifier = "some-source"
  #source_region = "aws-region"

  vpc_id  = var.vpc.primary_vpc_id
  subnets = data.aws_subnet_ids.primary_db.ids

  # Enable creation of cluster and all resources
  create_cluster = true

  # Enable creation of subnet group - provide a subnet group
  create_db_subnet_group = true

  # Enable creation of security group - provide a security group
  create_security_group = true

  # Enable creation of monitoring IAM role - provide a role ARN
  create_monitoring_role = true

  # Enable creation of random password - AWS API provides the password
  create_random_password = true

  create_db_cluster_parameter_group = true
  create_db_parameter_group         = true
  db_cluster_parameter_group_family = var.aurora.db_param_group_family
  db_parameter_group_family         = var.aurora.db_param_group_family

  allowed_cidr_blocks     = [data.aws_vpc.primary.cidr_block, data.aws_vpc.secondary.cidr_block]
  autoscaling_enabled     = false
  backup_retention_period = 2

  cluster_tags          = merge(var.tags, { Name = local.primary_dbcluster_name }, { env = var.env_type })
  copy_tags_to_snapshot = true
  security_group_tags   = merge(var.tags, { Name = "${local.primary_dbcluster_name}-sg" }, { env = var.env_type })
  tags                  = merge(var.tags, { Name = local.primary_dbcluster_name }, { env = var.env_type })

  database_name                   = var.aurora.db_name
  enable_global_write_forwarding  = false
  enabled_cloudwatch_logs_exports = ["postgresql"]

  storage_encrypted   = false
  monitoring_interval = 60
  skip_final_snapshot = true

  db_subnet_group_name            = "${local.primary_dbcluster_name}-dbsubnet-group"
  db_cluster_parameter_group_name = "${local.primary_dbcluster_name}-dbcluster-param"
  db_parameter_group_name         = "${local.primary_dbcluster_name}-db-param"

}

module "aurora_secondary_db_cluster" {
  providers = {
    aws = aws.secondary_region
  }
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.6.0"

  name           = local.secondary_dbcluster_name
  engine         = var.aurora.engine
  engine_version = var.aurora.engine_version
  #engine_mode    = "global"
  instance_class = var.aurora.instance_class
  instances = {
    one = {}
  }
  #db_cluster_instance_class = var.aurora.instance_class
  global_cluster_identifier = aws_rds_global_cluster.aurora_db.global_cluster_identifier

  is_primary_cluster = false

  #allocated_storage = 10
  master_password = module.aurora_primary_db_cluster.cluster_master_password
  master_username = module.aurora_primary_db_cluster.cluster_master_username
  network_type    = "IPV4"
  #port = 5432
  publicly_accessible           = false
  replication_source_identifier = module.aurora_primary_db_cluster.cluster_arn
  source_region                 = var.aws_region.primary_region

  vpc_id  = var.vpc.secondary_vpc_id
  subnets = data.aws_subnet_ids.secondary_db.ids

  # Enable creation of cluster and all resources
  create_cluster = true

  # Enable creation of subnet group - provide a subnet group
  create_db_subnet_group = true

  # Enable creation of security group - provide a security group
  create_security_group = true

  # Enable creation of monitoring IAM role - provide a role ARN
  create_monitoring_role = true

  # Disable creation of random password - AWS API provides the password
  create_random_password = false

  create_db_cluster_parameter_group = true
  create_db_parameter_group         = true
  db_cluster_parameter_group_family = var.aurora.db_param_group_family
  db_parameter_group_family         = var.aurora.db_param_group_family

  allowed_cidr_blocks     = [data.aws_vpc.primary.cidr_block, data.aws_vpc.secondary.cidr_block]
  autoscaling_enabled     = false
  backup_retention_period = 2

  cluster_tags          = merge(var.tags, { Name = local.secondary_dbcluster_name }, { env = var.env_type })
  copy_tags_to_snapshot = true
  security_group_tags   = merge(var.tags, { Name = "${local.secondary_dbcluster_name}-sg" }, { env = var.env_type })
  tags                  = merge(var.tags, { Name = local.secondary_dbcluster_name }, { env = var.env_type })

  database_name                   = var.aurora.db_name
  enable_global_write_forwarding  = false
  enabled_cloudwatch_logs_exports = ["postgresql"]

  storage_encrypted   = false
  monitoring_interval = 60
  skip_final_snapshot = true

  db_subnet_group_name            = "${local.secondary_dbcluster_name}-dbsubnet-group"
  db_cluster_parameter_group_name = "${local.secondary_dbcluster_name}-dbcluster-param"
  db_parameter_group_name         = "${local.secondary_dbcluster_name}-db-param"

  depends_on = [module.aurora_primary_db_cluster]

}