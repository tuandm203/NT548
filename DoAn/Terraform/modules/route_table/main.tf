resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.nat_gateway_id
  }

  tags = {
    "Name" = "private-route-table"
  }
}

resource "aws_route_table_association" "public_private" {
  for_each       = { for k, v in var.private_subnet_ids : k => v }
  subnet_id      = each.value
  route_table_id = aws_route_table.private.id
}