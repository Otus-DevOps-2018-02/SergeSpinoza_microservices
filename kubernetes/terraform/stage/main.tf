provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "google_container_cluster" {
  source             = "../modules/google_container_cluster"
  project            = "${var.project}"
  zone               = "${var.zone}"
  cluster_name       = "${var.cluster_name}"
  cluster_version    = "${var.cluster_version}"
  node_count         = "${var.node_count}"
  node_disk_size     = "${var.node_disk_size}"
  machine_type       = "${var.machine_type}"
}
