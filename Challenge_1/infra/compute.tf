resource "aws_autoscaling_group" "tier3_asg" {
  name                 = "tier3_asg"
  launch_configuration = aws_launch_configuration.tier3_asg_config.id
  vpc_zone_identifier  = [aws_subnet.public_subnet[0].id,aws_subnet.public_subnet[1].id]
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1

}

resource "aws_launch_configuration" "tier3_asg_config" {
  name_prefix                 = "tier3_asg_config"
  image_id                    = "ami-0df435f331839b2d6"
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.sg_3tier.id]
  user_data = <<-EOF
                                !/bin/bash

                                # Update the system
                                sudo yum -y update

                                # Install Apache web server
                                sudo yum -y install httpd

                                # Start Apache web server
                                sudo systemctl start httpd.service

                                # Enable Apache to start at boot
                                sudo systemctl enable httpd.service
                        EOF
}

resource "aws_lb" "tier3_alb" {
  name               = "tier3-alb"
  internal           = true
  load_balancer_type = "application"

  #security_groups    = [aws_security_group.three-tier-alb-sg-1.id]
  subnets             = [aws_subnet.public_subnet[0].id,aws_subnet.public_subnet[1].id ]

  tags = {
    Environment = "three-tier-web-lb"
  }
}

# create load balancer larget group - web tier

resource "aws_lb_target_group" "tier3_target" {
  name     = "target-lb"
  port     = 80
  protocol = "HTTP"
  vpc_id = module.tier3_vpc.tier3_vpc_id

  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Create Load Balancer listener - web tier
resource "aws_lb_listener" "tier3_listener" {
  count          = length(var.cidr_public_subnet)
  load_balancer_arn = aws_lb.tier3_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tier3_target.arn
  }
}

# Register the instances with the target group - web tier
resource "aws_autoscaling_attachment" "three-tier-web-asattach" {
  autoscaling_group_name = aws_autoscaling_group.tier3_asg.id
  lb_target_group_arn   = aws_lb_target_group.tier3_target.arn
}


## app instance

resource "aws_autoscaling_group" "tier3_asg_app" {
  name                 = "tier3_asg_app"
  launch_configuration = aws_launch_configuration.tier3_asg_config.id
  vpc_zone_identifier  = [aws_subnet.private_subnet1[0].id,aws_subnet.private_subnet1[1].id]
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1

}

resource "aws_launch_configuration" "tier3_asg_config_app" {
  name_prefix                 = "tier3_asg_config_app"
  image_id                    = "ami-0df435f331839b2d6"
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.sg_3tier.id]
  user_data = <<-EOF
                                !/bin/bash

                                sudo yum install mysql -y
                        EOF
}


