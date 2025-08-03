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

variable "bastion_tags" {
    default = {
        component = "bastion"
    }
}
