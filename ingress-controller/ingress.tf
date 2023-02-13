provider "helm" {
  kubernetes {
    config_path = "~/.kube/configs/local"
  }
}

resource "helm_release" "ingress-controller" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.4.2"
  namespace        = "ingress-nginx"
  create_namespace = true

  values = [
    file("${path.root}/values.yml")
  ]

}