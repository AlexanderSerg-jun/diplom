variable "sa_key_file" {
  description = "Path to SA key"
  type        = string
}
variable "cloud_id" {
  type = string
}
variable "folder_id" {
  type = string
}
variable "bucket_name" {
  description = "Name for the State Bucket"
  type        = string
  default     = "bucket-netology" 
}