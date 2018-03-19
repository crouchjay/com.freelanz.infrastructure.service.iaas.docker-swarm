module "users" {
	source 				= "git@github.com:crouchjay/com.freelanz.infrastructure.service.infra.git//com.freelanz.infrastructure.service.infra.cloudinit.user"
	name				= "ansible"
	sudo				= "ALL=(ALL) NOPASSWD:ALL"
	lock_passwd			= "true"
	groups				= "wheel"
	passwd				= "$1$UpHnuQw2$exHMtb2c5KNtBAWcaz1Ik1"
	ssh-authorized-keys	= "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0N2MplsDdKV/MwUBtzuIeM7FQtoX4hF8k454SjiD8EXSSpM4yCm7RtPqWsLMfOWGAfp/I+fpd2y0bVbWwhyis+sn4tj5KT2xNdF2T37pwpBifa01dVCJHroKG8o+PuJ73c2gVxiu3k47wqj2jkzovCE4y3xuFGiDjNFHWCnlHvsd7Pr+Bq6I3HTXl6w+jftXbXunzNpkmXFRE/4ShCAmHldDFgi2sZwrJyPsGLbvwDQlz4OmR1OnRLx7wXeHPubGcPR+WyfTFnQa3LCuXCW7NyQiTufnjJ7s5MQH6IaU89yO+POomrRcWM61slx1L/p6UDnXCdnwo0NkHmvtUg7qUxf3Dr1T4jw8DBUH+T3/dDLYFfuHuXM5Dcg1+zaZF20EKrxZWlKJAE/ahCgGokLpilYOpZy0oZNvdU5aNbO9aLso7hYSeUEBsBJRbip3uOwDIx8qTYMW5egGlmD5uYSocCAtoyL6A+IcambYVKGT+SPTJvWiaYJK+JSD2nISuUDe1kXrwaucQfDe9gAWZr9sR7/mmLNw63cwtCyVpxS46ygqX9FaZjOBajvXEZtw6lm5AEwPQlEq/40UdX+x+pF17ug0vtSkMMXVviT4s42gzGRckz4eILwa1P/qTX3myhSkH7WUmWsxdi/23fpANzaBAPx72BtCX0SS+2gmQDbNalQ== j.crouch@mbr-jeremiahcrouch.local"
}

module "yum-update" {
	source = "git@github.com:crouchjay/com.freelanz.infrastructure.service.infra.git//com.freelanz.infrastructure.service.infra.yum.update"
}

module "firewalld" {
	source = "git@github.com:crouchjay/com.freelanz.infrastructure.service.infra.git//com.freelanz.infrastructure.service.infra.firewalld"
}

module "pip" {
	source = "git@github.com:crouchjay/com.freelanz.infrastructure.service.infra.git//com.freelanz.infrastructure.service.infra.pip"
}

module "docker" {
	source = "git@github.com:crouchjay/com.freelanz.infrastructure.service.infra.git//com.freelanz.infrastructure.service.infra.docker"
}

#module "user_data" {
#	source = "git@github.com:crouchjay/com.freelanz.infrastructure.service.infra.git//com.freelanz.infrastructure.service.infra.cloudinit"
#	users	= "${join("\n",list(module.users.content))}"
#	runcmd	= "${join("\n",list(module.yum-update.content),module.pip.content,module.firewalld.content,module.docker.content)}"
#}

module "user_data" {
	source = "git@github.com:crouchjay/com.freelanz.infrastructure.service.infra.git//com.freelanz.infrastructure.service.infra.cloudinit"
	users	= "${join("\n",list(module.users.content))}"
	runcmd	= "${join("\n",list(module.yum-update.content),module.pip.content,module.docker.content)}"
}