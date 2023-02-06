locals {
  istio_operator_yaml           = "${path.module}/kubernetes/istio/istio-operator.yaml"
}


resource "local_file" "istio_operator" {
  content = templatefile("${path.module}/istio/istio-operator.tpl",  {
    asg_enabled         = "true"
    asg_min             = 1
    asg_max             = 10
    acm_arm             = var.acm_arm_id
    load_balancer_name  = "${local.name_prefix}-istio-nlb"
    resource_tags       = format("Name=%s,Project=%s,Environment=%s,Team=%s,Owner=%s", "${local.name_prefix}-istio-nlb",
    var.context.project, var.context.environment, var.context.team, var.context.owner)
  })
  filename = local.istio_operator_yaml
}


resource "null_resource" "cert_manager" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/kubernetes/gitlab/gitlab-pv.yaml --context ${local.eks_toolchain_context}"
    environment = {
      AWS_PROFILE = var.context.aws_profile
      KUBECONFIG = pathexpand("~/.kube/config")
    }
  }
  depends_on = [local_file.istio_operator]  # local_file.istio_operator 선행으로 실행하고 실행!!하게 설정!!
}

