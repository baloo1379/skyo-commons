terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "1.47.0"
    }
  }
}

variable "token" {
  type = string
}

provider "openstack" {
  auth_url  = "https://identity.cloud.muni.cz"
  tenant_id = "a478488b79df46c4a086ecb7a321b038"
  token     = var.token
}

resource "openstack_compute_instance_v2" "example" {
  name        = "OlszanowskiBartlomiej.Twitch"
  image_name  = "debian-11-x86_64"
  flavor_name = "standard.tiny"
  network {
    name = "group-project-network"
  }
  key_pair = "OlszanowskiBartlomiej"
}

resource "openstack_compute_floatingip_v2" "example_ip" {
  pool = "public-muni-147-251-21-GROUP"
}

resource "openstack_compute_floatingip_associate_v2" "example_ip_associate" {
  floating_ip = openstack_compute_floatingip_v2.example_ip.address
  instance_id = openstack_compute_instance_v2.example.id
}

output "instance_address" {
  value = openstack_compute_floatingip_v2.example_ip.address
}