variable "public_ip_range" {
  description = "Public IP range for Security Group"
  type        = list(string)
}

variable "private_ip_range" {
  description = "Private IP range for Security Group"
  type        = list(string)
}
