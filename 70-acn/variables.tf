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

variable "zone_id" {
  default = "Z011062425344H8RBUU56"
}
