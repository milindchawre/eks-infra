/*data "aws_route53_zone" "domain" {
  name = var.route53_domain_name
}*/

/*
# Creating cname record pointing to alb url of todo app
# it just didn't worked (the automatic dns failover)
# and the global todo app url was not accessible
resource "aws_route53_record" "region1_app" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "todo-service.${var.env_type}.${data.aws_route53_zone.domain.name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["todo-service-region1.${var.env_type}.${data.aws_route53_zone.domain.name}"]

  failover_routing_policy {
    type = "PRIMARY"
  }

  set_identifier  = "region1_app_url"
  health_check_id = aws_route53_health_check.region1_app.id
}*/

/*
# Creating alias record pointing to alb url of todo app
# it just didn't worked (the automatic dns failover)
# and global todo app url was not accessible
resource "aws_route53_record" "region1_app" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "todo-service.${var.env_type}.${data.aws_route53_zone.domain.name}"
  type    = "A"
  #ttl     = "60"
  #records = ["todo-service-region1.${var.env_type}.${data.aws_route53_zone.domain.name}"]

  failover_routing_policy {
    type = "PRIMARY"
  }
  alias {
    name                   = "todo-service-region1.${var.env_type}.${data.aws_route53_zone.domain.name}"
    zone_id                = data.aws_route53_zone.domain.zone_id
    evaluate_target_health = true
  }

  set_identifier  = "region1_app_url_record"
  health_check_id = aws_route53_health_check.region1_app.id
}*/

/*
So making use of external-dns annotations to create route53 failover dns records was only option, 
alongwith normal A records for creating route53 healchecks for automatic dns failover
*/

resource "aws_route53_health_check" "region1_app" {
  fqdn              = var.todo_app.region1_url
  port              = "80"
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"
  tags              = merge(var.tags, { Name = "todo-app-region1-healthcheck" }, { env = var.env_type })
}

resource "aws_route53_health_check" "region2_app" {
  fqdn              = var.todo_app.region2_url
  port              = "80"
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"
  tags              = merge(var.tags, { Name = "todo-app-region2-healthcheck" }, { env = var.env_type })
}