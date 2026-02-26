provider "openstack" {
  user_name   = var.user_name
  tenant_name = var.tenant_name
  password    = var.password
  auth_url    = var.auth_url
  region      = var.region
  insecure    = true
}

data "openstack_images_image_v2" "image" {
  name = var.image_name
}

data "openstack_networking_network_v2" "networks" {
  for_each = toset(var.network_names)
  name     = each.key
}

resource "openstack_blockstorage_volume_v3" "boot_volume" {
  name              = "${var.server_name}-boot"
  size              = var.boot_disk_size
  volume_type       = var.boot_disk_type
  image_id          = data.openstack_images_image_v2.image.id
  availability_zone = var.availability_zone
}

resource "openstack_blockstorage_volume_v3" "extra_volumes" {
  for_each = { for vol in var.additional_volumes : vol.name => vol }

  name              = "${var.server_name}-${each.value.name}"
  size              = each.value.size
  volume_type       = var.boot_disk_type
  availability_zone = var.availability_zone
}

resource "openstack_compute_instance_v2" "vm" {
  name              = var.server_name
  flavor_name       = var.flavor_name
  availability_zone = var.availability_zone

  user_data = file(var.user_data_file)

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.boot_volume.id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
  }

  dynamic "block_device" {
    for_each = openstack_blockstorage_volume_v3.extra_volumes
    content {
      uuid                  = block_device.value.id
      source_type           = "volume"
      destination_type      = "volume"
      boot_index            = -1
      delete_on_termination = false
    }
  }

  dynamic "network" {
    for_each = data.openstack_networking_network_v2.networks
    content {
      uuid = network.value.id
    }
  }
}

resource "null_resource" "wait_for_winrm" {
  depends_on = [openstack_compute_instance_v2.vm]

  provisioner "remote-exec" {
    inline = ["echo WinRM is ready"]

    connection {
      type            = "winrm"
      host            = openstack_compute_instance_v2.vm.access_ip_v4
      user            = var.os_user
      password        = var.os_password
      port            = 5986
      timeout         = "5m"
      https           = true
      insecure        = true
    }
  }
}

resource "null_resource" "ansible_windows" {
  depends_on = [null_resource.wait_for_winrm]

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${openstack_compute_instance_v2.vm.access_ip_v4},' --extra-vars 'ansible_user=${var.os_user} ansible_password=${var.os_password}' ${var.ansible_playbook}"
  }
}
