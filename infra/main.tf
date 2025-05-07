module "ecs-app-task" {

  ############## definições basicas do service
  environment                        = var.environment
  ecs_cluster_name                   = var.ecs_cluster_name
  feature_name                       = local.feature_name
  microservice_name                  = local.microservice_name
  service_desired_count              = var.service_desired_count
  service_deployment_maximum_percent = var.desired_number_of_tasks
  service_launch_config              = var.service_launch_config

  ############## configurações mínimas de rede
  task_container_port    = var.task_container_port
  tg_groups_config       = local.tg_groups_config
  lb_listeners_config    = local.lb_listeners_config
  service_vpc_id         = var.vpc_id
  security_group_default = var.security_group_ecs
  service_subnets        = var.service_subnets

  ############## definições basicas do container
  task_cpu                           = var.task_cpu
  task_memory                        = var.task_memory
  task_ulimits_vars                  = var.task_ulimits_vars
  task_environment_vars              = local.task_environment_vars #opcional

  ############## tags obrigatorias
  sigla               = local.sigla
  produto             = local.feature_name
  context             = local.context
  owner_contact_email = local.owner_contact_email
  tech_team_email     = local.tech_team_email
  finalidade          = local.finalidade
  squad               = local.squad
  github_repo_id      = var.github_repo_id
  github_repo_name    = var.github_repo_name
  build_version       = var.iupipes_build_version
  additional_tags     = local.additional_tags
  use_legacy_tags     = var.use_legacy_tags

  ############## roles
  task_role_arn           = local.arn_role
  task_execution_role_arn = local.arn_role

  ############## Datadog
  task_log_driver                            = local.task_log_driver
  task_datadog                               = local.task_datadog

  ############## Para configurações complementares, consulte: https://github.com/itau-corp/itau-hn8-modules-ecs-service/develop/modules/app#inputs

}


resource "aws_lb_target_group" "ecs_tg" {
  name        = "${var.environment}-${local.microservice_name}-tg"
  port        = var.task_container_port
  protocol    = "TCP" # NLB geralmente usa TCP
  target_type = "ip"
  vpc_id      = var.vpc_id
}