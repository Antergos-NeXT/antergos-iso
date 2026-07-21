---
title: System Requirements
layout: default
nav_order: 3
---

# System Requirements

## Minimum

- **CPU**: Any 64-bit x86 processor, 2 or more cores
- **RAM**: 4 GB (sufficient for desktop use with a web browser open)
- **Storage**: 30 GB available space
- **GPU**: OpenGL 2.0 capable integrated or discrete graphics
- **Display**: 1024×768 resolution
- **Firmware**: UEFI (recommended), Legacy BIOS supported

## Recommended

- **CPU**: Quad-core 64-bit x86 or better
- **RAM**: 8 GB
- **Storage**: 64 GB or larger SSD
- **GPU**: Any modern GPU with open-source drivers (AMD, Intel) or NVIDIA with proprietary drivers
- **Display**: 1920×1080 or higher, 16:9 aspect ratio recommended
- **Firmware**: UEFI

## Notes

### RAM usage

A fresh KDE Plasma 6 session with the Antergos NeXT theme uses approximately 1.5 GB of RAM at idle. This accounts for the desktop shell, background services (NetworkManager, CUPS, Bluetooth, cronie, syslog-ng, pipewire), and the compositor. Opening a web browser adds roughly 500 MB–1 GB depending on tabs.

### Display aspect ratio

The default Plasma theme uses icon assets designed for widescreen displays. On 4:3 or narrower aspect ratios, some panel icons may clip. The GRUB theme (Layan) also targets 16:9 and may appear misaligned on narrower displays.

### GPU acceleration

Wayland compositing benefits from GPU acceleration. Systems without a supported GPU fall back to software rendering via LLVMpipe, which increases CPU load and reduces responsiveness. Install the proprietary NVIDIA driver from the Artix `system` repository if using an NVIDIA GPU.
