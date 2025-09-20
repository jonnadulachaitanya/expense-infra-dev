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

variable "zone_name" {
  default = "chaitanyaproject.shop"
}

variable "web_alb_tags" {
  default = {
    component = "web-alb"
  }
}

