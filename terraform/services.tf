resource "google_project_service" "enabled_services" {
  for_each = toset([
    "artifactregistry.googleapis.com",
    "container.googleapis.com",      # GKE
    "compute.googleapis.com",        # GCE nodes for GKE
    "cloudbuild.googleapis.com",     # optional, for GCB builds
    "iam.googleapis.com",            # IAM
    "iamcredentials.googleapis.com", # workload identity / OIDC
    "serviceusage.googleapis.com",   # enabling/disabling services
    "cloudresourcemanager.googleapis.com",
    "logging.googleapis.com",    # Cloud Logging
    "monitoring.googleapis.com", # Cloud Monitoring
  ])

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}
