locals {
  config_path = "~/.kube/configs/local"
  apps = toset([
    "prometheus",
    "alertmanager"
  ])
}
