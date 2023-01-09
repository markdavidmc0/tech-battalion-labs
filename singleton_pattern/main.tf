provider "google" {
  project = var.project_id
  credentials = file("~path to gcp key")
  region = var.region
} 

resource "google_storage_bucket" "default" {
  name = var.bucket_name
  storage_class = var.storage_class
  location = var.bucket_location

}