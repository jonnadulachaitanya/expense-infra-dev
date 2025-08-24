module "backend" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = local.resource_name
  ami  = data.aws_ami.joindevops.id

  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.backend_sg_id]
  subnet_id              = local.private_subnet_ids

  tags = merge(
    var.common_tags,
    var.backend_tags,
    {
      Name = local.resource_name
    }
  )

}

resource "null_resource" "backend" {
  triggers = {
    instance_id = module.backend.id
  }

  connection {
    host     = module.backend.private_ip
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
  }

  provisioner "file" {
    source      = "${var.backend_tags.component}.sh"
    destination = "/tmp/backend.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/backend.sh",
      "sudo sh /tmp.backend.sh ${var.backend_tags.component} ${var.environment}"
    ]

  }


}


