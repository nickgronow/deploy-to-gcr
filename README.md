![Continuous Integration](https://github.com/nickgronow/deploy-to-gcr/workflows/Continuous%20Integration/badge.svg)

# Github Action - Deploy to GCR

An GitHub Action that pulls, builds from cached, then pushes to gcr.

## Usage

In your actions workflow, insert this:

```bash
- name: Deploy image to GCR
  uses: nickgronow/deploy-to-gcr@v1
  with:
    project: your-gcp-project-id
    service_key: ${{ secrets.gcp_service_key }}
```

Your `gcp_service_key` must be in json format with the following permissions:

- Service Account User
- Storage Admin

### Image name

The image name will default to the name of your repo, without the user/org name.

```bash
- name: Deploy image to GCR
  uses: nickgronow/deploy-to-gcr@v1
  with:
    project: your-gcp-project-id
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
    project: your-gcp-project-id
    service_key: ${{ secrets.gcp_service_key }}
    image_tag: your-image-tag
```

### Check for changes before deploying

NOTE: Github has a built-in way to do this now on git push/pull.  I will link to their
docs on this soon.  In the meantime, feel free to use this.

By default this action will check for changes in the working directory
before continuing with the deployment.  You can disable this default behavior
by setting the flag to false, like so:

```bash
- name: Deploy image to GCR
  uses: nickgronow/deploy-to-gcr@v1
  with:
    project: your-gcp-project-id
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
    project: your-gcp-project-id
    service_key: ${{ secrets.gcp_service_key }}
    working_directory: path/to/dir
```

### Dockerfile

If your dockerfile lives in a different directory than the root of the working
directory you can specify its path relative to the working directory here.

```bash
- name: Deploy image to GCR
  uses: nickgronow/deploy-to-gcr@v1
  with:
    project: your-gcp-project-id
    service_key: ${{ secrets.gcp_service_key }}
    dockerfile: path/to/Dockerfile
```

### Build variables

To pass environmental variables to the docker build command add a string of
comma-separated values to the `build_args` setting.

```bash
- name: Deploy image to GCR
  uses: nickgronow/deploy-to-gcr@v1
  with:
    project: your-gcp-project-id
    service_key: ${{ secrets.gcp_service_key }}
    build_args: "VAR1,VAR2"
  env:
    VAR1: foo
    VAR2: bar
```
