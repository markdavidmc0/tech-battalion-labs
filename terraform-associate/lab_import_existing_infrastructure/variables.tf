variable "project_id" {}

variable "region" {
  default = "us-west1"
}

variable "zone" {
  default = "us-west1-a"
}

variable "new_tags" {
  type = list(string)
  default = [
    "managed-under-terraform",
    "web-server",
    "production",
    "us-west1"
  ]
}
