variable "key_name" {
    type    = string
    default = "hanju"
}

variable "my_region" {
    type    = string
    default = "ap-northeast-2"
}

variable "availability_zone1" {
    type    = string
    default = "ap-northeast-2a"
}

variable "availability_zone2" {
    type    = string
    default = "ap-northeast-2c"
}

variable "vpc_id" {
    type    = string
}

variable "CRBS-igw" {
    type    = string
}

variable "CRBS-natgateway" {
    type    = string
}

variable "CRBS-instace_profile" {
    type    = string
}

variable "CRBS-codedeploy-app" {
    type    = string
}

variable "target_group_external_path" {
    type    = string
    default = "/"
}

variable "target_group_internal_path" {
    type    = string
    default = "/health"
}

variable "CRBS-security_group-public" {
    type    = string
}