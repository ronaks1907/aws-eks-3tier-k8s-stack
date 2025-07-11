terraform {
  backend "s3" {
    bucket  = "terraform-3tier-statefile"
    key     = "statefile/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}
