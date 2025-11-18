data "google_artifact_registry_repository" "repos" {
  for_each = var.artifact_repositories

  project       = var.project_id
  location      = var.region
  repository_id = each.key
}