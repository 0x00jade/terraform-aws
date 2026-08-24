resource "tls_private_key" "rsa-4096-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "tf_key" {
  content  = tls_private_key.rsa-4096-key.private_key_pem
  filename = var.file_name
}

resource "aws_key_pair" "demo-key-pair-tf" {
  key_name   = "demo-key-pair-tf"
  public_key = tls_private_key.rsa-4096-key.public_key_openssh
}