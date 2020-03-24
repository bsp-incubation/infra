variable "password" {
    type        = string
    description = "RDS DB instance password should be More than 8 letters."
}

variable "username" {
    type        = string
    description = "RDS DB instance password should be More than 8 letters."
}

variable "port" {
    type    = string
}


variable "availability_zone1" {
    type    = string
}

variable "availability_zone2" {
    type    = string
}

variable "vpc_id" {
    type    = string
}

variable "external_path" {
    type    = string
}

variable "internal_path" {
    type    = string
}

variable "CRBS-subnet-public-a" {
    type    = string
}
variable "CRBS-subnet-public-c" {
    type    = string
}

variable "CRBS-subnet-private-a" {
    type    = string
}
variable "CRBS-subnet-private-c" {
    type    = string
}

variable "CRBS-security_group-private" {
    type    = string
}