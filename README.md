# KSP_CI

Build image for MechJeb2's CI: Ubuntu 26.04 with Mono (mono-complete) and the tools the build job needs. It is published to `ghcr.io/sarbian/ksp-ci`.

Why: `build.yml` used to install Mono on every run, through the apt mirror. A cache hit still stalled for up to 21 minutes in the install step. With the packages in the image, a job starts with them in place.

## Contents

- `Dockerfile`: the image.
- The image holds no KSP files. The build job still downloads KSPLibs at run time.

## Build and push

```bash
docker build -t ghcr.io/sarbian/ksp-ci:<tag> .
docker push ghcr.io/sarbian/ksp-ci:<tag>
```

Pushing needs a token with `write:packages` (`gh auth refresh -s write:packages,read:packages`).
