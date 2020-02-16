# Github Action for Cached GCR Docker Image Deployments

An GitHub Action for deploying revisions to Google Cloud Run.

## Usage

Docker image

In your actions workflow, somewhere after the step that builds
`gcr.io/<your-project>/<image>`, insert this:

```bash
- name: Deploy image to GCR
  uses: nickgronow/deploy-to-gcr@v1
  with:
    project: [your-gcp-project-id]
    service_key: ${{ secrets.gcp_service_key }}
```

Your `gcp_service_key` secret (or whatever you name it) must be a base64 encoded
gcloud service key with the following permissions:

- Service Account User
- Storage Admin
