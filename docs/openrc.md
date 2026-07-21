---
title: OpenRC
layout: default
parent: Init Systems
nav_order: 1
---

# OpenRC

**OpenRC** is a traditional init system used by Gentoo, Artix Linux, Devuan, Alpine Linux, and other non-systemd distributions. It is well-established, actively maintained, and provides a balance of simplicity and feature completeness.

> **Note:** Earlier Antergos NeXT builds shipped OpenRC as an install-time option but it had issues with service enabling on installed systems. If you want to use OpenRC on Antergos NeXT, see [Changing init](changing-init) for manual setup instructions.

## Comparison with systemd

| Feature | systemd | OpenRC |
|---------|--------|--------|
| Log storage | Binary journal (`journalctl`) | Plain text files (`/var/log/`) |
| Service control | `systemctl start/stop/enable` | `rc-service start/stop`, `rc-update add/del` |
| Dependency handling | Automatic, parallel | Manual (`need`/`use`/`before`/`after`) |
| Configuration format | `.service` unit files (INI-like) | Shell scripts (`/etc/init.d/`) |
| Binary footprint | ~80+ binaries | ~15 binaries |
| Scope | Init + logind + resolved + timedated + networkd + more | Init only |

## What changes for you as a user?

### Service management

| Task | systemd | OpenRC |
|------|---------|--------|
| Start a service | `sudo systemctl start sshd` | `sudo rc-service sshd start` |
| Stop a service | `sudo systemctl stop sshd` | `sudo rc-service sshd stop` |
| Enable at boot | `sudo systemctl enable sshd` | `sudo rc-update add sshd` |
| Disable at boot | `sudo systemctl disable sshd` | `sudo rc-update del sshd` |
| Check status | `systemctl status sshd` | `rc-service sshd status` |
| List enabled | `systemctl list-unit-files --enabled` | `rc-update show` |
| View logs | `journalctl -u sshd` | `less /var/log/messages` |

### Key commands

```bash
# List all services with their runlevel
rc-status

# List enabled services
rc-update show

# Add a service to a runlevel
rc-update add <service> <runlevel>

# Remove a service
rc-update del <service> <runlevel>

# Start/stop/restart a service
rc-service <service> start
rc-service <service> stop
rc-service <service> restart
```

Runlevels in OpenRC work like directories under `/etc/runlevels/`:

```
/etc/runlevels/
├── boot       # Low-level system services (filesystems, udev, etc.)
├── sysinit    # System initialization (hwclock, hostname, etc.)
├── default    # Normal boot services (NetworkManager, sshd, etc.)
└── shutdown   # Shutdown services
```

## Rationale for non-systemd

Antergos NeXT uses Dinit as its init system. The switch away from systemd was motivated by three factors:

1. **Scope expansion** — systemd has grown beyond process supervision to include logind, resolved, timedated, networkd, homed, and other subsystems. This consolidates OS management into a single project with an expanding scope.

2. **SysV compatibility removal** — systemd 260 (March 2026) removed `systemd-sysv-generator`, `rc-local.service`, and related legacy compatibility code, breaking distributions that were not fully systemd-native.

3. **Age verification (PR [#40954](https://github.com/systemd/systemd/pull/40954))** — merged March 2026, this added `birthDate` fields to userdb JSON for age verification compliance. While optional at the time of writing, the precedent raises concerns about future requirements.

## When to use OpenRC

OpenRC is suitable for users who want a well-documented, traditional init system with explicit dependency management. Its shell-script-based service files are straightforward to write and debug. Users migrating from Gentoo, Alpine, or Devuan will find OpenRC familiar.

OpenRC does not include built-in process supervision. Users who want automatic service restart on crash should consider Runit or S6 instead.

## Compatibility

Most desktop software is agnostic to the init system. Browsers, editors, games, and media players function identically regardless of what manages PID 1.

Software that does depend on systemd and will not function:
- `systemctl`, `journalctl`, `loginctl`, `timedatectl`
- GNOME (dropped non-systemd support upstream)
- Native `.service` unit files (systemd-only format)

Logs are written to plain text files under `/var/log/messages` and can be read with any text viewer.

## Learning more

- [OpenRC documentation](https://wiki.gentoo.org/wiki/OpenRC)
- [Gentoo Handbook: OpenRC](https://wiki.gentoo.org/wiki/Handbook:AMD64/Full/Installation#OpenRC)
- [Comparison of init systems (Wikipedia)](https://en.wikipedia.org/wiki/Comparison_of_init_systems)
