
variable "cidr_vpc" {
  type = string
  default = "10.0.0.0/16"
}

variable "cidr_public_subnet" {
  type = list(string)
  default = ["10.0.1.0/24","10.0.4.0/24"]
}

variable "cidr_private_subnet" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "public" {
  type = bool
  default = true
}
variable environment {
    type = string
    default= "dev"
}

variable engine_name {
    type = string
    default = "mysql"
}

variable engine_version {
    type = string
    default = "8.0"
}

variable storage {
    type = string
    default = "10"
}

variable identifier {
    type = string
    default = "db-mysql-dev"
}

variable instance_class {
    type = string
    default = "db.t2.nano"

}
variable multi_az {
    type = string
    default = "true"
}
variable database_name {
    type = string
    default = "dbmysql"
}

variable database_username {
    type = string
    default = "dbadmin"
}

variable database_password {
    type = string
    default =  "S0methingS3cure!"
}

variable database_port {
    type = string
    default = "3306"
}

variable publicly_accessible {
    type = string
    default = true
}

variable database_snapshot {
    type = string
    default = true
}
variable db_subnet_group_name {
    type = string
    default =  "aws_db_subnet_group.main.id"

}

variable db_security_group {
    type = string
    default =  "aws_security_group.db_security_group.id"
}
# variable nat_subnet_id {
#     type = string
# }

# variable eip_id {
#     type = string
# }

/*
variable "tags_vpc" {
  type = map(any)
}

variable vpc_id {
    type=string
}

v

variable "tags_subnet" {
  type = map(any)
}


variable tags_nat {
    type = map(any)
}



variable igw {
    type = map(any)
}

variable tags_eip{
    type = map(any)
}
*/