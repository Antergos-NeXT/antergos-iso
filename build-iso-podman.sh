#!/bin/bash
set -euo pipefail

# Antergos NeXT ISO build inside the Artix container (see Containerfile).
# Rootful podman is required: artools' chroot mounts devtmpfs, which rootless
# containers cannot do.

cd "$(dirname "$0")"

# 1. Ensure the build image exists
if ! podman image exists localhost/antergos-build:latest; then
  podman build -t antergos-build .
fi

# 2. Run the build (privileged, workspace mounted, tmpfs workdir, ISO exported)
sudo podman run --rm --privileged \
  -v "$(pwd):/workspace" \
  -e WORKSPACE_DIR=/workspace \
  -e INITSYS=dinit \
  antergos-build sh -c '
    set -euo pipefail
    mkdir -p /var/lib/artools/buildiso
    mount -t tmpfs -o size=12G,exec,suid,dev tmpfs /var/lib/artools/buildiso
    /workspace/buildiso -p antergos
    echo "=== BUILD FINISHED ==="
    mkdir -p /workspace/iso-output
    cp -a /var/lib/artools/buildiso/iso/antergos/. /workspace/iso-output/ 2>/dev/null || true
    ls -la /workspace/iso-output/ | head -20
  '
