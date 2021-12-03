resource "aws_instance" "backend" {
  ami                    = var.ami_id
  count                  = var.instances
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [var.sg_id]
  lifecycle {
    prevent_destroy = false
  }
  tags = {
    Name = "Dev-App-${count.index + 1}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.pvt_key_name)
    host        = self.public_ip
  }


  provisioner "remote-exec" {
    inline = [
      "sudo sleep 30",
      "sudo apt-get update -y",
      "sudo apt-get install apache2 python sshpass -y"
    ]

  }
}

resource "null_resource" "ansible-setup" {
  count = var.instances
  provisioner "local-exec" {
    command = <<EOT
       > tomcat-ci.ini;
       echo "[tomcat-ci-${count.index + 1}]"|tee -a tomcat-ci.ini;
       echo "${aws_instance.backend[count.index].public_ip}"|tee -a tomcat-ci.ini;
     EOT
  }
  depends_on = [aws_instance.backend]
}

resource "null_resource" "ansible-main" {
  provisioner "local-exec" {
    command = <<EOT
       export ANSIBLE_HOST_KEY_CHECKING=False;
       ansible-playbook --key-file=${var.pvt_key_name} -i tomcat-ci.ini -u ubuntu ./ansible-code/petclinic.yaml -v 
     EOT
  }
  depends_on = [null_resource.ansible-setup]
}



