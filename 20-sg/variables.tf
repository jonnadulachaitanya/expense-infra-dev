variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "development"
}

variable "common_tags" {
    default = {
        Project = "expense"
        terraform = "true"
        Environment = "dev"
    }
}

variable "mysql_sg_tags" {
    default = {
        component = "mysql"
    }
}

variable "backend_sg_tags" {
    default = {
        component = "backend"
    }
}

variable "frontend_sg_tags" {
    default = {
        component = "frontend"
    }
}
variable "bastion_sg_tags" {
    default = {
        component = "frontend"
    }
}

variable "ansible_sg_tags" {
    default = {
        component = "ansible"
    }
}