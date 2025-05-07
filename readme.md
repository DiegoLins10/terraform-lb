Claro! Para conectar o **NLB (Network Load Balancer)** ao seu módulo `ecs-app-task` no Terraform, você precisa garantir que o **listener do NLB** e o **target group** estejam configurados corretamente e que o módulo ECS esteja utilizando esses componentes.

Aqui está um passo a passo com base no seu código:

---

### ✅ 1. **Recuperar o NLB**

Você já tem:

```hcl
data "aws_lb" "nlb" {
  name = "nlb-centralizado-back-mp-query"
}
```

Isso busca o NLB existente. Agora você precisa recuperar os **listeners** e o **target group** associados.

---

### ✅ 2. **Recuperar o Listener do NLB**

Você pode usar o `aws_lb_listener`:

```hcl
data "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = data.aws_lb.nlb.arn
  port              = 80 # ou a porta do seu listener (ex: 443 para HTTPS)
}
```

---

### ✅ 3. **Recuperar ou criar Target Group**

Se você **já tem um target group**, recupere-o:

```hcl
data "aws_lb_target_group" "nlb_tg" {
  name = "nome-do-seu-target-group"
}
```

Caso precise **criar um novo target group**:

```hcl
resource "aws_lb_target_group" "ecs_tg" {
  name        = "${var.environment}-${local.microservice_name}-tg"
  port        = var.task_container_port
  protocol    = "TCP" # NLB geralmente usa TCP
  target_type = "ip"
  vpc_id      = var.vpc_id
}
```

---

### ✅ 4. **Configurar no módulo `ecs-app-task`**

Você precisa preencher os parâmetros `lb_listeners_config` e `tg_groups_config`. Esses geralmente são esperados como **maps ou lists de objetos**, dependendo da definição do módulo.

**Exemplo básico:**

```hcl
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
```

> Obs: Se for um NLB puro sem suporte a path-based routing, talvez nem use `conditions`, ou use `host-header` se for necessário.

---

### ✅ 5. **Passar para o módulo**

Se já definiu `local.tg_groups_config` e `local.lb_listeners_config` como acima, você já está passando corretamente ao módulo:

```hcl
tg_groups_config    = local.tg_groups_config
lb_listeners_config = local.lb_listeners_config
```

---

Se quiser, posso revisar os valores reais (como portas e nomes dos TGs) se você me passar mais detalhes do NLB e dos serviços que deseja expor.

Você sabe qual porta o serviço ECS usa e se o NLB escuta em HTTP, HTTPS ou TCP?
