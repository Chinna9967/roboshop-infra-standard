# module "mysql_instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   ami = data.aws_ami.devops_ami.id
#   instance_type = "t3.medium"
#   vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]
#   # it should be in Roboshop DB subnet
#   subnet_id = local.db_subnet_id
#   user_data = file("mysql.sh")
#   tags = merge(
#     {
#         Name = "MySQL"
#     },
#     var.common_tags
#   )
# }

# module "records" {
#   source  = "terraform-aws-modules/route53/aws//modules/records"
#   zone_name = var.zone_name
#   records = [
#     {
#         name    = "mysql"
#         type    = "A"
#         ttl     = 1
#         records = [
#             module.mysql_instance.private_ip
#         ]
#     }
#   ]
# }

# --- MySQL EC2 Instance ---
resource "aws_instance" "mysql" {
  ami                    = data.aws_ami.devops_ami.id
  instance_type          = "t3.medium"
  vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]
  subnet_id              = local.db_subnet_id
  user_data              = file("mysql.sh")

  tags = merge(
    {
      Name = "MySQL"
    },
    var.common_tags
  )
}

# --- MySQL Route53 Record ---
data "aws_route53_zone" "main" {
  name = var.zone_name
}

resource "aws_route53_record" "mysql" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "mysql.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.mysql.private_ip]
}
