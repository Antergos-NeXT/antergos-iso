---
title: OpenRC
layout: default
parent: Init Systems
nav_order: 1
---

# OpenRC

**OpenRC** is one of four init systems available in Antergos NeXT (the default is **Dinit**). It's used by Gentoo, Artix Linux, Devuan, Alpine Linux, and other non-systemd distros. It's proven, well-maintained, and about as simple as an init system can get while still being feature-rich.

## systemd vs OpenRC at a glance

| | systemd | OpenRC |
|---|---|---|
| Philosophy | "One tool to rule them all" | "Do one thing well (Unix way)" |
| Logs | `journalctl` (binary logs) | Plain text files in `/var/log/` |
| Service mgmt | `systemctl start/stop/enable` | `rc-service start/stop`, `rc-update add/del` |
| Dependency | Parallel + automatic | Manual or explicit `need/use/before/after` |
| Config files | `.service` units (INI-like) | Shell scripts in `/etc/init.d/` |
| Size | ~80+ binaries, 500k+ lines | ~15 binaries, ~30k lines |
| Scope | PID 1 + logind + resolved + timedated + networkd + ... | Just PID 1 |

OpenRC is used by Gentoo, Artix Linux, Devuan, Alpine Linux, and other non-systemd distros. It's not as mainstream as systemd, but it's proven and well-maintained.

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

## Why did Antergos NeXT switch?

Three reasons:

1. **systemd grew beyond an init system** — it now owns logind, resolved, timedated, networkd, homed, and more. It's no longer just PID 1. It's a full OS management suite with a scope that keeps expanding.

2. **systemd dropped SysV compatibility** — version 260 (March 2026) removed `systemd-sysv-generator`, `rc-local.service`, and all legacy compatibility code. If your distro isn't 100% systemd-native, it breaks.

3. **systemd's age verification PR** — [#40954](https://github.com/systemd/systemd/pull/40954) (merged Mar 2026) added `birthDate` fields to userdb JSON for age verification compliance. Optional today, precedent tomorrow. We don't want our OS to ask for your age.

OpenRC doesn't do any of that. It starts services and gets out of the way.

## Will things break?

Probably not. Most desktop software doesn't care about the init system. Browsers, editors, games, media players — they all work the same.

Things that **do** care about systemd and won't work:
- `systemctl`, `journalctl`, `loginctl`, `timedatectl` — obviously
- GNOME (it dropped non-systemd support)
- Any `.service` file you try to run directly (they're systemd-native)

But everything you actually use day-to-day? Works fine. And if you need to check logs, they're in `/var/log/messages` — plain text, no `journalctl` required.

## Learning more

- [OpenRC documentation](https://wiki.gentoo.org/wiki/OpenRC)
- [Gentoo Handbook: OpenRC](https://wiki.gentoo.org/wiki/Handbook:AMD64/Full/Installation#OpenRC)
- [Comparison of init systems (Wikipedia)](https://en.wikipedia.org/wiki/Comparison_of_init_systems)
