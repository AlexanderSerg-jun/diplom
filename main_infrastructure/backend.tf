terraform {
  backend "s3" {
    bucket    = "tf-state-bucket-test-01"
    region    = "ru-central1"
    key       = "main-infrastructure.tfstate"
    
    # Новый синтаксис для Yandex S3
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }

    # Эти параметры остаются обязательными для Yandex
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    
     
  }
}