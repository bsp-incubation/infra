# ====================================================create RDS========================================
resource "aws_db_subnet_group" "CRBS-rds-subnet-group" {
  name       = "crbs-rds-subnet-group"
  subnet_ids = [var.CRBS-subnet-private-a, var.CRBS-subnet-private-c]
  description = "RDS subnet group for CRBS"
  tags = { Name = "crbs-rds-subnet-group" }
}

resource "aws_db_instance" "CRBS-rds-instance" {
  identifier           = "crbs-rds-instance"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.17"
  instance_class       = "db.t2.micro"
  username             = var.username
  password             = var.password
  port              = var.port
  db_subnet_group_name = aws_db_subnet_group.CRBS-rds-subnet-group.name
  multi_az             = true
  vpc_security_group_ids = [var.CRBS-security_group-private]
  skip_final_snapshot = true
}