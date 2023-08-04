# Create a VPC for EC2 and RDS
resource "aws_vpc" "vpc_main" {
  cidr_block              = "10.0.0.0/16"
}

# Create a subnet for EC2
resource "aws_subnet" "ec2_subnet" {
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = "10.0.1.0/24"
}
 
# Create a subnet for RDS
resource "aws_subnet" "rds_subnet" {
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = "10.0.2.0/24"
}

# Create a security group for EC2
resource "aws_security_group" "ec2_security_group" {
  name_prefix = "ec2-"
  vpc_id      = aws_vpc.vpc_main.id

  # Inbound rule to allow SSH access for EC2 instance (you can customize this as needed)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a security group for RDS
resource "aws_security_group" "rds_security_group" {
  name_prefix = "rds-"
  vpc_id      = aws_vpc.vpc_main.id

  # Inbound rule to allow connections from EC2 security group
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_security_group.id]
  }

    # Outbound rule to allow RDS to communicate with the EC2 instance
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    security_groups = [aws_security_group.ec2_security_group.id]
  }
}

# Create an Elastic IP
resource "aws_eip" "elastic_ip_ec2" {
  vpc = true
}

# Create EC2 instance
resource "aws_instance" "ec2_instance" {
  ami           = var.ami # Replace with the ARM-based AMI ID
  instance_type = var.instance_type
  subnet_id     = aws_subnet.ec2_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  tags          = {
    name        = "wordpress_ec2_instance"
    Description = "An EC2 instance to deploy wordpress application"
  }
  # Associate the Elastic IP with the EC2 instance
  associate_public_ip_address = true
  public_ip                   = aws_eip.elastic_ip_ec2.public_ip

  # Perform deployment and take the latest image of WordPress from Docker, using php-fpm.

  user_data = <<-EOF 
              #!/bin/bash

              # Pull the latest WordPress image from Docker Hub docker pull wordpress:latest    
             
              # Run the WordPress container with PHP-FPM and expose port 80
              docker run -d \
                --name wordpress-container \
                -p 80:80 \
                -v /path/to/wordpress:/var/www/html \
                wordpress:latest

              EOF
  # Add any other configurations you need for your EC2 instance
}

# Create RDS instance
resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 20
  engine               = "mysql" # Change to your desired database engine
  instance_class       = "db.t4g.micro"
  name                 = "my-rds-instance"
  username             = "dbuser"
  password             = "dbpassword"
  subnet_group_name    = "my-db-subnet-group"
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  publicly_accessible  = false # Make sure RDS is not publicly accessible

  # Add any other configurations you need for your RDS instance
}

# Create DB Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.rds_subnet.id]
}




