variable "sg_name_list" {
	type="list"
}

data "aws_security_group" "allow_mongo_sg" {
  count ="${length(var.sg_name_list)}"

  name = "${element(var.sg_name_list, count.index )}"
}

output "arn_list" {
  value = ["${data.aws_security_group.allow_mongo_sg.*.id}"]
}

