resource "aws_instance" "public" {
  count                  = var.public_instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[count.index]
  vpc_security_group_ids = [var.public_sg_id]
  key_name               = var.key_name
  user_data = <<-EOF
                #!bin/bash
                echo "PubkeyAcceptedKeyTypes=+ssh-rsa" >> /etc/ssh/sshd_config.d/10-insecure-rsa-keysig.conf
                systemctl reload sshd
                echo "${tls_private_key.ssh.private_key_pem}" >> /home/ubuntu/.ssh/id_rsa
                chown ubuntu /home/ubuntu/.ssh/id_rsa
                chgrp ubuntu /home/ubuntu/.ssh/id_rsa
                chmod 600   /home/ubuntu/.ssh/id_rsa
                EOF

  tags = {
    Name = "Public EC2 ${count.index + 1}"
  }
}

resource "aws_instance" "private" {
  count                  = var.private_instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [var.private_sg_id]
  key_name               = var.key_name
  
  tags = {
    Name = "Private EC2 ${count.index + 1}"
  }
}
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}