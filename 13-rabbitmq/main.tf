# module "rabbitmq_instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   ami = data.aws_ami.devops_ami.id
#   instance_type = "t3.medium"
#   vpc_security_group_ids = [data.aws_ssm_parameter.rabbitmq_sg_id.value]
#   # it should be in Roboshop DB subnet
#   subnet_id = local.db_subnet_id
#   user_data = file("rabbitmq.sh")
#   tags = merge(
#     {
#         Name = "rabbitmq"
#     },
#     var.common_tags
#   )
# }

# module "records" {
#   source  = "terraform-aws-modules/route53/aws//modules/records"
#   zone_name = var.zone_name
#   records = [
#     {
#         name    = "rabbitmq"
#         type    = "A"
#         ttl     = 1
#         records = [
#             module.rabbitmq_instance.private_ip
#         ]
#     }
#   ]
# }   

# --- RabbitMQ EC2 Instance ---
resource "aws_instance" "rabbitmq" {
  ami                    = data.aws_ami.devops_ami.id
  instance_type          = "t3.medium"
  vpc_security_group_ids = [data.aws_ssm_parameter.rabbitmq_sg_id.value]
  subnet_id              = local.db_subnet_id
  user_data              = file("rabbitmq.sh")

  tags = merge(
    {
      Name = "rabbitmq"
    },
    var.common_tags
  )
}

# --- RabbitMQ Route53 Record ---
data "aws_route53_zone" "main" {
  name = var.zone_name
}

resource "aws_route53_record" "rabbitmq" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "rabbitmq.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.rabbitmq.private_ip]
}
