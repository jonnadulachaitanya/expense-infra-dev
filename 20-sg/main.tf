module "mysql_sg" {
    source = "git::https://github.com/jonnadulachaitanya/terraform-aws-security-group.git?ref=main"
    Project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags
    sg_name = "mysql"
    sg_tags = var.mysql_sg_tags
    vpc_id = local.vpc_id
}


module "backend_sg" {
    source = "git::https://github.com/jonnadulachaitanya/terraform-aws-security-group.git?ref=main"
    Project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags
    sg_name = "backend"
    sg_tags = var.backend_sg_tags
    vpc_id = local.vpc_id


}

module "frontend_sg" {
    source = "git::https://github.com/jonnadulachaitanya/terraform-aws-security-group.git?ref=main"
    Project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags
    sg_name = "frontend"
    sg_tags = var.backend_sg_tags
    vpc_id = local.vpc_id
}

module "bastion_sg" {
    source = "git::https://github.com/jonnadulachaitanya/terraform-aws-security-group.git?ref=main"
    Project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags
    sg_name = "bastion"
    sg_tags = var.bastion_sg_tags
    vpc_id = local.vpc_id
}

module "ansible_sg" {
    source = "git::https://github.com/jonnadulachaitanya/terraform-aws-security-group.git?ref=main"
    Project_name = var.project_name
    environment = var.environment
    common_tags = var.common_tags
    sg_name = "ansible"
    sg_tags = var.ansible_sg_tags
    vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "mysql_accepting_from_backend" {
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    source_security_group_id = module.backend_sg.backend_sg_id
    security_group_id = module.mysql_sg.mysql_sg_id
}


resource "aws_security_group_rule" "backend_accepting_from_frontend" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    source_security_group_id = module.frontend_sg.frontend_sg_id
    security_group_id = module.backend_sg.backend_sg_id    
}

resource "aws_security_group_rule" "frontend_accepting_from_public" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.frontend_sg.frontend_sg_id    
}

resource "aws_security_group_rule" "mysql_accepting_from_bastion" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = module.bastion_sg.bastion_sg_id
    security_group_id = module.mysql_sg.mysql_sg_id    
}

resource "aws_security_group_rule" "backend_accepting_from_bastion" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = module.bastion_sg.bastion_sg_id
    security_group_id = module.backend_sg.backend_sg_id    
}

resource "aws_security_group_rule" "frontend_accepting_from_bastion" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = module.bastion_sg.bastion_sg_id
    security_group_id = module.frontend_sg.frontend_sg_id    
}

resource "aws_security_group_rule" "mysql_accepting_from_ansible" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = module.ansible_sg.ansible_sg_id
    security_group_id = module.mysql_sg.mysql_sg_id
}

resource "aws_security_group_rule" "backend_accepting_from_ansible" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = module.ansible_sg.ansible_sg_id
    security_group_id = module.backend_sg.backend_sg_id
}

resource "aws_security_group_rule" "frontend_accepting_from_ansible" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = module.backend_sg.backend_sg_id
    security_group_id = module.frontend_sg.frontend_sg_id
}

resource "aws_security_group_rule" "bastion_accepting_from_public" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.bastion_sg.bastion_sg_id
}

resource "aws_security_group_rule" "ansible_accepting_from_public" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.ansible_sg.ansible_sg_id
}