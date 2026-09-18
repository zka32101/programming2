variable "gcp_project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "shougakukore"
}

variable "service_account_email" {
  description = "Service account email for GitHub Actions CI/CD"
  type        = string
  default     = "kokugo-kore-ci-bot@shougakukore.iam.gserviceaccount.com"
}
