terraform {
    backend "s3" {
        key = "dev/ecr/terraform.state" 
        #use <env>/terraform-state as value for key
        region ="us-west-1"

    }
}