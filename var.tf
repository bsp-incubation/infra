variable "db_password" {
    type        = string
    description = "RDS DB instance password should be More than 8 letters."
    default     = "{{db_password}}"
}

variable "db_username" {
    type        = string
    description = "RDS DB instance password should be More than 8 letters."
    default     = "{{db_username}}"
}

variable "db_port" {
    type    = string
    default = "3306"
}

variable "aws_access_key" {
    type        = string
    description = "Your access key"
    default     = "{{aws_access_key}}"
}

variable "aws_secret_key" {
    type        = string
    description = "Your secret key"
    default     = "{{aws_secret_key}}"
}
# ======================================================================
variable "key_name" {
    type    = string
    default = "team2Key"
}

variable "my_region" {
    type    = string
    default = "ap-northeast-2"
}

variable "my_az1" {
    type    = string
    default = "ap-northeast-2a"
}

variable "my_az2" {
    type    = string
    default = "ap-northeast-2c"
}

variable "ui_ami_id" {
    type    = string
    default = "ami-0ecd78c22823e02ef"
}

variable "api_ami_id" {
    type    = string
    default = "ami-0ecd78c22823e02ef"
}

variable "target_group_path" {
    type    = string
    default = "/health"
}
