output "vm_public_ip" {
  description = "Public IP of the Attack Range EC2 instance"
  value       = aws_instance.attack_range_vm.public_ip
}
