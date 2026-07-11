---
title: Init Systems
layout: default
nav_order: 3
has_children: true
---

# Init Systems

An **init system** is PID 1 — the first process that runs when your computer boots. It starts everything else: filesystems, networking, display manager, services. Think of it as a foreman: it doesn't do the work itself, but it makes sure everything happens in the right order.

Antergos NeXT lets you choose between **four** init systems during online installation. (Offline mode uses Dinit, the default.)

> **Don't know what to pick? Stick with Dinit** — it's the default, it's fast, and it's what Antergos NeXT ships with. OpenRC is also available but currently broken in Antergos NeXT (services don't enable correctly on installed systems).

## The inits

| Init | Philosophy | Complexity | Speed | Used by |
|------|-----------|------------|-------|---------|
| [Dinit](dinit) | Modern, dependency-based, parallel | Medium | Very fast | Antergos NeXT (default), Chimera Linux, Artix, new projects |
| [OpenRC](openrc) | Traditional, modular, shell-script-based | Low | Fast | Gentoo, Artix, Devuan, Alpine — **currently broken in Antergos NeXT** |
| [Runit](runit) | Minimal, supervision-based, Unix-like | Low | Very fast | Void Linux, AntiX |
| [S6](s6) | Full supervision suite, modular | Medium-High | Very fast | Artix, embedded systems |

## Choosing an init

| If you want... | Pick... |
|----------------|---------|
| The fastest boot, automatic dependency resolution | Dinit |
| Something familiar, well-documented, simple | OpenRC |
| The simplest supervision-based approach | Runit |
| The most powerful non-systemd init with full supervision | S6 |

## What they all have in common

- **No systemd** — all four are independent implementations
- **Service scripts** — services are configured via files in `/etc/`
- **Runlevels** — groups of services that start together under different conditions
- **Plain-text logging** — logs go to `/var/log/`, not `journalctl`

## Key differences

| Aspect | Dinit | OpenRC | Runit | S6 |
|--------|-------|--------|-------|-----|
| Service format | Declarative `.conf` files | Shell scripts | Executable `run` scripts | `run` scripts + s6-rc database |
| Dependencies | Automatic | Manual (`need`/`use`) | None | Automatic (s6-rc) |
| Supervision | Optional | No | Yes (runsv) | Yes (s6-supervise) |
| Logging | None built-in | syslog | Per-service (optional) | Per-service (s6-log) |
| Init script | None needed | `/etc/init.d/` | `/etc/runit/1/2/3` | s6-linux-init |

## Learning Linux with init systems

If you're new to Linux, init systems are one of the best ways to understand how your OS works under the hood:

- **Processes** — PID 1, service trees, process supervision
- **Boot order** — what needs to start before what
- **Dependencies** — why NetworkManager needs dbus, why dbus needs udev
- **Runlevels** — why your system behaves differently in single-user vs normal boot

The best part? If you break something with services, you can always fix it by re-enabling or starting it manually. Service management is much simpler than kernel config or package management.

## Switching init after install

Artix provides a [switching init guide](https://wiki.artixlinux.org/Main/SwitchInit) that also works on Antergos NeXT. The process involves installing the new init's packages, configuring its services, and updating the bootloader.
