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
variable "cluster_name" {
  type    = string
  default = "test-cluster"
}