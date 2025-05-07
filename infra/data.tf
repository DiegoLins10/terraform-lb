data "aws_lb" "nlb" {
  name = "nlb-centralizado-back-mp-query"
}

data "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = data.aws_lb.nlb.arn
  port              = 80 # ou a porta do seu listener (ex: 443 para HTTPS)
}


## recuperar target group
data "aws_lb_target_group" "nlb_tg" {
  name = "nome-do-seu-target-group"
}



