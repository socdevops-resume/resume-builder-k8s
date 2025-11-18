resource "google_artifact_registry_repository" "repos" {
  for_each = var.artifact_repositories

  location      = var.region
  repository_id = each.key
  description   = each.value.description
  format        = "DOCKER"

  depends_on = [
    google_project_service.enabled_services["artifactregistry.googleapis.com"]
  ]
}