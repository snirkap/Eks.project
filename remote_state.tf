terraform {
  backend "s3" {
    bucket = "eks-tf-state-file-backup"
    key    = "backup/terraform.tfstate"
    region = "us-east-1"
  }
}