resource "aws_instance" "anpupu" {
  ami             = "ami-0532913178263be11"
  instance_type   = "t3a.small"
  key_name        = aws_key_pair.demo-key-pair-tf.key_name
  security_groups = [aws_security_group.demo-sg.name]

  user_data = <<-EOF
  #!/bin/bash
  sudo apt update -y
  sudo apt-get install docker.io -y
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo apt install unzip
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  DOCKER_CONFIG=$${DOCKER_CONFIG:-$HOME/.docker}
  mkdir -p $DOCKER_CONFIG/cli-plugins
  curl -SL https://github.com/docker/compose/releases/download/v2.35.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
  chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
  
EOF

  tags = {
    Name = "anpupu"
  }
}

resource "aws_security_group" "demo-sg" {
  name = "demo-sg"

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
