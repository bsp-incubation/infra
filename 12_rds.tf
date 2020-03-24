# ====================================================create RDS========================================
resource "aws_db_subnet_group" "CRBS-rds-subnet-group" {
  name       = "crbs-rds-subnet-group"
  subnet_ids = [aws_subnet.CRBS-subnet-private-a.id, aws_subnet.CRBS-subnet-private-c.id]
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
  username             = var.db_username
  password             = var.db_password
  port              = var.db_port
  db_subnet_group_name = aws_db_subnet_group.CRBS-rds-subnet-group.name
  multi_az             = true
  vpc_security_group_ids = [aws_security_group.CRBS-security_group-private.id]
  skip_final_snapshot = true
}