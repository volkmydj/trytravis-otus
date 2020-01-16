resource "google_compute_instance" "db" {
  name         = "reddit-db"
  machine_type = "g1-small"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = var.db_disk_image
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

resource "null_resource" "db" {
  count = var.provision_enabled ? 1 : 0
  connection {
    type        = "ssh"
    host        = google_compute_instance.db.network_interface.0.access_config.0.nat_ip
    user        = "appuser"
    agent       = false
    private_key = file(var.private_key)

  }
  provisioner "remote-exec" {
    inline = [
      "sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/g' /etc/mongod.conf",
      "sudo systemctl restart mongod",
    ]
  }
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
