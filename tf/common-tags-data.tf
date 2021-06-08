locals {
  common-tags = {
    "project"          = "textract"
    "prov_date"          = timestamp()
    "provisioner" = "Terraform"
  }
}