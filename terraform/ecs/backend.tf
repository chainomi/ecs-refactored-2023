terraform {
    backend "s3" {
        key = "dev/ecs/terraform.state" 
        #use <env>/terraform-state as value for key
        region ="us-west-1"

    }
}