resource "aws_vpc" "attack_range_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "attack_range_igw" {
  vpc_id = aws_vpc.attack_range_vpc.id
}

resource "aws_subnet" "attack_range_subnet" {
  vpc_id                  = aws_vpc.attack_range_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = var.aws_az
  map_public_ip_on_launch = true
}

resource "aws_route_table" "attack_range_rt" {
  vpc_id = aws_vpc.attack_range_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.attack_range_igw.id
  }
}

resource "aws_route_table_association" "attack_range_rta" {
  subnet_id      = aws_subnet.attack_range_subnet.id
  route_table_id = aws_route_table.attack_range_rt.id
}

resource "aws_security_group" "attack_range_sg" {
  name        = "attack-range-sg"
  description = "Allow Splunk, SSH, and Guacamole access"
  vpc_id      = aws_vpc.attack_range_vpc.id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Splunk Web
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Guacamole
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTPS
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSH
  }

  ingress {
    from_port   = 8089
    to_port     = 8089
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Splunk Management Port
  }

  ingress {
    from_port   = 9997
    to_port     = 9997
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Splunk Forwarder
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ssm_role" {
  name = "attack-range-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "attack-range-ssm-profile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_instance" "attack_range_vm" {
  ami                         = var.ami_id
  instance_type               = "t2.micro" # Free-tier eligible
  subnet_id                   = aws_subnet.attack_range_subnet.id
  vpc_security_group_ids      = [aws_security_group.attack_range_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ssm_instance_profile.name
  user_data                   = file("startup.sh")

  tags = {
    Name = "attack-range-vm"
  }
}
