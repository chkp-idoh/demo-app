resource "aws_ssm_parameter" "this" {
  count = "${length(keys(var.params))}"

  name        = "${local.params_store[var.param_store]}${element(keys(var.params), count.index)}"
  value       = "${element(values(var.params), count.index)}"
  description = "${var.description}"
  type        = "${local.type[var.type]}"
  key_id      = "${local.type[var.type] == "SecureString" ? data.aws_kms_key.this.id : ""}"
  overwrite   = "${var.clobber}"

  tags = "${local.common_tags}"
}

data "aws_kms_key" "this" {
  key_id = "${(var.config["_env"] == "preqa") ? format("%s-%s", var.key_prefix, local.suffix) : local.ssm_kms_key[var.config["_env"]]}"
}

locals {
  suffix     = "${var.config["_env"] == "preqa" ? var.config["_project"] : var.config["_env"]}"
  ssm_prefix = "${var.config["_env"] == "preqa" ? "/${var.config["_project"]}" : ""}"

  params_store = {
    common          = "${local.ssm_prefix}/common/"
    db              = "${local.ssm_prefix}/common/db/"
    microservice    = "${local.ssm_prefix}/component/microservice/"
    central         = "${local.ssm_prefix}/component/central/"
    central_api     = "${local.ssm_prefix}/component/central_api/"
    schedulers      = "${local.ssm_prefix}/component/schedulers/"
    watchdog        = "${local.ssm_prefix}/watchdog/"
    webapp       = "${local.ssm_prefix}/common/webapp/"

    inspect         = "${local.ssm_prefix}/inspect/common/"
    inspect_db      = "${local.ssm_prefix}/inspect/common/db/"
    inspect_central = "${local.ssm_prefix}/inspect/component/central/"
  }

  type = {
    encrypt    = "SecureString"
    plain      = "String"
    plain_list = "StringList"
  }

  ssm_kms_key = {
    qa    = "alias/dome9/ssm-qa"
    stg   = "alias/dome9/ssm-stg"
    prod  = "alias/dome9/ssm-prod"
    preqa = "Should not get here"
}
  # Maps of dynamic parameter values in (key = [value;description;type(from var.type)]) format
  # Common tags
  common_tags = {
    Env      = "${var.config["_env"]}"
    Owner    = "${var.config["_env"] == "preqa" ? var.config["_owner"] : "cfir"}"
    Platform = "dome9"
    Project  = "${var.config["_env"] == "preqa" ? var.config["_project"] : "infra"}"
  }
}