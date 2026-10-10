output "cluster_id" {
  value = yandex_kubernetes_cluster.cluster.id
}

output "cluster_public_ip" {
  # В версии 0.238 public_ip это просто строка
  value = yandex_kubernetes_cluster.cluster.master[0].public_ip
}

output "subnet_ids" {
  value = [
    yandex_vpc_subnet.subnet-a.id, 
    yandex_vpc_subnet.subnet-b.id,
    yandex_vpc_subnet.subnet-e.id
  ]
}
variable "node_sa_id" {
  description = "ID of the Service Account for nodes"
  type        = string
}
output "registry_id" {
  value = yandex_container_registry.my_registry.id
}

output "registry_url" {
  value = "cr.yandex/${yandex_container_registry.my_registry.id}"
}

