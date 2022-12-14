variable "needs_protection" {
  default = false
}
variable "protected" {}
resource "random_id" "protector" {
  count = "${ var.needs_protection ? 1 : 0 }"
  byte_length = 8
  keepers = {
    protector = "${ var.protected }"
  }
  lifecycle {
    prevent_destroy = true
  }
}
