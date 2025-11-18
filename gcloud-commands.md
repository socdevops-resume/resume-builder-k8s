# GCloud Commands
To authenticate with Google Cloud without launching a browser, use the following command:
```
gcloud auth login --no-launch-browser
```

Configure Docker to use gcloud for Artifact Registry
```
gcloud auth configure-docker us-central1-docker.pkg.dev
```


```# Set variables
PROJECT_ID="your-gcp-project-id"
LOCATION="global"
POOL_ID="github-actions-pool"
PROVIDER_ID="github-actions-provider"
GITHUB_OWNER="your-github-username-or-organization"

Create a Workload Identity Pool for GitHub Actions

gcloud iam workload-identity-pools create "${POOL_ID}" \
  --project="${PROJECT_ID}" \
  --location="${LOCATION}" \
  --display-name="GitHub Actions Pool"
```


List Workload Identity Pools
```
gcloud iam workload-identity-pools list \
  --project="${PROJECT_ID}" \
  --location="${LOCATION}"

Create a OIDC Provider for GitHub Actions

gcloud iam workload-identity-pools providers create-oidc "${PROVIDER_ID}" \
  --project="${PROJECT_ID}" \
  --location="${LOCATION}" \
  --workload-identity-pool="${POOL_ID}" \
  --display-name="GitHub Actions Provider" \
  --issuer-uri="https://token.actions.githubusercontent.com" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository,attribute.repository_owner=assertion.repository_owner,attribute.ref=assertion.ref,attribute.actor=assertion.actor,attribute.aud=assertion.aud" \
  --attribute-condition="attribute.repository_owner=='${GITHUB_OWNER}'"


List OIDC Providers in a Workload Identity Pool

gcloud iam workload-identity-pools providers list \
  --project="${PROJECT_ID}" \
  --location="${LOCATION}" \
  --workload-identity-pool="${POOL_ID}"


Get the full provider name

gcloud iam workload-identity-pools providers describe "${PROVIDER_ID}" \
  --project="${PROJECT_ID}" \
  --location="${LOCATION}" \
  --workload-identity-pool="${POOL_ID}" \
  --format="value(name)"


Create a Service Account for GitHub Actions

gcloud iam service-accounts create github-ci \
  --project="${PROJECT_ID}" \
  --display-name="GitHub Actions CI"


PROJECT_NUMBER=$(gcloud projects describe "${PROJECT_ID}" --format="value(projectNumber)")

gcloud iam service-accounts add-iam-policy-binding \
  "github-ci@${PROJECT_ID}.iam.gserviceaccount.com" \
  --project="${PROJECT_ID}" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL_ID}/attribute.repository_owner/${GITHUB_OWNER}"

Grant the Service Account necessary roles

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:github-ci@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.writer"

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:github-ci@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/container.admin"

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:github-ci@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/logging.logWriter"

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:github-ci@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/monitoring.metricWriter"


```



# remote state backend (GCS)
```
PROJECT_ID="resume-builder-platform"
BUCKET_NAME="resume-builder-tfstate"

gcloud storage buckets create gs://$BUCKET_NAME \
  --project=$PROJECT_ID \
  --location=us    # or your preferred region/multi-region

# Grant the GitHub Actions Service Account access to the GCS bucket
SA_EMAIL="github-ci@${PROJECT_ID}.iam.gserviceaccount.com"

gcloud storage buckets add-iam-policy-binding gs://$BUCKET_NAME \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/storage.objectAdmin"
```