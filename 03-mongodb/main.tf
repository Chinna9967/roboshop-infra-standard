# module "mongodb_instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   ami = data.aws_ami.devops_ami.id
#   instance_type = "t3.medium"
#   vpc_security_group_ids = [data.aws_ssm_parameter.mongodb_sg_id.value]
#   # it should be in Roboshop DB subnet
#   subnet_id = local.db_subnet_id
#   user_data = file("mongodb.sh")
#   tags = merge(
#     {
#         Name = "MongoDB"
#     },
#     var.common_tags
#   )
# }

resource "aws_instance" "mongodb_instance" {
  ami                    = data.aws_ami.devops_ami.id
  instance_type          = "t3.medium"
  vpc_security_group_ids = [data.aws_ssm_parameter.mongodb_sg_id.value]
  subnet_id              = local.db_subnet_id
  user_data              = file("mongodb.sh")

  tags = merge(
    {
      Name = "MongoDB"
    },
    var.common_tags
  )
}


# module "records" {
#   source  = "terraform-aws-modules/route53/aws//modules/records"
#   zone_name = var.zone_name
#   records = [
#     {
#         name    = "mongodb"
#         type    = "A"
#         ttl     = 1
#         records = [
#             module.mongodb_instance.private_ip
#         ]
#     }
#   ]
# }

resource "aws_route53_record" "mongodb" {
  zone_id = var.zone_id  # or use var.zone_id
  name    = "mongodb.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.mongodb_instance.private_ip]

}
