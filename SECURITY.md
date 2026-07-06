# Security Policy

## Supported Versions

Only the latest ISO build receives security updates. There are no LTS releases.

| Version | Supported |
|---------|-----------|
| latest (rolling) | ✅ |

## Reporting a Vulnerability

Please **do not** report security vulnerabilities through public GitHub issues, discussions, or pull requests.

Instead, report via **GitHub Private Vulnerability Reporting** for this repository. If that's unavailable, email `ash8820@proton.me`.

When reporting, include:

- The ISO build date or commit SHA
- A description of the issue and why it's security-sensitive
- Steps to reproduce or a proof of concept
- Any relevant logs, payloads, or screenshots
- The potential impact
- Suggested mitigations or fixes, if known

You can expect an acknowledgment within 3 business days. After assessment, I'll work on a fix and coordinate disclosure timing when appropriate.

## Scope

This covers the ISO build system (`buildiso`, profiles, overlays) and the live environment. For issues in custom packages (calamares, branding, keyring), report to the [antergos-packages](https://github.com/Antergos-NeXT/antergos-packages) repo. For upstream Calamares issues, report to [Calamares upstream](https://codeberg.org/calamares/calamares).
