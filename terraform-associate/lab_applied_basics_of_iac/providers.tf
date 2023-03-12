terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0.0"
    }
  }
}

provider "google" {
  project     = var.production_project_id
  credentials = file(var.path_to_production_gcp_credentials)
  region      = var.region_us_west
}

provider "google" {
  alias       = "development"
  project     = var.development_project_id
  credentials = file(var.path_to_development_gcp_credentials)
  region      = var.region_us_west
}