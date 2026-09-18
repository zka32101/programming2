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

# Define Secret Manager secrets for kokugo-kore
locals {
  kokugo_secrets = [
    "kokugo-kore-revenuecat-api-key",
    "kokugo-kore-admob-app-id",
    "kokugo-kore-admob-banner-ad-unit-id",
    "kokugo-kore-admob-interstitial-ad-unit-id",
    "kokugo-kore-android-keystore-base64",
    "kokugo-kore-android-keystore-password",
    "kokugo-kore-android-key-password",
    "kokugo-kore-play-console-sa-key",
  ]
}

# Create secrets in Secret Manager
resource "google_secret_manager_secret" "kokugo_secrets" {
  for_each = toset(local.kokugo_secrets)

  secret_id = each.value
  replication {
    automatic = true
  }

  labels = {
    app     = "kokugo-kore"
    managed = "terraform"
  }
}

# Output secret IDs
output "created_secrets" {
  value       = [for secret in google_secret_manager_secret.kokugo_secrets : secret.id]
  description = "List of created Secret Manager secret IDs"
}
