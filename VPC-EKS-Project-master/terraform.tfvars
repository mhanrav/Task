cidr_block = {
  "ap-south-1" : "10.11.0.0/16"
  "ap-south-2" : "10.21.0.0/16"

}
public_subnets = {
  "ap-south-1" : ["10.11.10.0/24", "10.11.20.0/24"]
  "ap-south-2" : ["10.21.10.0/24", "10.21.20.0/24"]
  
}

private_subnets = {
  "ap-south-1" : ["10.11.110.0/24", "10.11.120.0/24"]
  "ap-south-2" : ["10.21.110.0/24", "10.21.120.0/24"]

}

DEFAULT_TAGS = {
  CreatedBy = "Terraform"
  User   = "DMohanram"
}