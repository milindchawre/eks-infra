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
  cluster_security_group_tags = merge(var.tags, { Name = local.cluster_name }, { cluster = local.cluster_name }, { env = var.env_type }, { "kubernetes.io/cluster/${local.cluster_name}" = "shared" })
  tags                        = merge(var.tags, { Name = local.cluster_name }, { cluster = local.cluster_name }, { env = var.env_type })

  eks_managed_node_group_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 50

    attach_cluster_primary_security_group = true

    create_security_group = true

    node_security_group_tags = {
      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    }
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
      username = "oidc_iam_role"
      groups   = ["system:masters"]
    },
  ]
}

module "load_balancer_controller_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.8.0"

  role_name                              = "load-balancer-controller-${var.region}"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["ingress:aws-load-balancer-controller"]
    }
  }

  tags = merge(var.tags, { cluster = local.cluster_name }, { env = var.env_type })
}

module "load_balancer_controller_targetgroup_binding_only_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.8.0"

  role_name                                                       = "load-balancer-controller-targetgroup-binding-only-${var.region}"
  attach_load_balancer_controller_targetgroup_binding_only_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["ingress:aws-load-balancer-controller"]
    }
  }

  tags = merge(var.tags, { cluster = local.cluster_name }, { env = var.env_type })
}

module "external_dns_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.8.0"

  role_name                     = "external-dns-${var.region}"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/${var.external_dns.domain}"]

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["ingress:external-dns"]
    }
  }

  tags = merge(var.tags, { cluster = local.cluster_name }, { env = var.env_type })
}

resource "aws_iam_role_policy_attachment" "external_dns" {
  for_each = module.eks.eks_managed_node_groups

  policy_arn = aws_iam_policy.external_dns_policy.arn
  role       = each.value.iam_role_name
}

data "template_file" "external_dns_policy" {
  template = file("./config/iam-policy-external-dns.json")
}

resource "aws_iam_policy" "external_dns_policy" {
  name        = "external-dns-policy-${var.region}"
  path        = "/"
  description = "Policy to run external dns on EKS cluster"

  policy = data.template_file.external_dns_policy.rendered
}

resource "aws_iam_role_policy_attachment" "alb_controller" {
  for_each = module.eks.eks_managed_node_groups

  policy_arn = aws_iam_policy.alb_controller_policy.arn
  role       = each.value.iam_role_name
}

data "template_file" "alb_controller_policy" {
  template = file("./config/iam-policy-alb-controller.json")
}

resource "aws_iam_policy" "alb_controller_policy" {
  name        = "alb-controller-policy-${var.region}"
  path        = "/"
  description = "Policy to run ALB controller on EKS cluster"

  policy = data.template_file.alb_controller_policy.rendered
}