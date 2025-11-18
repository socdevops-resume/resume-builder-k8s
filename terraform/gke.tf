# Service account for GKE nodes
resource "google_service_account" "gke_nodes" {
  account_id   = "gke-nodes"
  display_name = "GKE Nodes Service Account"
}

# Allow nodes to read from Artifact Registry
resource "google_project_iam_member" "gke_sa_artifact_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

# Logging writer for nodes
resource "google_project_iam_member" "gke_sa_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

# Monitoring writer for nodes
resource "google_project_iam_member" "gke_sa_monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

# GKE cluster (regional, using location)
resource "google_container_cluster" "resume_gke" {
  name     = "${var.gke_cluster_name}-${var.environment}"
  location = var.gke_location
  project  = var.project_id

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network
  subnetwork = var.subnetwork

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  depends_on = [
    google_project_service.enabled_services["container.googleapis.com"],
    google_project_service.enabled_services["compute.googleapis.com"],
  ]
}

# Node pool
resource "google_container_node_pool" "primary_nodes" {
  name     = "primary-pool-${var.environment}"
  cluster  = google_container_cluster.resume_gke.name
  location = google_container_cluster.resume_gke.location
  project  = var.project_id

  node_count = var.gke_node_count

  node_config {
    machine_type    = var.gke_machine_type
    service_account = google_service_account.gke_nodes.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = {
      env = var.environment
    }

    tags = [
      "resume-gke-node",
      "env-${var.environment}",
    ]
  }

  depends_on = [
    google_container_cluster.resume_gke,
    google_service_account.gke_nodes,
  ]
}
