output "vpc_id" {
    value = module.vpc.vpc_id
}

output "ig_id" {
    value = module.vpc.ig_id
}

output "az_info" {
    value = module.vpc.az_info
}


# #az_info = {
# #  names                  = [
# #           + "us-east-1a",
# #           + "us-east-1b",
# #           + "us-east-1c",
# #           + "us-east-1d",
# #           + "us-east-1e",
# #           + "us-east-1f",
# #  ]
# }

# aws_availability_zones = az_info.names[0,1,2,3,4,5]


output "aws_vpc_default" {
    value = module.vpc.aws_vpc_default 
}

output "main_route_table_info" {
    value = module.vpc.main_route_table_info
}

output "db_subnet_group_name" {
    value = module.vpc.db_subnet_group_name
}