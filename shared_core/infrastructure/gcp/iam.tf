# Grant Secret Accessor role to CI/CD service account
resource "google_secret_manager_secret_iam_member" "ci_bot_secret_accessor" {
  for_each = google_secret_manager_secret.app_secrets

  secret_id = each.value.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.service_account_email}"
}

# Grant Secret Version Manager role for adding new versions
resource "google_secret_manager_secret_iam_member" "ci_bot_secret_version_manager" {
  for_each = google_secret_manager_secret.app_secrets

  secret_id = each.value.secret_id
  role      = "roles/secretmanager.secretVersionManager"
  member    = "serviceAccount:${var.service_account_email}"
}

output "iam_bindings" {
  value       = "Service account ${var.service_account_email} has been granted Secret Manager access"
  description = "IAM bindings summary"
}
