terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "~> 0.94"
    }
  }
  # В этой папке используем локальный бэкенд, так как бакета еще нет
  backend "local" {}
}

provider "yandex" {
  service_account_key_file = var.sa_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = "ru-central1-a"
}
# Создаем бакет в Object Storage
resource "yandex_storage_bucket" "tf_state" {
  bucket = var.bucket_name
}

# Важно: Бакет должен быть публичным только для чтения? Нет.
# Для Terraform нам нужен доступ через API. Object Storage по умолчанию приватный.
# Чтобы Terraform (через S3 backend) мог писать туда, ему нужны права.
# SA уже имеет роль editor, этого достаточно.