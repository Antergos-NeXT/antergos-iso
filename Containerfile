# Antergos NeXT ISO build container
#
# Build an Antergos NeXT ISO inside an Artix Linux container. This is the
# same path GitHub Actions uses, so anyone can produce a release ISO without
# running an Artix/Arch system (works on Gentoo, Fedora, anything with podman).
#
# Usage:
#   podman build -t antergos-build .
#   podman run --rm --privileged \
#     -v /var/lib/artools-buildiso:/var/lib/artools/buildiso \
#     -v "$(pwd)/iso-output:/workspace/iso-output" \
#     -e WORKSPACE_DIR=/workspace \
#     antergos-build
#
# --privileged is required: artools' chroot (via basestrap) mounts devtmpfs,
# proc and sysfs into the target, which rootless containers cannot do.
#
# The finished ISO is written to /workspace/iso-output (bind-mounted above).

FROM docker.io/artixlinux/artixlinux:base

ENV INITSYS=dinit \
    WORKSPACE_DIR=/workspace \
    CHROOTS_DIR=/var/lib/artools

# Full dependency set for an ISO build: artools (base + iso tools), squashfs
# for the .sfs layers, mkinitcpio for the initramfs, grub + xorriso for the
# bootable image, git/python for CI tooling and the Internet Archive uploader.
RUN pacman -Syu --noconfirm --needed --overwrite='*' \
      artools \
      git \
      squashfs-tools \
      sudo \
      python \
      python-pip \
      xorriso \
      dosfstools \
      syslinux \
      gptfdisk \
      mtools

# This repo's buildiso and profiles become the default build payload. Mounting
# a live checkout over /workspace at runtime replaces these with the user's copy.
WORKDIR /workspace
COPY . .

# Point artools at the Antergos package repository. CI copies the profile's
# pacman.conf into both the user config dir (first match) and artools' defaults.
RUN mkdir -p /root/.config/artools/pacman.conf.d \
    && cp pacman.conf.d/iso-x86_64.conf /root/.config/artools/pacman.conf.d/iso-x86_64.conf \
    && cp pacman.conf.d/iso-x86_64.conf /usr/share/artools/pacman.conf.d/iso-x86_64.conf

# The modified buildiso lives in this repo and must be used instead of
# /usr/bin/buildiso (which lacks --overwrite='*').
ENTRYPOINT ["/workspace/buildiso"]
CMD ["-p", "antergos"]
