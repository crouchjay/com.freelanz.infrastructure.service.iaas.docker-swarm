module "user_data" {
	source	= "../base_server_setup"
}

module "manager" {
	source			= "../server"
	count			= "${var.count}"
	plan			= "${var.plan}"
	facility    	= "${var.facility}"
	project_id 		= "${var.project_id}"
	hostname    	= "${var.hostname}"
	user_data		= "${module.user_data.content}"
	api_key			= "${var.api_key}"
}

resource "null_resource" "swarm_action" {

	connection {
    	type	= "ssh"
    	user    = "ansible"
    	host	= "${module.manager.ip[0]}"
  	}

	provisioner "remote-exec" "create_folder" {
		inline = [
			"sudo docker swarm join --token ${var.swarm_manager_token} ${var.swarm_ip}:2377"
		]
	}
}

resource "local_file" "ansible_hosts" {
	content		= "${module.user_data.content}"
	filename	= "${path.module}/user-data.yaml"
}