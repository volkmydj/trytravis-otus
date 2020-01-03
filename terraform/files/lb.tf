resource "google_compute_instance_group" "all" {
  name      = "${var.app_name}-instance-group"
  project   = var.project
  zone      = var.zone
  instances = google_compute_instance.app[*].self_link
  named_port {
    name = var.service_port_name
    port = var.service_port
  }
}




module "gce-lb-http" {
  project     = var.project
  source      = "GoogleCloudPlatform/lb-http/google"
  name        = "${var.app_name}-lb"
  target_tags = [var.app_name]
  backends = {
    default = {
      description                     = "Reddit-App backends"
      protocol                        = "HTTP"
      port                            = var.service_port
      port_name                       = var.service_port_name
      timeout_sec                     = 15
      connection_draining_timeout_sec = null
      enable_cdn                      = false

      health_check = {
        check_interval_sec  = 5
        timeout_sec         = 5
        healthy_threshold   = 1
        unhealthy_threshold = 3
        request_path        = "/"
        port                = var.service_port
        host                = null
      }

      groups = [
        {
          # Each node pool instance group should be added to the backend.
          group                        = "${google_compute_instance_group.all.self_link}"
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        },
      ]
    }
  }
}
