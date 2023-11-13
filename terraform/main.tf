###
# Get Global Account details
###
data "btp_globalaccount" "project" {}
###
# Get Subaccount details
###
data "btp_subaccount" "project" {
  id = btp_subaccount.project.id
}
# create a subaccount
resource "btp_subaccount" "project" {
  name      = lower(var.tenant)
  subdomain = lower(var.tenant)
  region    = lower(var.region)
}
# create a Kyma runtime
data "btp_regions" "all" {}

data "btp_whoami" "me" {}

resource "btp_subaccount_entitlement" "kymaruntime" {
  subaccount_id = btp_subaccount.project.id

  service_name = "kymaruntime"
  plan_name    = "trial"
  amount       = 1
}

resource "btp_subaccount_environment_instance" "kymaruntime" {
  subaccount_id = btp_subaccount.project.id

  name             = var.tenant
  environment_type = "kyma"
  service_name     = btp_subaccount_entitlement.kymaruntime.service_name
  plan_name        = btp_subaccount_entitlement.kymaruntime.plan_name

  parameters = jsonencode({
    name           = var.tenant
    administrators = [data.btp_whoami.me.email]
    })

  timeouts = { 
    create = "1h"
    update = "35m"
    delete = "1h"
  }

  depends_on = [btp_subaccount_entitlement.kymaruntime]
}

data "http" "kubeconfig" {
  url = jsondecode(btp_subaccount_environment_instance.kymaruntime.labels)["KubeconfigURL"]
}

resource "local_sensitive_file" "kubeconfig" {
  filename = ".${btp_subaccount.project.id}-${var.tenant}.kubeconfig"
  content  = data.http.kubeconfig.response_body
}