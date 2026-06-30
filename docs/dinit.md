---
title: Dinit
layout: default
parent: Init Systems
nav_order: 2
---

# Dinit

**Dinit** is a modern init system designed for speed and correctness. Written in C++, it focuses on parallel service startup and dependency management without the bloat of systemd or the complexity of S6.

## Philosophy

Dinit aims to be a "better than OpenRC but simpler than S6" middle ground. It handles dependencies automatically (like systemd) but stays out of your way (like OpenRC). Services are defined in declarative config files, not shell scripts.

## Who uses it?

- Not widely adopted by major distros yet
- Popular in DIY Linux builds (Linux From Scratch, custom embedded)
- Available in Artix as an alternative init

## Key concepts

| Concept | What it means |
|---------|---------------|
| Service files | Declarative `.conf` files in `/etc/dinit.d/` |
| Dependencies | Automatic — Dinit figures out start order |
| Parallel startup | Very fast — starts services concurrently |
| Process supervision | Optional — can restart crashed services |

## Basic commands

```bash
# Start a service
dinitctl start sshd

# Stop a service
dinitctl stop sshd

# Enable at boot
dinitctl enable sshd

# Disable at boot
dinitctl disable sshd

# Check status
dinitctl status sshd

# List all services
dinitctl list
```

## Example service file

`/etc/dinit.d/sshd.conf`:
```
type = process
command = /usr/bin/sshd -D
depends-on = dbus
depends-on = network
```

## Comparison with OpenRC

| | OpenRC | Dinit |
|---|--------|-------|
| Service format | Shell scripts | Declarative config |
| Dependencies | Manual (`need`/`use`) | Automatic |
| Speed | Fast | Very fast (more parallel) |
| Complexity | Low | Medium |
| Supervision | No built-in | Optional |

## Should you use it?

Pick Dinit if:
- You want the fastest possible boot
- You like declarative config (YAML-like)
- You want automatic dependency resolution
- You don't mind a less mature ecosystem

Stick with OpenRC if:
- You want maximum stability and community support
- You prefer shell scripts you can read and debug
- You don't care about shaving seconds off boot time

## Learn more

- [Dinit GitHub](https://github.com/davmac314/dinit)
- [Dinit documentation](https://davmac.org/projects/dinit/)
- [Artix Dinit page](https://wiki.artixlinux.org/Main/dinit)
