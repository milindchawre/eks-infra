resource "kubernetes_namespace" "app" {
  metadata {
    name = "app"
  }
}

/*resource "kubernetes_secret" "db_creds" {
  metadata {
    name      = "db-creds"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  data = {
    username               = module.db.db_instance_username
    password               = module.db.db_instance_password
    db_address             = module.db.db_instance_address
    db_connection_endpoint = module.db.db_instance_endpoint
  }
}*/