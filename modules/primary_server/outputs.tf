output "ip" {
	value = "${module.primary_manager.ip}"
}

output "ansible_hosts" {
	value = "${module.primary_manager.ansible_hosts}"
}