resource "yandex_vpc_network" "default" {
  name = "my-network"
  # В managed K8s провайдер v0.238 часто не требует mode, или он берется из контекста.
  # Если это standard network, просто убери строку mode.
}

resource "yandex_vpc_subnet" "subnet-a" {
  name           = "subnet-a"
  v4_cidr_blocks = ["10.0.1.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id
}

resource "yandex_vpc_subnet" "subnet-b" {
  name           = "subnet-b"
  v4_cidr_blocks = ["10.0.2.0/24"]
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.default.id
}

resource "yandex_vpc_subnet" "subnet-e" {
  name           = "subnet-e"
  v4_cidr_blocks = ["10.0.3.0/24"]
  zone           = "ru-central1-e"
  network_id     = yandex_vpc_network.default.id
}