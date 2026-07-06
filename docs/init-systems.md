---
title: Init Systems
layout: default
nav_order: 3
has_children: true
---

# Init Systems

An **init system** is the first process that runs when your computer boots (PID 1). It's responsible for starting everything else — filesystems, networking, display manager, services, and more. Think of it as the foreman at a construction site: it doesn't do the work itself, but it makes sure everything gets started in the right order.

Antergos NeXT lets you choose between **four** init systems during installation. This page explains each one so you can pick what suits you.

> Don't know what init to choose? **Stick with Dinit** — it's the default, it's fast, and it's what Antergos NeXT ships with. OpenRC is also available if you prefer a more traditional approach.

## The inits

| Init | Philosophy | Complexity | Speed | Used by |
|------|-----------|------------|-------|---------|
| [Dinit](dinit) | Modern, dependency-based | Medium | Very fast | Antergos NeXT, Artix, new projects |
| [OpenRC](openrc) | Simple, modular, Unix-like | Low | Fast | Gentoo, Artix, Devuan, Alpine |
| [Runit](runit) | Minimal, reliable, Unix-like | Low | Very fast | Void Linux, AntiX |
| [S6](s6) | Supervision-based, secure | Medium-High | Very fast | New projects, embedded |

## Choosing an init

| If you want... | Pick... |
|----------------|---------|
| The fastest boot possible | Dinit or S6 |
| Something familiar and well-documented | OpenRC |
| The simplest, most Unix-like approach | Runit |
| Advanced supervision and process management | S6 |

## What they all have in common

- **No systemd** — all four are independent implementations
- **Service scripts** — services are configured via files in `/etc/`
- **Runlevels** — groups of services that start together
- **Logging to files** — logs go to `/var/log/`, not `journalctl`

## What's different

The main differences are in:

1. **How services are defined** — OpenRC uses shell scripts, Dinit uses a declarative config format, Runit uses executable scripts, S6 uses a supervision tree
2. **How they manage dependencies** — some handle it automatically, some leave it to you
3. **How they supervise processes** — some restart crashed services automatically, some don't
4. **How fast they boot** — Dinit and S6 are designed for parallel startup and are noticeably faster

## Learning Linux with init systems

If you're new to Linux, learning about init systems is a great way to understand how your OS works under the hood. Here's why:

- **You'll learn about processes** — PID 1, service trees, process supervision
- **You'll learn about boot order** — what needs to start before what
- **You'll learn about dependencies** — why NetworkManager needs dbus, why dbus needs udev
- **You'll learn about logging** — where logs go, how to read them
- **You'll learn about runlevels** — why your system behaves differently in single-user mode vs normal boot

The best part? If you break something with services, you can always fix it — service management is much simpler than kernel config or package management.

> **Pro tip**: If you're dual-booting or using a VM, try all four inits. Install a test system with Dinit first, then reinstall with OpenRC, then Runit, then S6. See which one feels right.
