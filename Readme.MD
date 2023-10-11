# Deploy ECR and ECS with multiple services

## Instructions

### Prep
1. Create a backend bucket
2. Update region in 'terraform/ecs/env/<env>.tfvars'
3. Update bucket info in 'terraform/ecr/<env>_backend.tf' and 'terraform/ecs/<env>_backend.tf'


### Build ECR
1. Enter terraform folder - 'cd terraform/ecr/' 
2. Terraform init - 'terraform init -backend-config=./config/<env>_backend.conf'
3. Terraform plan -'terraform plan -var-file=../ecs/env/<env>.tfvars'
4. Terraform apply - 'terraform apply -var-file=../ecs/env/<env>.tfvars --auto-approve'

### Docker build 
1. docker build -t <image_name> </path/to/dockerfile>

### Docker push - from ecr folder
1. login to ECR - `aws ecr get-login-password --region $(terraform output -raw region) | docker login --username AWS --password-stdin $(terraform output -raw aws_account_id).dkr.ecr.$(terraform output -raw region).amazonaws.com`
2. Tag image for ECR - `docker tag flask_app:latest $(terraform output -json ecr_repo_url_map | jq -r '.service_1'):latest`
   a. change the service name in the command above accordingly e.g. service_1 is used above 
3. Push image to ECR - `docker push $(terraform output -json ecr_repo_url_map | jq -r '.service_1'):latest`


### Build ECS cluster
1. Enter the terraform ecs folder - 'cd terraform/ecs/'
2. Update parameters for each of the services e.g. container image, version, ports, domains, namespace, etc. The example uses word press as one service and mysql as the second service
ECS
2. Update environment section of task definition templates in 'terraform/ecs/templates/'
cd ../ecs/
3. Terraform init - 'terraform init -backend-config=./config/<env>_backend.conf'
4. Terraform plan - 'terraform plan -var-file=./env/<env>.tfvars'
5. Terraform apply - 'terraform apply -var-file=./env/<env>.tfvars --auto-approve


