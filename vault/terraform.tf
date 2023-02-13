terraform {
  backend "gcs" {
    bucket = "hc-cs-terraform"
    prefix = "terraform/vault"
  }
}
