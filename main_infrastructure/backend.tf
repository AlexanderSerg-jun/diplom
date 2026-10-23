terraform {
  backend "s3" {
    #bucket    = "tf-state-bucket-test-01"
    bucket    = "my-tf-state-bucket"
    region    = "ru-central1"
    key       = "main-infrastructure.tfstate"
    
    
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }

   
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    
     
  }
}