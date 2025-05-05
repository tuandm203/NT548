region               = "us-east-1"
vpc_name             = "nhom13_vpc"
vpc_cidr_block       = "10.0.0.0/16"
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnet_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones   = ["ap-southeast-1a", "ap-southeast-1b"]
ami_id               = "ami-0e8ebb0ab254bb563" # Amazon Linux 2 AMI (HVM), SSD Volume Type
instance_type        = "t2.micro"              # Replace with your subnet ID
key_name             = "aws-koro"
allowed_ip_range     = ["0.0.0.0/0"]

public_ip_range  = ["192.168.1.0/24"]
private_ip_range = ["10.0.0.0/24"]
