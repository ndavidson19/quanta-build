terraform {
  backend "s3" {
    bucket = "quanta-terraform-state"
    key    = "quanta/terraform.tfstate"
    region = "us-west-2"
  }
}