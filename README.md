# Github Action - Deploy to GCR

An GitHub Action that pulls, builds from cached, then pushes to gcr.

## Usage

In your actions workflow, insert this:

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
