module "backend" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = local.resource_name
  ami  = data.aws_ami.joindevops.id

  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.backend_sg_id]
  subnet_id              = local.private_subnet_id

  tags = merge(
    var.common_tags,
    var.backend_tags,
    {
      Name = local.resource_name
    }
  )

}

resource "null_resource" "backend" {
  triggers = {
    instance_id = module.backend.id
  }

  connection {
    host     = module.backend.private_ip
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
  }

  provisioner "file" {
    source      = "${var.backend_tags.component}.sh"
    destination = "/tmp/backend.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/backend.sh",
      "sudo sh /tmp/backend.sh ${var.backend_tags.component} ${var.environment}"
    ]
  }
}

resource "aws_ec2_instance_state" "backend" {
  instance_id = module.backend.id
  state       = "stopped"
  depends_on  = [null_resource.backend]
}

resource "aws_ami_from_instance" "backend" {
  name               = local.resource_name
  source_instance_id = module.backend.id
  depends_on         = [aws_ec2_instance_state.backend]
}

resource "null_resource" "backend_delete" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.backend.id
  }

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${module.backend.id}"
  }
  depends_on = [aws_ami_from_instance.backend]
}

resource "aws_lb_target_group" "backend" {
  name     = local.resource_name
  port     = 8080
  protocol = "TCP"
  vpc_id   = local.vpc_id

  health_check {
    healthy_threshold   = 2 #2 requests success then it is fine
    unhealthy_threshold = 2 #2 requests failed contineously then it is failed
    interval            = 5 #every 5 sec
    matcher             = "200-299"
    path                = "/health"
    port                = 8080
    protocol            = "HTTP"
    timeout             = 4 #need to get response before 4 sec.
  }
}

resource "aws_launch_template" "backend" {
  name                                 = local.resource_name
  image_id                             = aws_ami_from_instance.backend.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"
  vpc_security_group_ids               = [local.backend_sg_id]
  update_default_version               = true

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = local.resource_name
    }
  }
}


resource "aws_autoscaling_group" "backend" {
  name                      = local.resource_name
  max_size                  = 10
  min_size                  = 2
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 2
  # force_delete              = true
  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }

  vpc_zone_identifier = [local.private_subnet_id]

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
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

resource "aws_autoscaling_policy" "backend" {

  autoscaling_group_name = aws_autoscaling_group.backend.name
  name                   = local.resource_name
  policy_type            = "TargetTrackingScaling"
  # ... other configuration ...

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}


resource "aws_lb_listener_rule" "backend" {
  listener_arn = aws_lb_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = local.aws_lb_listener_arn
  }

  condition {
    host_header {
      values = ["${backend_tags.component}.app-${var.environment}.${var.zone_id}"]
    }
  }
}










