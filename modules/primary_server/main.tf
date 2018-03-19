locals {
	swarm_ip 					= "${var.swarm_ip == "" ? module.primary_manager.ip[0] : var.swarm_ip}"
	init_action					= "init"
	join_action					= "join"
	swarm_pm_action 			= "${var.swarm_ip == "" ? local.init_action : local.join_action}"
	swarm_pm_init_action_script = "sudo docker swarm init --advertise-addr ${local.swarm_ip}"
	swarm_pm_join_action_script = "sudo docker swarm join --token ${var.swarm_manager_token} ${local.swarm_ip}:2377"
	swarm_pm_action_script 		= "${local.swarm_pm_action == local.init_action ? local.swarm_pm_init_action_script : local.swarm_pm_join_action_script}"
}

resource "local_file" "ansible_hosts" {
	content		= "${local.swarm_pm_action_script}"
	filename	= "${path.module}/swarm_pm_action_script.yaml"
}

#data "external" "swarm_join_token" {
#	program = ["${path.module}/scripts/get-join-tokens.sh"]
#	query = {
#		host = "${local.swarm_ip}"
#	}
#}

module "user_data" {
	source	= "../base_server_setup"
}

module "primary_manager" {
	source		= "../server"
	count		= 1
	plan		= "${var.plan}"
	facility    = "${var.facility}"
	project_id  = "${var.project_id}"
	hostname    = "${var.hostname}"
	user_data	= "${module.user_data.content}"
	api_key		= "${var.api_key}"
}

resource "null_resource" "swarm_action" {

	connection {
    	type	= "ssh"
    	user    = "ansible"
    	host	= "${module.primary_manager.ip[0]}"
  	}

	provisioner "remote-exec" "create_folder" {
		inline = [
			"${local.swarm_pm_action_script}"
		]
	}
}

module "hosts" {
	source			= "git@github.com:crouchjay/com.freelanz.infrastructure.service.infra.git//com.freelanz.infrastructure.service.infra.terraform.ansible_inventory"
	primary_manager	= "${join("\n",module.primary_manager.ansible_hosts)}"
	managers		= "${join("\n",module.primary_manager.ansible_hosts)}"
	servers			= "${join("\n",module.primary_manager.ansible_hosts)}"
	workers			= ""
	docker_servers	= "${join("\n",module.primary_manager.ansible_hosts)}"
}

#module "ansible-firewalld" {
#	source			= "git@github.com:crouchjay/com.freelanz.infrastructure.service.infra.git//com.freelanz.infrastructure.service.infra.ansible.firewalld"
#	hosts_content	= "${module.hosts.hosts_content}"
#}