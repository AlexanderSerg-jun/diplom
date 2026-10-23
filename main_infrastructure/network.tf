# network.tf

resource "yandex_vpc_network" "default" {
  name = "k8s-network-new"
}

resource "yandex_vpc_subnet" "subnet-b" {
  name           = "subnet-a"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

resource "yandex_vpc_subnet" "subnet-d" {
  name           = "subnet-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}


resource "yandex_vpc_subnet" "subnet-e" {
  name           = "subnet-e"
  zone           = "ru-central1-e"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.0.3.0/24"]
}