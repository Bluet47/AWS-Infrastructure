variable "aws_region" {
  default = "eu-west-2"
}

variable "aws_az" {
  default = "eu-west-2a"
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI"
  default     = "ami-0e5f882be1900e43b"
}
