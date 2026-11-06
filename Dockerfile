# Build image for MechJeb2 CI: the same tools the build job used to install on every run.
# The Mono packages that build.yml cached as .deb files are installed here, so a job starts with them in place.
# KSP's own libraries are not baked in: build.yml still downloads them (KSPLibs), since they are Squad's files.
FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq \
 && apt-get install -y -qq mono-complete git curl unzip zip ca-certificates sudo libicu-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN mono --version | head -1

# Links the package to this repository on ghcr.io, so its Actions access settings can grant other repos pulls.
LABEL org.opencontainers.image.source="https://github.com/sarbian/KSP_CI"
