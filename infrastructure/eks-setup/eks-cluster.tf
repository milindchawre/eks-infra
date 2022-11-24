module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.31.1"

  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_tags                = merge(var.tags, { Name = local.cluster_name }, { cluster = local.cluster_name }, { env = var.env_type })
  cluster_security_group_tags = merge(var.tags, { Name = local.cluster_name }, { cluster = local.cluster_name }, { env = var.env_type })
  tags                        = merge(var.tags, { Name = local.cluster_name }, { cluster = local.cluster_name }, { env = var.env_type })

  eks_managed_node_group_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 50

    attach_cluster_primary_security_group = true

    create_security_group = true

  }

  eks_managed_node_groups = {
    app = {
      name = var.node_pool_app.name

      instance_types = var.node_pool_app.vm_type

      min_size     = var.node_pool_app.min_nodes
      max_size     = var.node_pool_app.max_nodes
      desired_size = var.node_pool_app.min_nodes

      tags = merge(var.tags, { cluster = local.cluster_name }, { env = var.env_type })

    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = var.oidc_iam_role
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
}