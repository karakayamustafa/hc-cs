provider "helm" {
  kubernetes {
    config_path = "~/.kube/configs/local"
  }
}

resource "helm_release" "vault" {
  name             = "vault"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault"
  version          = "0.23.0"
  namespace        = "vault"
  create_namespace = true

  set {
    name  = "server.dataStorage.storageClass"
    value = "vault"
  }

  set {
    name  = "server.ingress.enabled"
    value = true
  }

  set {
    name  = "server.ingress.ingressClassName"
    value = "nginx"
  }

  set {
    name  = "server.ingress.hosts[0].host"
    value = "vault.example.com"
  }
}