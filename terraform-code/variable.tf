variable "key_name" {
  default = "terraform-demo-mt-key-pair"
}

variable "pvt_key_name" {
  default = "/root/.ssh/terraform-demo-mt-key-pair.pem"
}


variable "sg_id" {
  default = "sg-0557f753e5a2ea639"
}


variable "ami_id" {
  default = "ami-05803413c51f242b7"
}


variable "region" {
  default = "us-east-2"
}

variable "instances" {
  default = 2
}

