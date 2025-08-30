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

variable "zone_id" {
  default = "Z07531171JTKXQEA9NV0O"
}
