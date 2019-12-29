terraform {
  #Terraform version
  required_version = "0.12.18"
}

provider "google" {
  #Provider version
  version = "2.15"

  #ID project
  project = var.project

  region = var.region
}

resource "google_compute_instance" "app" {
  count        = var.instances_count
  name         = "${var.app_name}${count.index}"
  machine_type = "g1-small"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}\nappuser2:${file(var.public_key_path)}\nappuser3:${file(var.public_key_path)}"
  }

  network_interface {
    network = "default"
    access_config {}
  }
  tags = [var.app_name]

  connection {
    type        = "ssh"
    host        = self.network_interface[0].access_config[0].nat_ip
    user        = "appuser"
    agent       = false
    private_key = file(var.private_key)
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-app"]
}

resource "google_compute_project_metadata_item" "app" {
  key   = "ssh-keys"
  value = "appuser_web:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZjzH2R0KEq2n/gofT572N82EUKH3dZka5Wn+XAVsxYJt/if2MqWJ5ORiWM5e4zXqYN5N1SnSRiHCpet6HvOYR8VYJLqIycHz8LPvQWFis3JujhQ5FOGqtFGZqDnWfXLs8uzvEyJpunOhaRo8a7MDxEX+EWeYUgFiOl7FqGtoTjlfYXFvNUrInkrNUrwRr2tfvgMLKSXYJBYlh5/6Nth3Q2Mw7zQ7rGR37el6p1LqCw/3sWlE6bRWgHykyz6R3ugu9R5jk1IV6DeJXwJmP1yydnLvRRR7xietIIgCoXmIMQIMDbNtG6PH2HHHgjMiRHa1F8zzZgmMYhnpTkTUxldSH appuser_web"
}
