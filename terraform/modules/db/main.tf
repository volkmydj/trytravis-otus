resource "google_compute_instance" "db" {
  name         = "reddit-db"
  machine_type = "g1-small"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
    }
  }

  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
  network_interface {
    network = "default"
    access_config {}
  }
  tags = ["reddit-db"]
}

resource "google_compute_address" "app_ip" {
  name = "reddit-db-ip"
}

resource "google_compute_firewall" "firewall_mongo" {
  name        = "allow-mongo-default"
  description = "Alow port to host"
  network     = "default"
  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }
  target_tags = ["reddit-db"]
  source_tags = ["reddit-app"]
}
