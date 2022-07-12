locals {
  app = "hello-world"
}

resource "kubernetes_namespace" "hello_world" {
  metadata {
    annotations = {
      name = local.app
    }

    name = local.app
  }

  depends_on = [
    module.eks.cluster_id,
  ]
}


resource "kubernetes_config_map" "nginx_conf" {
  metadata {
    name      = "nginx-conf"
    namespace = local.app
  }

  data = {
    "nginx.conf" = "${file("${path.module}/files/nginx.conf")}"
  }

  depends_on = [
    kubernetes_namespace.hello_world,
  ]
}

resource "kubernetes_config_map" "index_html" {
  metadata {
    name      = "index-html"
    namespace = local.app
  }

  data = {
    "index.html" = "${file("${path.module}/files/index.html")}"
  }

  depends_on = [
    kubernetes_namespace.hello_world,
  ]
}


resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = local.app
    namespace = local.app
    labels = {
      app = local.app
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = local.app
      }
    }
    template {
      metadata {
        labels = {
          app = local.app
        }
      }
      spec {
        container {
          image = "nginx"
          name  = "nginx"

          port {
            container_port = 80
          }

          volume_mount {
            mount_path = "/www/data"
            name       = "index-html-volume"
            read_only  = "true"
          }

          volume_mount {
            mount_path = "/etc/nginx"
            name       = "nginx-conf-volume"
            read_only  = "true"
          }
        }

        volume {
          name = "nginx-conf-volume"
          config_map {
            name = "nginx-conf"
          }
        }

        volume {
          name = "index-html-volume"
          config_map {
            name = "index-html"
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_config_map.nginx_conf,
    kubernetes_config_map.index_html,
  ]
}

resource "kubernetes_service" "hello_world" {
  metadata {
    name      = "nginx"
    namespace = local.app
  }
  spec {
    selector = {
      app = kubernetes_deployment.nginx.spec.0.template.0.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }

  depends_on = [
    kubernetes_deployment.nginx,
    helm_release.lb,
  ]
}
