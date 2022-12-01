# Install external-dns helm_chart
resource "helm_release" "external_dns" {
  namespace        = var.external_dns.namespace
  create_namespace = true
  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns"
  chart            = "external-dns"
  version          = var.external_dns.chart_version

  # Helm chart deployment can sometimes take longer than the default 5 minutes
  timeout = var.external_dns.timeout_seconds

  values = [fileexists("./config/external-dns.yml") ? templatefile("./config/external-dns.yml", {
    domain        = var.external_dns.domain,
    policy        = var.external_dns.policy,
    aws_zone_type = var.external_dns.aws_zone_type,
    aws_region    = var.external_dns.aws_region,
    })
    : ""
  ]
}