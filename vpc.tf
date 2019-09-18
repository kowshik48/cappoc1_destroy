#vpc.tf
provider "aws" {
	region = "${var.region}"
	access_key = "${var.access_key}"
    	secret_key = "${var.secret_key}"
	version = "~> 2.0"
}


terraform {
  backend "s3" {
    region  = "ap-southeast-1"
    bucket  = "capgeminipoc-terraform-praveen-1"
    key     = "trss/terraform.tfstate"
    encrypt = true
      }
}
#create VPC dddd
#=================================================
resource "aws_vpc" "poc_vpc"{
	cidr_block = "${var.vpcCIDRblock}"
	tags = {
	Name = "poc_vpc"
	}
}

#Create public Subnet
#=================================================
resource "aws_subnet" "poc_public_subnet"{
	vpc_id ="${aws_vpc.poc_vpc.id}"
	cidr_block="${var.poc_public_subnet}"
	map_public_ip_on_launch ="${var.mapPublicIP}"
		tags = {
	Name = "poc_public_subnet"
	}
	
}

#Create private subnet
#==================================================
resource "aws_subnet" "poc_private_subnet"{
	vpc_id="${aws_vpc.poc_vpc.id}"
	cidr_block = "${var.poc_private_subnet}"
	map_public_ip_on_launch="${var.mapPublicIP}"
	tags = {
			Name ="poc_private_subnet"
			}
}

# Create Security Group
#===================================================
resource "aws_security_group" "poc_vpc_security_group" {
  vpc_id       = "${aws_vpc.poc_vpc.id}"
  
  name         = "My VPC Security Group"
  description  = "My VPC Security Group"
ingress {
    cidr_blocks = "${var.sgvpcCIDRblock}"  
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }
tags = {
        Name = "POC_Security_Group"
  }
}


#Create Internet Gateway
#========================================================
resource "aws_internet_gateway" "poc_igw"{
	vpc_id = "${aws_vpc.poc_vpc.id}"
	tags = {
		Name = "myPocIGW"
		}
}

#create route table
#=======================================================
resource "aws_route_table" "poc_vpc_route_table" {
    vpc_id = "${aws_vpc.poc_vpc.id}"
tags ={
        Name = "My POC VPC Route Table"
		}
}

#Internet Access
#=======================================================
resource "aws_route" "poc_vpc_internet_access" {
  route_table_id        = "${aws_route_table.poc_vpc_route_table.id}"
  destination_cidr_block = "${var.destinationCIDRblock}"
  gateway_id             = "${aws_internet_gateway.poc_igw.id}"
  
} 

# Associate the Route Table with the Subnet
#===========================================================
resource "aws_route_table_association" "poc_vpv_association" {
    subnet_id      = "${aws_subnet.poc_public_subnet.id}"
    route_table_id = "${aws_route_table.poc_vpc_route_table.id}"
} # end resource



#Create an instance
#==========================================================
resource "aws_instance" "poc_instance" {
  ami           = "${var.instance_ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "${aws_subnet.poc_public_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.poc_vpc_security_group.id}"]
  key_name = "${var.key_name}"
}
#outputs
#======================================================
output "my_vpc" {
  value = "${aws_vpc.poc_vpc}"
}

output "poc_public_subnet" {
  value = "${aws_subnet.poc_public_subnet}"
}
output "poc_private_subnet" {
  value = "${aws_subnet.poc_private_subnet}"
}

output "poc_instance" {
  value = "${aws_instance.poc_instance}"
}
