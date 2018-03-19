provider "packet" {
	version		= "1.2"
  	auth_token	= "${var.api_key}"
}

resource "packet_project" "project" {
  	name = "${var.project}"
}

module "docker-swarm" {
	source 				= "../"
	plan				= "${var.plan}"
	facility			= "${var.facility}"
  	project_id			= "${packet_project.project.id}"
  	hostname			= "fl.node.test.ds"
  	manager_count		= "1"
  	worker_count		= "0"
  	swarm_ip			= "${var.swarm_ip}"
  	packet_api_key		= "${var.api_key}"
  	swarm_manager_token = "${var.swarm_manager_token}"
}
