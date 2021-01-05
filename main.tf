# Create a RDS instance and import the Nothwind database
# Run the runme script to create the RDS instance and import the Northwind database
# To destroy the RDS instance, run:
# terraform destroy --auto-approve
# You may need to run it twice because de parameter group fails the first time

resource "aws_db_instance" "database" {
  allocated_storage = 19
  auto_minor_version_upgrade = true
  engine = "mysql"
  engine_version = "5.7.31"
  identifier = "northwind"
  instance_class = "db.t2.micro"
  iops = 0
  max_allocated_storage = 20
  option_group_name = "default:mysql-5-7"
  parameter_group_name = "northwind"
  port = var.port
  publicly_accessible = true
  storage_type = "gp2"
  tags = {
    "Org" = "ENTA"
  }
  username = "admin"
  password = "Passw0rd#SuperSecreta"
  vpc_security_group_ids = [
    aws_security_group.db-security-group.id,
  ]
  timeouts {
    create = "10m"
    update = "20m"
    delete = "15m"
  }
}

resource "aws_security_group" "db-security-group" {
  description = "DB security group"
  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description = ""
      from_port = 0
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      protocol = "-1"
      security_groups = []
      self = false
      to_port = 0
    },
  ]
  ingress = [
    {
      cidr_blocks = [
      for _ip in var.ip_list:
      _ip
      ]

      description = ""
      from_port = var.port
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      protocol = "tcp"
      security_groups = []
      self = true
      to_port = var.port
    },
  ]
  name = "db-security-group"
  tags = {}
  timeouts {}
}

# aws_db_parameter_group.northwind:
resource "aws_db_parameter_group" "northwind" {
  description = "Parameter group for the Northwind database"
  family = "mysql5.7"
  name = "northwind"
  tags = {}

  parameter {
    apply_method = "immediate"
    name = "log_bin_trust_function_creators"
    value = "1"
  }
}

resource "aws_instance" "mysqlcli" {
  ami = "ami-0885b1f6bd170450c"
  instance_type = "t2.micro"
  security_groups = [
    "mysqlcli-security-group",
  ]
  vpc_security_group_ids = [
    aws_security_group.mysqlcli.id,
  ]
  user_data = <<-EOF
      #!/bin/bash
      apt-get update && apt-get -y upgrade && apt-get -y install mysql-client
      wget --output-document northwind.sql https://raw.githubusercontent.com/jdmedeiros/northwind/main/Northwind.sql
      mysql -u ${var.user} -p${var.password} -h northwind.chiscfte01ei.us-east-1.rds.amazonaws.com < northwind.sql
      EOF

  depends_on = [
    aws_db_instance.database
  ]
}

  resource "aws_security_group" "mysqlcli" {
  description = "MySQL Client EMAIL Security Group"
  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description = ""
      from_port = 0
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      protocol = "-1"
      security_groups = []
      self = false
      to_port = 0
    },
  ]
  name = "mysqlcli-security-group"
}
