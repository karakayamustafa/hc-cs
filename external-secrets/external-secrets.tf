provider "helm" {
  kubernetes {
    config_path = "~/.kube/configs/local"
  }
}

resource "helm_release" "external-secrets" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  version          = "0.7.2"
  namespace        = "external-secrets"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = true
  }
}