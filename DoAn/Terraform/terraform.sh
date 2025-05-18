terraform init   # Khoi tao Terraform Project
terraform plan   # kiem tra 
terraform fmt    # format  
terraform apply -auto-approve   # Trien khai 
terraform destroy -auto-approve # Xoa 
# terraform apply -var-file="production.tfvars"
terraform import module.eks.kubernetes_config_map.aws_auth kube-system/aws-auth
aws eks update-kubeconfig  --name  da_vpc-eks --region ap-southeast-1
