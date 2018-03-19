#module "manager_user_data" {
#	source	= "modules/base_server_setup"
#	runcmds	= "${list(local.swarm_pm_action_script)}"
#}

#module "worker_user_data" {
#	source	= "modules/base_server_setup"
#	runcmds	= "${list(local.swarm_pm_action_script)}"
#}

data "external" "swarm_join_token" {
	program = ["${path.module}/scripts/get-join-tokens.sh"]
	query = {
		host = "${module.primary_manager.ip[0]}"
	}
	
	depends_on = ["module.primary_manager"]
}

module "primary_manager" {
	source				= "modules/primary_server"
	plan				= "${var.plan}"
	facility			= "${var.facility}"
  	project_id			= "${var.project_id}"
  	hostname			= "${var.hostname}"
  	api_key				= "${var.packet_api_key}"
  	swarm_ip			= ""
  	swarm_manager_token = ""
}

module "managers" {
	source				= "modules/manager_server"
	count				= "${var.manager_count}"
	plan				= "${var.plan}"
	facility    		= "${var.facility}"
  	project_id  		= "${var.project_id}"
  	hostname    		= "manager" #${var.hostname}"
  	api_key				= "${var.packet_api_key}"
  	swarm_ip			= "${module.primary_manager.ip[0]}"
  	swarm_manager_token	= "${data.external.swarm_join_token.result.manager}"
}

#module "workers" {
#	source				= "modules/server"
#	count				= "${var.worker_count}"
#	plan				= "${var.plan}"
#	facility          	= "${var.facility}"
#  	project_id        	= "${var.project_id}"
#  	hostname          	= "${var.hostname}"
#  	user_data			= "${module.worker_user_data.content}"
#  	api_key				= "${var.packet_api_key}"
#}

module "hosts" {
	source			= "git@github.com:crouchjay/com.freelanz.infrastructure.service.infra.git//com.freelanz.infrastructure.service.infra.terraform.ansible_inventory"
	primary_manager	= "${join("\n",module.primary_manager.ansible_hosts)}"
	managers		= "${join("\n",module.managers.ansible_hosts)}"
	servers			= "${join("\n",module.primary_manager.ansible_hosts)}"
	workers			= ""
	docker_servers	= "${join("\n",module.primary_manager.ansible_hosts,module.managers.ansible_hosts)}"
}

#module "hosts" {
#	source			= "git@github.com:crouchjay/com.freelanz.infrastructure.service.infra.git//com.freelanz.infrastructure.service.infra.terraform.ansible_inventory"
#	primary_manager	= "${join("\n",module.primary_manager.ansible_hosts)}"
#	managers		= "${join("\n",module.managers.ansible_hosts)}"
#	servers			= "${join("\n",module.primary_manager.ansible_hosts,module.managers.ansible_hosts,module.workers.ansible_hosts)}"
#	workers			= "${join("\n",module.workers.ansible_hosts)}"
#}

module "ansible-firewalld" {
	source			= "git@github.com:crouchjay/com.freelanz.infrastructure.service.infra.git//com.freelanz.infrastructure.service.infra.ansible.firewalld"
	hosts_content	= "${module.hosts.hosts_content}"
}

module "ansible-docker-swarm" {
	source			= "git@github.com:crouchjay/com.freelanz.infrastructure.service.infra.git//com.freelanz.infrastructure.service.infra.ansible.docker-swarm"
	hosts_content	= "${module.hosts.hosts_content}"
}