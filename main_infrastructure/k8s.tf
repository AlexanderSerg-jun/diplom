resource "yandex_kubernetes_cluster" "cluster" {
  name        = var.cluster_name
  description = "Managed K8s (Adaptive to Zone Limits)"

  network_id = yandex_vpc_network.default.id
  node_service_account_id = var.node_sa_id
  service_account_id      = var.node_sa_id

  master {
    version = "1.33" 
    public_ip = true
    

    master_location {
      zone      = "ru-central1-e"
      subnet_id = yandex_vpc_subnet.subnet-e.id
    }
  }
}

resource "yandex_kubernetes_node_group" "workers" {
  cluster_id = yandex_kubernetes_cluster.cluster.id
  name        = "workers"

  instance_template {
    platform_id = "standard-v2"
    network_interface {
      nat        = true
      # Все 3 подсети
      subnet_ids = [
        yandex_vpc_subnet.subnet-b.id,
        yandex_vpc_subnet.subnet-d.id
      ]
    }
    resources {
      memory = 4
      cores  = 2
      core_fraction = 100
    }
    boot_disk {
      type = "network-hdd"
      size = 50
    }

  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }
  # Убрали allocation_policy
  #allocation_policy {
  #location {
  #  zone      = "ru-central1-e"
  #  subnet_id = yandex_vpc_subnet.subnet-d.id
  #}
  #location {
  #  zone      = "ru-central1-e"
  #  subnet_id = yandex_vpc_subnet.subnet-e.id
  #}
#}
}