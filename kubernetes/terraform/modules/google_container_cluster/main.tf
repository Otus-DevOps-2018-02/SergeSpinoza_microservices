resource "google_container_cluster" "primary" {
  name               = "${var.cluster_name}"
  zone               = "${var.zone}"
  initial_node_count = "${var.node_count}"
  enable_legacy_abac = false
  min_master_version = "${var.cluster_version}"
  node_version       = "${var.cluster_version}"
  subnetwork         = "default"

  node_config {
    disk_size_gb = "${var.node_disk_size}"
    machine_type = "${var.machine_type}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  addons_config {
    kubernetes_dashboard {
      disabled = false
    }
  }
}

resource "google_compute_firewall" "firewall_kubernetes" {
  name    = "k8s-default-input"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }

  description   = "Allow input to k8s"
  source_ranges = ["0.0.0.0/0"]
}
