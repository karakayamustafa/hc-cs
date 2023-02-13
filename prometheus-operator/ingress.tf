provider "kubernetes" {
  config_path = local.config_path
}


resource "kubernetes_manifest" "ingress_monitoring_prometheus_ingress" {
  manifest = {
    "apiVersion" = "networking.k8s.io/v1"
    "kind"       = "Ingress"
    "metadata" = {
      "annotations" = {
        "nginx.ingress.kubernetes.io/auth-realm"  = "Authentication Required"
        "nginx.ingress.kubernetes.io/auth-secret" = "prometheus-auth"
        "nginx.ingress.kubernetes.io/auth-type"   = "basic"
      }
      "name"      = "prometheus-ingress"
      "namespace" = "monitoring"
    }
    "spec" = {
      "ingressClassName" = "nginx"
      "rules" = [
        {
          "host" = "prometheus.example.com"
          "http" = {
            "paths" = [
              {
                "backend" = {
                  "service" = {
                    "name" = "prometheus-operated"
                    "port" = {
                      "number" = 9090
                    }
                  }
                }
                "path"     = "/"
                "pathType" = "Prefix"
              },
            ]
          }
        },
      ]
    }
  }

  depends_on = [
    helm_release.prometheus-operator
  ]
}

resource "kubernetes_manifest" "ingress_monitoring_alertmanager_ingress" {
  manifest = {
    "apiVersion" = "networking.k8s.io/v1"
    "kind"       = "Ingress"
    "metadata" = {
      "annotations" = {
        "nginx.ingress.kubernetes.io/auth-realm"  = "Authentication Required"
        "nginx.ingress.kubernetes.io/auth-secret" = "alertmanager-auth"
        "nginx.ingress.kubernetes.io/auth-type"   = "basic"
      }
      "name"      = "alertmanager-ingress"
      "namespace" = "monitoring"
    }
    "spec" = {
      "ingressClassName" = "nginx"
      "rules" = [
        {
          "host" = "alertmanager.example.com"
          "http" = {
            "paths" = [
              {
                "backend" = {
                  "service" = {
                    "name" = "alertmanager-operated"
                    "port" = {
                      "number" = 9093
                    }
                  }
                }
                "path"     = "/"
                "pathType" = "Prefix"
              },
            ]
          }
        },
      ]
    }
  }

  depends_on = [
    helm_release.prometheus-operator
  ]
}
