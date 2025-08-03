variable "aws_region" {
  default = "eu-west-2"
}

variable "aws_az" {
  default = "eu-west-2a"
}

variable "ami_id" {
  description = "Ubuntu AMI ID"
  default     = "ami-0cbe2951c5f556bb1" # Ubuntu 22.04 LTS for eu-west-2
}
