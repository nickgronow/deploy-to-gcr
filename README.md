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

Your `gcp_service_key` must be in json format with the following permissions:

- Service Account User
- Storage Admin

### Check for changes before deploying

By default this action will check for changes in the working directory
before continuing with the deployment.  You can disable this default behavior
by setting the flag to false, like so:

```bash
- name: Deploy image to GCR
  uses: nickgronow/deploy-to-gcr@v1
  with:
    project: [your-gcp-project-id]
    service_key: ${{ secrets.gcp_service_key }}
    check_if_changed: false
```

### Specify a working directory

The working directory determines the context for the docker build.
This setting will be passed as the final parameter.
It also determines what directory to look for changes.

```bash
- name: Deploy image to GCR
  uses: nickgronow/deploy-to-gcr@v1
  with:
    project: [your-gcp-project-id]
    service_key: ${{ secrets.gcp_service_key }}
    working_directory: path/to/dir
```

### Specify the dockerfile location

This optional setting is useful if your Dockerfile is located somewhere other
than the working directory.

```bash
- name: Deploy image to GCR
  uses: nickgronow/deploy-to-gcr@v1
  with:
    project: [your-gcp-project-id]
    service_key: ${{ secrets.gcp_service_key }}
    dockerfile: path/to/dockerfile/dir
```

### Image name

The image name will default to the name of your repo, without the user/org name.

```bash
- name: Deploy image to GCR
  uses: nickgronow/deploy-to-gcr@v1
  with:
    project: [your-gcp-project-id]
    service_key: ${{ secrets.gcp_service_key }}
    image: your-image-name
```

### Image tag

The image tag will default to latest.  In addition the commit sha will also be
added and pushed.

```bash
- name: Deploy image to GCR
  uses: nickgronow/deploy-to-gcr@v1
  with:
    project: [your-gcp-project-id]
    service_key: ${{ secrets.gcp_service_key }}
    image_tag: your-image-tag
```

### Dockerfile

If your dockerfile lives in a different directory than the root of the working
directory you can specify its path relative to the working directory here.

```bash
- name: Deploy image to GCR
  uses: nickgronow/deploy-to-gcr@v1
  with:
    project: [your-gcp-project-id]
    service_key: ${{ secrets.gcp_service_key }}
    dockerfile: path/to/Dockerfile
```

WIP
