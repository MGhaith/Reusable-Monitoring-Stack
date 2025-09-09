terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "reusable-monitoring-stack-terraform-state"         # S3 bucket name (create once manually or via bootstrap TF)
    key            = "global/terraform.tfstate"                  # Path inside the bucket
    region         = "eu-central-1"                              # Best Region for me
    dynamodb_table = "terraform-locks-monitoring-stack"                      # DynamoDB table for state locking
    encrypt        = true                                        # Encrypt state at rest
  }
}
