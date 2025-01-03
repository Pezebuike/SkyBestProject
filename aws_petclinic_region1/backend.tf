terraform {
   backend "s3" {
    bucket         = "backend-tra-433211" # change this
    key            = "deepak/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
 }
 }