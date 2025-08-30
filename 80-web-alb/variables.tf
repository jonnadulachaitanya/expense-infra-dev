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
  default = "chaitanyaproject.online"
}

variable "web_alb_tags" {
  default = {
    component = "web-alb"
  }
}

variable "zone_id" {
  default = "Z07531171JTKXQEA9NV0O"
}

