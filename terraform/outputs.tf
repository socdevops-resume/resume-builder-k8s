output "project_id" {
  value       = var.project_id
  description = "GCP project ID"
}

output "region" {
  value       = var.region
  description = "Default region"
}

output "gke_cluster_name" {
  value       = google_container_cluster.resume_gke.name
  description = "Name of the GKE cluster"
}

output "gke_location" {
  value       = google_container_cluster.resume_gke.location
  description = "Location of the GKE cluster"
}

output "gke_endpoint" {
  value       = google_container_cluster.resume_gke.endpoint
  description = "GKE API server endpoint"
}

output "gke_node_sa_email" {
  value       = google_service_account.gke_nodes.email
  description = "Service account used by GKE nodes"
}

output "artifact_registry_repos" {
  value = {
    for name, repo in data.google_artifact_registry_repository.repos :
    name => repo.repository_id
  }
  description = "Artifact Registry repositories"
}