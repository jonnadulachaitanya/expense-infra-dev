variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "expense"
        terraform = "true"
        Environment = "dev"
    }
}

variable "zone_name" {
    default = "chaitanyaproject.online"
}

variable "app_alb_tags" {
    default = {
        component = "app-alb"
    }
}
