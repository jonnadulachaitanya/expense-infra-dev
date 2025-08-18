resource "aws_key_pair" "openvpn" {
  key_name   = "openvpn"
  public_key = file("E:/devops/Keys/openvpn.pub")
}


module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = local.resource_name
  ami = data.aws_ami.joindevops.id
  key_name = aws_key_pair.openvpn.key_name
  associate_public_ip_address = true

  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.vpn_sg_id]
  subnet_id              = local.public_subnet_ids

  tags = merge(
        var.common_tags,
        var.vpn_tags,
        {
            Name = local.resource_name
        }
    )

}