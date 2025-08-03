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

variable "mysql_tags" {
    default = {
        component = "mysql"
    }
}

variable "backend_tags" {
    default = {
        component = "backend"
    }
}

variable "frontend_tags" {
    default = {
        component = "frontend"
    }
}

variable "ansible_tags" {
    default = {
        component = "ansible"
    }
}
variable "zone_name" {
    default = "chaitanyaproject.online"
}