locals {
  working_dir = "${var.tmp_path}/${var.working_folder}"
}

resource "null_resource" "cluster" {

  triggers = {
    value = md5(var.script)
  }

  count = var.target_count
  connection {
    host                = var.ips[count.index]
    user                = var.ssh_user
    private_key         = file(var.ssh_private_key)
    script_path         = "${var.tmp_path}/${var.ips[count.index]}-${var.working_folder}_script.sh"
    type                = "ssh"

    bastion_host        = var.bastion_ip
    bastion_user        = var.bastion_ssh_user
    bastion_private_key = var.bastion_ssh_private_key != null ? file(var.bastion_ssh_private_key) : null
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${local.working_dir}",
     ]
  }

  provisioner "file" {
    content     = var.script
    destination = "${local.working_dir}/cluster.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "echo ${var.ssh_user_sudo_password} | ${var.sudo_cmd} -S bash -ex ${local.working_dir}/cluster.sh",
     ]
  }
  depends_on = [null_resource.module_depends_on]
}

resource "null_resource" "module_depends_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}
