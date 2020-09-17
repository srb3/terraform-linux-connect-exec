# Overview
This module will connect to any number of remote linux hosts, and execute a script on them.
The script that is run is passed through in the `var.script` variable. Connections are established with an ssh user and private key, no password option is available. If you need to ssh via a jump host (or bastion host) this is possible by setting the `bastion_ip` `bastion_ssh_user` and `bastion_ssh_private_key` variables. If you do not need to connect via a jump host then just leave out these variables.

#### Supported platform families:
 * Debian
 * RHEL

## Usage

#### basic:
```hcl
locals {
  install_script = templatefile("${path.module}/templates/install.sh", {})
}

module "connect_and_execute" {
  source          = "srb3/connect-exec/linux"
  version         = "0.0.1"
  ips             = ["172.16.0.2"]
  count           = 1
  user_name       = "centos"
  ssh_private_key = "~/.ssh/id_rsa"
  script          = var.install_script
}
```

#### via jump host (bastion host):
```hcl

module "connect_and_execute_via_bastion" {
  source               = "srb3/connect-exec/linux"
  version              = "0.0.1"
  ips                  = ["172.16.0.2"]
  count                = 1
  ssh_user             = "centos"
  ssh_private_key      = "~/.ssh/id_rsa"
  script               = var.install_script
  bastion_ip           = "203.0.113.2"
  bastion_ssh_user     = "jumphost"
  bastion_ssh_private_key = "~/.ssh/jumphost.pem"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
|ips|A list of ip addresses where the effortless package and habitat will be installed|list|[]|no|
|count|The number of instances to connect to|number|0|no|
|ssh_user|The ssh user name used to access the ip addresses provided|string|""|no|
|ssh_private_key|The ssh private key used to access the ip addresses provided|string|""|no|
|tmp_path|The location of a temp directory, the working_folder will be created here|string|/var/tmp|no|
|bastion_ip|The ip address of a bastion host to connect through|string|""|no|
|bastion_ssh_user|The username needed to make an ssh connection to the bastion host|string|""|no|
|bastion_ssh_private_key|A path to a private key for ssh connections to the bastion host|string|""|no|
|ssh_user_sudo_password|If a password is needed for sudo then set it in this variable|string|""|no|
|sudo_cmd|The command to use for sudo|string|sudo|no|
|script|The content of this variable will be executed on the target hosts|string|""|no|
|working_folder|The working folder will hold the script to be executed, and the log file|string|""|no|
|module_depends_on|If this module depends on any others to run before it, then use this variable to hold them|list(any)|[]|no|

## Outputs
no outputs produced by this module
