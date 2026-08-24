variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "file_name" {
  description = "Local file name for private key"
  type        = string
}

variable "instance_type" {
  type        = string
  default     = "t3a.small"
  description = "EC2 instance size"
}
