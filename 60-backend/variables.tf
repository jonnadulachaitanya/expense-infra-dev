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

variable "backend_tags" {
  default = {
    component = "backend"
  }
}

variable "zone_id" {
  default = "chaitanyaprojet.online"
}
