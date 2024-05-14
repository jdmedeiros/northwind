resource "aws_db_instance" "database" {
  allocated_storage             = 19
  auto_minor_version_upgrade    = true
  copy_tags_to_snapshot         = true
  delete_automated_backups      = true
  engine                        = "mysql"
  engine_version                = "8.0.35"
  identifier                    = "northwind"
  instance_class                = "db.t3.micro"
  iops                          = 0
  max_allocated_storage         = 30
  option_group_name             = "default:mysql-8-0"
  parameter_group_name          = "northwind"
  port                          = var.port
  skip_final_snapshot           = false
  publicly_accessible           = true
  multi_az                      = false
  storage_type                  = "gp2"
  tags = {
    "Org" = "ENTA"
  }
  username                      = var.user
  password                      = var.password
  vpc_security_group_ids        = [aws_security_group.db_security_group.id]

  timeouts {
    create = "10m"
    update = "20m"
    delete = "15m"
  }

  depends_on = [
    aws_db_parameter_group.northwind
  ]
}

resource "aws_security_group" "db_security_group" {
  name        = "db-security-group"
  description = "DB security group"

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.ip_list
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "db-security-group"
  }
}

resource "aws_db_parameter_group" "northwind" {
  name        = "northwind"
  family      = "mysql8.0"
  description = "Parameter group for the Northwind database"

  parameter {
    name         = "log_bin_trust_function_creators"
    value        = "1"
    apply_method = "immediate"
  }

  tags = {
    "Name" = "northwind-parameter-group"
  }
}

resource "aws_instance" "mysqlcli" {
  ami             = "ami-04b70fa74e45c3917"
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.mysqlcli.name]
  key_name        = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    apt-get update && apt-get -y upgrade && apt-get -y install mysql-client
    wget --output-document northwind.sql https://raw.githubusercontent.com/jdmedeiros/northwind/main/Northwind.sql
    mysql -u ${var.user} -p${var.password} -h ${aws_db_instance.database.endpoint} < northwind.sql
  EOF

  depends_on = [
    aws_db_instance.database
  ]
}

resource "aws_security_group" "mysqlcli" {
  name        = "mysqlcli-security-group"
  description = "MySQL Client Security Group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ip_list
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "mysqlcli-security-group"
  }
}
