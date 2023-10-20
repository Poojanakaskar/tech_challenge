

output nat_id {
    value = aws_nat_gateway.tier3_nat.id
}

output eip_id {
    value = aws_eip.tier3_eip.id
}
output "db" {
    value = aws_db_instance.three-tier-db.arn
  
}

