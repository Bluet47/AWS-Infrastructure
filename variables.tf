variable "aws_region" {
  default = "eu-west-2"
}

variable "aws_az" {
  default = "eu-west-2a"
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI"
  default     = "ami-02687693a26098eb3"
}
