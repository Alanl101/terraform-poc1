############################################
# DB SUBNET GROUP
############################################
resource "aws_db_subnet_group" "rds_subnet" {
  name = "poc-rds-subnet"

  subnet_ids = [
  aws_subnet.public.id,
  aws_subnet.public_2.id
  ]

  tags = {
    Name = "poc-rds-subnet"
  }
}

############################################
# SECURITY GROUP (ECS → RDS only)
############################################
resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = aws_vpc.main.id

  # ECS access
  ingress {
    description = "RDS access from ECS tasks"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  # laptop 32 means 1 machine 
  ingress {
    description = "RDS access from client on laptop"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [
      format("%s/32", var.workip),
      format("%s/32", var.housingip)
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################################
# PARAMETER GROUP (CDC ENABLED)
############################################
resource "aws_db_parameter_group" "postgres_cdc" {
  name   = "postgres-cdc"
  family = "postgres16"

  parameter {
    name         = "rds.logical_replication"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "max_replication_slots"
    value        = "10"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "max_wal_senders"
    value        = "10"
    apply_method = "pending-reboot"
  }
}

############################################
# RDS INSTANCE (POSTGRES 16)
############################################
resource "aws_db_instance" "postgres" {
  identifier = "poc-postgres"

  engine         = "postgres"
  engine_version = "16"
  instance_class = "db.t3.micro"

  username = var.db_username
  password = var.db_password 
  allocated_storage = 20

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  parameter_group_name = aws_db_parameter_group.postgres_cdc.name

  backup_retention_period = 7

  publicly_accessible = true  

  skip_final_snapshot = true

  tags = {
    Name = "poc-postgres"
  }
}