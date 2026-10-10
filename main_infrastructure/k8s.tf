# ---------- Сеть ----------


# ---------- Сервисные аккаунты ----------
# SA для управления ресурсами кластера (Compute/VPC)
resource "yandex_iam_service_account" "k8s_sa" {
  name = "k8s-cluster-sa"
}

# SA для узлов (pull образов, логи)
resource "yandex_iam_service_account" "k8s_node_sa" {
  name = "k8s-node-sa"
}

# Роли: SA кластера — editor на каталог (и на каталог сети)
resource "yandex_resourcemanager_folder_iam_member" "k8s_sa_editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_sa.id}"
}

# SA узлов — pull образов из Container Registry
resource "yandex_resourcemanager_folder_iam_member" "k8s_node_sa_puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_node_sa.id}"
}

# ---------- Кластер ----------
resource "yandex_kubernetes_cluster" "cluster" {
  name        = "my-cluster"
  description = "Diploma Cluster"
  network_id  = yandex_vpc_network.default.id

  master {
    version   = "1.33"
    public_ip = true

    # Мастер в зоне B
    master_location {
      zone      = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.subnet-b.id
    }

    # Ограничьте доступ к публичному API-эндпоинту
    # security_group_ids = [yandex_vpc_security_group.k8s_master.id]
  }

  service_account_id      = yandex_iam_service_account.k8s_sa.id
  node_service_account_id = yandex_iam_service_account.k8s_node_sa.id
}

# ---------- Группа узлов ----------
resource "yandex_kubernetes_node_group" "workers" {
  cluster_id = yandex_kubernetes_cluster.cluster.id
  name       = "workers"

  instance_template {
    platform_id = "standard-v3"

    network_interface {
      nat        = true
      subnet_ids = [yandex_vpc_subnet.subnet-b.id]
    }

    resources {
      memory = 4
      cores  = 2
    }

    boot_disk {
      type = "network-ssd"
      size = 50
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  # Явно задаём зону размещения узлов — совпадает с зоной подсети
  allocation_policy {
    location {
      zone      = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.subnet-b.id
    }
  }
}