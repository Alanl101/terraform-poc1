variable "db_username" {}
variable "db_password" {}

variable "housingip" {
    type        = string
    description = "Public IPv4 address of laptop used for RDS access"
}

variable "workip" { 
    description = "Public IPv4 address of laptop work used for RDS access"
}