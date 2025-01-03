terraform {
  backend "s3" {
    bucket  = "backend-tra-433211"
    key     = "infra.tfstate"
    region  = "ap-south-1"
    profile = "default"
    dynamodb_table = "vegeta-terraform-remote-state-table"
  }
}