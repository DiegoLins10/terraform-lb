locals {
  tg_groups_config = [
    {
      container_port = var.task_container_port
      container_name = local.microservice_name
      target_group_arn = data.aws_lb_target_group.nlb_tg.arn
    }
  ]

  lb_listeners_config = [
    {
      listener_arn = data.aws_lb_listener.nlb_listener.arn
      priority     = 1
      conditions = [
        {
          field = "path-pattern"
          values = ["/${local.microservice_name}/*"]
        }
      ]
    }
  ]
}
