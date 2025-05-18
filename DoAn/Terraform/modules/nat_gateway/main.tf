
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "public" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_ids[0]

  tags = {
    Name = "nat-gateway"
  }
}