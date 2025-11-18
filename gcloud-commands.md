# GCloud Commands
To authenticate with Google Cloud without launching a browser, use the following command:
```
gcloud auth login --no-launch-browser
```

Configure Docker to use gcloud for Artifact Registry
```
gcloud auth configure-docker us-central1-docker.pkg.dev
```


docker build -t \
  us-central1-docker.pkg.dev/resume-builder-platform/resume-api/resume-api:dev \
  .

docker push \
  us-central1-docker.pkg.dev/resume-builder-platform/resume-api/resume-api:dev