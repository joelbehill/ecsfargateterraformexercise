output "alb_url" {
  value = aws_alb.application_load_balancer.dns_name
}

output "joelsecret" {
  value = aws_iam_access_key.joelkey.encrypted_secret
}
