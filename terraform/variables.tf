variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Default GCP region (also used for Artifact Registry)"
  type        = string
  default     = "us-central1"
}

variable "gke_location" {
  description = "GKE location (region for regional cluster, or zone for zonal)"
  type        = string
  default     = "us-central1"
}

variable "gke_cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "resume-gke"
}

variable "gke_node_count" {
  description = "Number of nodes in the primary node pool"
  type        = number
  default     = 2
}

variable "gke_machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-standard-2"
}

#  useful everywhere (tags, labels, names)
variable "environment" {
  description = "Deployment environment (dev, stage, prod)"
  type        = string
  default     = "dev"
}

#  network configuration for GKE
variable "network" {
  description = "VPC network to use for GKE"
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "Subnetwork to use for GKE"
  type        = string
  default     = "default"
}

# Artifact Registry repos as data, not hardcoded resources
variable "artifact_repositories" {
  description = "Container repositories to create in Artifact Registry"
  type = map(object({
    description = string
  }))

  default = {
    "resume-frontend" = {
      description = "Frontend container repo"
    }
    "resume-api" = {
      description = "Resume API container repo"
    }
    "llm-service" = {
      description = "LLM service container repo"
    }
  }
}
