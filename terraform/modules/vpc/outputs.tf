output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = {
    for s in aws_subnet.public :
    s.availability_zone => s.id
  }
}

output "private_subnets" {
  value = {
    for s in aws_subnet.private :
    s.availability_zone => s.id
  }
}

output "public_subnets_list" {
  value = [for s in aws_subnet.public : s.id]
}

output "private_subnets_list" {
  value = [for s in aws_subnet.private : s.id]
}

output "default_sg_id" {
  value = aws_security_group.default.id
}