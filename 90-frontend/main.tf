module "frontend" {
  source        = "terraform-aws-modules/ec2-instance/aws"
  name          = local.resource_name
  ami           = data.aws_ami.joindevops
  instance_type = "t2.micro"
  subnet_id     = local.public_subnet_ids


  tags = merge(
    var.common_tags,
    var.frontend_tags,
    {
      Name = local.resource_name
    }
  )
}

resource "null_resource" "frontend" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_ids = module.frontend.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    type     = ssh
    host     = module.frontend.private_ip
    user     = "ec2-user"
    password = "DevOps321"
  }
  provisioner "file" {
    source      = "var.frontend_tags.component.sh"
    destination = "/tmp/frontend.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "sudo chmod +x /tmp/frontend.sh",
      "sudo sh /tmp/frontend.sh ${var.var.frontend_tags.component} ${var.var.environment}"
    ]
  }
}

resource "aws_ec2_instance_state" "frontend" {
  instance_id = module.frontend.id
  state       = "stopped"
  depends_on  = [null_resource.frontend]
}

resource "aws_ami_from_instance" "frontend" {
  name               = local.resource_name
  source_instance_id = module.frontend.id
  depends_on         = [aws_ec2_instance_state.frontend]
}

resource "null_resource" "delete_instance" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_ids = module.frontend.id
  }

  # Bootstrap script can run on any instance of the cluster
  provisioner "local-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    command = "aws ec2 terminate-instances --instance-ids ${module.frontend.id}"
  }
}

resource "aws_lb_target_group" "frontend" {
  name     = local.resource_name
  port     = 80
  protocol = "TCP"
  vpc_id   = local.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    matcher             = "200-299"
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 4
  }
}

resource "aws_launch_template" "frontend" {
  name          = local.resource_name
  image_id      = aws_ami_from_instance.frontend.id
  instance_type = "t2.micro"

  instance_initiated_shutdown_behavior = "terminate"
  update_default_version               = true
  vpc_security_group_ids               = [local.public_subnet_ids]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = local.resource_name
    }
  }
}

resource "aws_autoscaling_group" "frontend" {
  name                      = local.resource_name
  max_size                  = 10
  min_size                  = 2
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 2
  # force_delete              = true
  vpc_zone_identifier = [local.public_subnet_ids]

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 75
    }
    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = local.resource_name
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "project"
    value               = "expense"
    propagate_at_launch = false
  }
}

resource "aws_autoscaling_policy" "example" {
  autoscaling_group_name = aws_autoscaling_group.frontend.name
  name                   = local.resource_name
  policy_type            = "TargetTrackingScaling"
  # ... other configuration ...

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75.0
  }
}


resource "aws_lb_listener_rule" "frontend" {
  listener_arn = local.web_alb_listener_arn
  priority     = 100

  action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.frontend.arn
      }
    }
  }

  condition {
    host_header {
      values = "expense-${var.frontend_tags.component}.${var.environment}.${var.zone_name}"
    }
  }
}
