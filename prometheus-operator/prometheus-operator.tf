provider "helm" {
  kubernetes {
    config_path = local.config_path
  }
}

resource "helm_release" "prometheus-operator" {
  name             = "prometheus-operator"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "45.0.0"
  namespace        = "monitoring"
  create_namespace = true

  values = [
    file("${path.root}/values.yml")
  ]

}
