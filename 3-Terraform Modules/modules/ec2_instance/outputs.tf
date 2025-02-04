output "instance_id" {
    value = aws_instance.example_instance.id
}

output "instance_public_ip" {
    value = module.ec2_instance.example_instance.instance_public_ip
}
