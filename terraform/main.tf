provider "aws" {
  region = "sa-east-1"
}

resource "aws_instance" "nginx" {
  ami                         = "ami-054a31f1b3bf90920"
  subnet_id                   = "subnet-0b860065fe32e6a4d"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "dev-lucgabm-tf"
  vpc_security_group_ids      = ["${aws_security_group.jenkins.id}"]
  root_block_device {
    encrypted   = true
    volume_size = 8
  }
  tags = {
    Name = "jenkins-lucgabm-nginx"
  }
}

resource "aws_security_group" "jenkins" {
  name        = "jenkins_lucgabm_nginx"
  description = "jenkins_lucgabm_nginx inbound traffic"
  vpc_id      = "vpc-0b501dd42856d509b"
  ingress = [
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null,
      security_groups : null,
      self : null
    },
    {
      description      = "SSH from VPC"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null,
      security_groups : null,
      self : null
    },
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"],
      prefix_list_ids  = null,
      security_groups : null,
      self : null,
      description : "Libera dados da rede interna"
    }
  ]
  tags = {
    Name = "jenkins_lucgabm_nginx"
  }
}

# terraform refresh para mostrar o ssh
output "nginx" {
  value = [
    "nginx",
    "id: ${aws_instance.nginx.id}",
    "private: ${aws_instance.nginx.private_ip}",
    "public: ${aws_instance.nginx.public_ip}",
    "public_dns: ${aws_instance.nginx.public_dns}",
    "ssh -i ~/.ssh/id_rsa ubuntu@${aws_instance.nginx.public_dns}"
  ]
}
