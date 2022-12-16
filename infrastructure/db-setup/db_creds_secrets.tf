data "aws_eks_cluster" "primary_cluster" {
  name = var.eks.primary_cluster
}

data "aws_eks_cluster" "secondary_cluster" {
  provider = aws.secondary_region
  name     = var.eks.secondary_cluster
}

resource "kubernetes_namespace" "app_ns_primary_cluster" {
  provider = kubernetes.primary_cluster
  metadata {
    name = "app"
  }
}

resource "kubernetes_namespace" "app_ns_secondary_cluster" {
  provider = kubernetes.secondary_cluster
  metadata {
    name = "app"
  }
}

resource "kubernetes_secret" "db_creds_primary_cluster" {
  provider = kubernetes.primary_cluster
  metadata {
    name      = "db-creds"
    namespace = kubernetes_namespace.app_ns_primary_cluster.metadata[0].name
  }

  data = {
    username                   = module.aurora_primary_db_cluster.cluster_master_username
    password                   = module.aurora_primary_db_cluster.cluster_master_password
    port                       = module.aurora_primary_db_cluster.cluster_port
    region1_writer_db_endpoint = module.aurora_primary_db_cluster.cluster_endpoint
    region1_reader_db_endpoint = module.aurora_primary_db_cluster.cluster_reader_endpoint
    region2_writer_db_endpoint = module.aurora_secondary_db_cluster.cluster_endpoint
    region2_reader_db_endpoint = module.aurora_secondary_db_cluster.cluster_reader_endpoint
  }
  depends_on = [
    module.aurora_primary_db_cluster,
    module.aurora_secondary_db_cluster
  ]
}

resource "kubernetes_secret" "db_creds_secondary_cluster" {
  provider = kubernetes.secondary_cluster
  metadata {
    name      = "db-creds"
    namespace = kubernetes_namespace.app_ns_secondary_cluster.metadata[0].name
  }

  data = {
    username                   = module.aurora_primary_db_cluster.cluster_master_username
    password                   = module.aurora_primary_db_cluster.cluster_master_password
    port                       = module.aurora_primary_db_cluster.cluster_port
    region1_writer_db_endpoint = module.aurora_primary_db_cluster.cluster_endpoint
    region1_reader_db_endpoint = module.aurora_primary_db_cluster.cluster_reader_endpoint
    region2_writer_db_endpoint = module.aurora_secondary_db_cluster.cluster_endpoint
    region2_reader_db_endpoint = module.aurora_secondary_db_cluster.cluster_reader_endpoint
  }
  depends_on = [
    module.aurora_primary_db_cluster,
    module.aurora_secondary_db_cluster
  ]
}