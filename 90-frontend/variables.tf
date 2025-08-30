variable "project_name" {
  default = "expense"
}

variable "environment" {
  default = "development"
}

variable "common_tags" {
  default = {
    Project     = "expense"
    terraform   = "true"
    Environment = "dev"
  }
}

variable "frontend_tags" {
  default = {
    component = "frontend"
  }
}

variable "zone_name" {
  default = "chaitanyaproject.online"
}
