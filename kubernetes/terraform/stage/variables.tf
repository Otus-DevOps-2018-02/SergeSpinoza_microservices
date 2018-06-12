variable "cluster_name" {
  default     = "cluster-test"
  description = "Cluster name"
}

variable "cluster_version" {
  default     = "1.8.10-gke.0"
  description = "Cluster version"
}

variable "node_count" {
  default     = 2
  description = "Numbers of nodes in cluster"
}

variable "node_disk_size" {
  default     = 20
  description = "Node disk size in GB"
}

variable "machine_type" {
  default     = "g1-small"
  description = "Machine type"
}

variable "project" {
  description = "Project ID"
}

variable "region" {
  default     = "europe-west1"
  description = "Region"
}

variable "zone" {
  default     = "europe-west1-b"
  description = "Zone"
}
