output "ip" {
	value = "${module.server.ip}"
}

output "ansible_hosts" {
	value = "${module.server.ansible_hosts}"
}