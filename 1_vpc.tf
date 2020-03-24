// 프로 바이더 설정
// 테라폼과 외부 서비스를 연결해주는 기능
provider "aws" {
    profile    = "aws_provider"
    region     = var.my_region
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
}

// VPC 가상 네트워크 설정
resource "aws_vpc" "CRBS-vpc" {
  cidr_block             = "172.16.0.0/16"
  enable_dns_hostnames   = true  //dns 호스트 네임 활성화
  enable_dns_support     = true
  instance_tenancy       = "default"
  tags = { Name="CRBS-vpc" }  //태그 달아줌
}