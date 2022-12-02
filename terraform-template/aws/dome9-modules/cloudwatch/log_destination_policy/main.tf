resource "aws_cloudwatch_log_destination_policy" "policy" {
  count            = "${length(var.destination_names)}"
  destination_name = "${var.destination_names[count.index]}"
  access_policy    = "${var.access_policy}"
}
