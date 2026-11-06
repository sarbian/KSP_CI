# Build image for MechJeb2 CI: the tools the build job needs, with Mono and the packages it used to install on every run.
# KSP's own libraries are not baked in: build.yml still downloads them (KSPLibs), since they are Squad's files.
FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

# Packages are installed as root, then the job runs as the unprivileged user "runner" (uid/gid 1001, as on GitHub's
# hosted runners). Mono and the .NET SDK need libicu, which the runner image has too.
RUN apt-get update -qq \
 && apt-get install -y -qq mono-complete git curl unzip zip ca-certificates libicu-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && (getent group 1001 || groupadd -g 1001 runner) \
 && (id -u 1001 >/dev/null 2>&1 || useradd -m -u 1001 -g 1001 -s /bin/bash runner)

RUN mono --version | head -1

# Links the package to this repository on ghcr.io, so its Actions access settings can grant other repos pulls.
LABEL org.opencontainers.image.source="https://github.com/sarbian/KSP_CI"

USER 1001:1001
