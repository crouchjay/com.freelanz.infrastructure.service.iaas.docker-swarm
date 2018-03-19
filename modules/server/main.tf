module "server" {
	source		= "git@github.com:crouchjay/com.freelanz.infrastructure.service.infra.git//com.freelanz.infrastructure.service.infra.packet.server"
	count		= "${var.count}"
	plan		= "${var.plan}"
	facility	= "${var.facility}"
  	project_id	= "${var.project_id}"
  	hostname	= "${var.hostname}"
  	user_data	= "${var.user_data}"
  	api_key		= "${var.api_key}"
}

resource "null_resource" "cloud-init-action" {
	
	triggers {
		ip = "${module.server.ip[0]}"
	}
	
	provisioner "local-exec" "sleep" {
		command = "${path.module}/scripts/sleep.sh"
	}
}