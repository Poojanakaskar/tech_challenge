module "tier3_vpc" {
  source   = "./modules/vpc"
  cidr_vpc = var.cidr_vpc
}

module "my_igw" {
  source   = "./modules/internet_gateway"
  vpc_id = module.tier3_vpc.tier3_vpc_id
  
}



resource "aws_subnet" "public_subnet" {
  vpc_id                  = module.tier3_vpc.tier3_vpc_id
  cidr_block              = element(var.cidr_public_subnet,count.index)
  count                   = length(var.cidr_public_subnet)

  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = var.public
  
}

resource "aws_subnet" "private_subnet1" {
  vpc_id                  = module.tier3_vpc.tier3_vpc_id
  count                   = length(var.cidr_private_subnet)
  cidr_block              = element(var.cidr_private_subnet,count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = var.public

}

resource "aws_nat_gateway" "tier3_nat" {
  subnet_id     =  aws_subnet.public_subnet[0].id #aws_subnet.my_public_subnet1.id
  allocation_id = aws_eip.tier3_eip.id

  
}

resource "aws_eip" "tier3_eip" {
  depends_on     = [module.my_igw] 

}

resource "aws_route_table" "public_route_table" {
  vpc_id = module.tier3_vpc.tier3_vpc_id

  tags = {
    Name = "public_route_table"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.my_igw.tier3_igw_id
  }
}
##  Route Tables
resource "aws_route_table" "private_route_table" {
  vpc_id = module.tier3_vpc.tier3_vpc_id

  tags = {
    Name = "private_route_table"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.tier3_nat.id
  }
}


## Route Table Association

resource "aws_route_table_association" "public_sub_association" {
  count          = length(var.cidr_public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_sub_association" {
  count          = length(var.cidr_private_subnet)
  subnet_id      = aws_subnet.private_subnet1[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}


####Security group

resource "aws_security_group" "sg_3tier" {
   vpc_id = module.tier3_vpc.tier3_vpc_id
# Inbound Rules
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# Outbound Rules
  # Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
## security group for db

resource "aws_security_group" "database-sg" {
  name        = "Database SG"
  description = "Allow inbound traffic from application layer"
   vpc_id = module.tier3_vpc.tier3_vpc_id
ingress {
    description     = "Allow traffic from application layer"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    #security_groups = [aws_security_group.sg_3tier]
  }
egress {
    from_port   = 32768
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




