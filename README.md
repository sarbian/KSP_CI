# KSP_CI

Build image for MechJeb2's CI: Ubuntu 26.04 with Mono (`mono-complete`), libicu (which the .NET SDK needs) and the tools the build job uses. It is published to `ghcr.io/sarbian/ksp-ci` and is public.

Why: MechJeb2's `build.yml` used to install Mono on every run, through the apt mirror. Even with the packages cached, the install step stalled for up to 21 minutes. With Mono in the image, a job starts with it in place.

## The image

- Tags: `26.04` and `latest`, both the current build. MechJeb2's `build.yml` uses `26.04`.
- It runs as the unprivileged user `runner` (uid/gid 1001, as on GitHub's hosted runners), not root, and has no sudo. Packages are installed while the image is built.
- No .NET SDK: the build job installs it with `actions/setup-dotnet`.
- No KSP files: they are Squad's, so the build job still downloads KSPLibs at run time.

## Publishing

`.github/workflows/publish.yml` builds the image and pushes both tags whenever `Dockerfile` or the workflow changes on `main`, or when it is started by hand (`workflow_dispatch`). Pushing from this repository with its own `GITHUB_TOKEN` keeps the package linked to it.

A change to the Dockerfile reaches every MechJeb2 build as soon as it is published, including open PRs: test it locally first.

```bash
docker build -t ksp-ci-test .
docker run --rm ksp-ci-test sh -c 'id; mono --version | head -1'
```
