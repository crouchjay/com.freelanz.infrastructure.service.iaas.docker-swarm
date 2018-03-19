output "ip" {
	value = "${module.manager.ip}"
}

output "ansible_hosts" {
	value = "${module.manager.ansible_hosts}"
}