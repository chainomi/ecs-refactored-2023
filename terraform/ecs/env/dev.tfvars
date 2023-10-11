#general
region           = "us-west-1"
application_name = "word-press"
environment      = "development"

service_private_dns_name = "local"

#route 53 domain
route_53_hosted_zone_domain_name = ""
alb_tls_cert_arn                 = ""


services = {
  service_1 = {
    application_name        = "word-press"
    container_image         = "wordpress"
    container_image_version = "latest"
    cpu                     = "512"
    memory                  = "1024"
    container_port          = "8000"
    host_port               = "8000"
    health_check_path       = "/"
    target_group_port       = "80"
    desired_count           = 1
    template_file           = "templates/service_1.json.tpl"
    enable_alb              = true
    http_ingress_port       = "80"
    https_ingress_port      = "443"
    enable_dns              = false
    service_domain          = ""
    enable_ecr              = true
    image_mutability        = "MUTABLE"
  }

  service_2 = {
    application_name        = "mysql"
    container_image         = "mysql"
    container_image_version = "5.7"
    cpu                     = "512"
    memory                  = "1024"
    container_port          = "3306"
    host_port               = "3306"
    health_check_path       = "/"
    target_group_port       = ""
    desired_count           = 1
    template_file           = "templates/service_2.json.tpl"
    enable_alb              = false
    http_ingress_port       = ""
    https_ingress_port      = ""
    enable_dns              = false
    service_domain          = ""
    enable_ecr              = true
    image_mutability        = "MUTABLE"
  }

}



