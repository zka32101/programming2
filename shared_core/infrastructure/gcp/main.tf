terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = "asia-northeast1"
}

# Define Secret Manager secrets for every app in var.apps.
# Each entry becomes a Secret Manager secret ID "<app_name>-<key>" (no value yet —
# populate actual values with set-secret-value.sh / populate-secrets.ps1).
locals {
  app_secret_pairs = flatten([
    for app_name, keys in var.apps : [
      for key in keys : {
        id  = "${app_name}-${key}"
        app = app_name
      }
    ]
  ])

  # map: secret_id -> owning app_name (for labels + iam.tf for_each)
  app_secret_map = { for pair in local.app_secret_pairs : pair.id => pair.app }
}

# Create secrets in Secret Manager
resource "google_secret_manager_secret" "app_secrets" {
  for_each = local.app_secret_map

  secret_id = each.key
  replication {
    auto {}
  }

  labels = {
    app     = each.value
    managed = "terraform"
  }
}

# Output secret IDs grouped by app
output "created_secrets_by_app" {
  value = {
    for app_name in distinct(values(local.app_secret_map)) :
    app_name => [for id, app in local.app_secret_map : id if app == app_name]
  }
  description = "Secret Manager secret IDs created, grouped by app_name"
}
