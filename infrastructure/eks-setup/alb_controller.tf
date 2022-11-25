# Install ALB ingress controller helm_chart
resource "helm_release" "aws_alb_controller" {
  namespace        = var.aws_alb_controller.namespace
  create_namespace = true
  name             = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  version          = var.aws_alb_controller.chart_version

  # Helm chart deployment can sometimes take longer than the default 5 minutes
  timeout = var.aws_alb_controller.timeout_seconds

  # If values file specified by the var.aws_alb_controller.config_file input variable exists then apply the values from this file
  # else apply the default values from the chart
  values = [fileexists(var.aws_alb_controller.config_file) ? file(var.aws_alb_controller.config_file) : var.aws_alb_controller.config_content]

  set {
    name  = "replicaCount"
    value = var.aws_alb_controller.replica_count
  }

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }
}