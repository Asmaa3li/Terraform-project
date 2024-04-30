terraform {
  backend "s3" {
    bucket = "asmaa-terraform-bucket"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}
