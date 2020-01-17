resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = var.app_disk_image
    }
  }

  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.app_ip.address
    }
  }
  tags = ["reddit-app"]
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}

resource "null_resource" "app" {
  count = var.provision_enabled ? 1 : 0
  connection {
    type        = "ssh"
    host        = google_compute_instance.app.network_interface.0.access_config.0.nat_ip
    user        = "appuser"
    agent       = false
    private_key = file(var.private_key)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo echo DATABASE_URL=${var.db_reddit_ip} > /tmp/puma.env",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "file" {
    source      = "${path.module}/files/deploy.sh"
    destination = "/tmp/deploy.sh"
  }


  provisioner "remote-exec" {
    script = "${path.module}/files/deploy.sh"
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name        = "allow-puma-default"
  description = "Alow port for puma-host"
  network     = "default"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-app"]
}
