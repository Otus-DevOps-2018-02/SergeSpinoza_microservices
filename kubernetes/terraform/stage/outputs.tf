output "client_certificate" {
  value = "${module.google_container_cluster.client_certificate}"
}

output "client_key" {
  value = "${module.google_container_cluster.client_key}"
}

output "cluster_ca_certificate" {
  value = "${module.google_container_cluster.cluster_ca_certificate}"
}

output "endpoint_ip" {
  value = "${module.google_container_cluster.endpoint_ip}"
}
