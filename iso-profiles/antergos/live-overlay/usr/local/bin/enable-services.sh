#!/usr/bin/bash

set -e

USERNAME="${1:-}"
ROOT="${2:-}"

if [[ -z "$ROOT" ]]; then
    ROOT="/"
fi

chroot_run() {
    chroot "$ROOT" "$@"
}

svc_enable_dinit() {
    for svc in NetworkManager acpid bluetoothd cronie cupsd dbus dhcpcd power-profiles-daemon sddm syslog-ng; do
        if [[ -f "$ROOT/etc/dinit.d/$svc" ]]; then
            chroot_run ln -sf /etc/dinit.d/"$svc" /etc/dinit.d/boot.d/"$svc"
        fi
    done
    chroot_run ln -sf /usr/lib/dinit.d/dinit-user-spawn /etc/dinit.d/boot.d/
}

usr_svc_enable_dinit() {
    local user="$1"
    if [[ -z "$user" ]] || [[ ! -d "$ROOT/home/$user" ]]; then
        return
    fi
    for svc in pipewire wireplumber; do
        if [[ -f "$ROOT/etc/dinit.d/user/$svc" ]]; then
            chroot_run mkdir -p "/home/$user/.config/dinit.d/boot.d"
            chroot_run ln -sf "/etc/dinit.d/user/$svc" "/home/$user/.config/dinit.d/boot.d/$svc"
            chroot_run chown -R "$user:$user" "/home/$user/.config/dinit.d"
        fi
    done
}

svc_enable_openrc() {
    for svc in NetworkManager acpid bluetoothd cronie cupsd dbus dhcpcd power-profiles-daemon sddm syslog-ng; do
        if [[ -f "$ROOT/etc/init.d/$svc" ]]; then
            chroot_run rc-update add "$svc" default
        fi
    done
}

usr_svc_enable_openrc() {
    local user="$1"
    if [[ -z "$user" ]] || [[ ! -d "$ROOT/home/$user" ]]; then
        return
    fi
    for svc in pipewire pipewire-pulse wireplumber; do
        if [[ -f "$ROOT/etc/user/init.d/$svc" ]]; then
            chroot_run mkdir -p "/home/$user/.config/rc/runlevels/default"
            chroot_run ln -sf "/etc/user/init.d/$svc" "/home/$user/.config/rc/runlevels/default/$svc"
            chroot_run chown -R "$user:$user" "/home/$user/.config/rc"
        fi
    done
}

svc_enable_runit() {
    for svc in NetworkManager acpid bluetoothd cronie cupsd dbus dhcpcd power-profiles-daemon sddm syslog-ng; do
        if [[ -d "$ROOT/etc/runit/sv/$svc" ]]; then
            chroot_run ln -sf /etc/runit/sv/"$svc" /etc/runit/runsvdir/default/"$svc"
        fi
    done
}

svc_enable_s6() {
    for svc in NetworkManager acpid bluetoothd cronie cupsd dbus dhcpcd power-profiles-daemon sddm syslog-ng; do
        if [[ -d "$ROOT/etc/s6/sv/$svc" ]] || [[ -d "$ROOT/etc/s6/sv/${svc}-srv" ]]; then
            chroot_run s6-service add default "$svc"
        fi
    done
    chroot_run s6-db-reload -r
}

if [[ -f "$ROOT/usr/bin/dinitctl" ]]; then
    svc_enable_dinit
    usr_svc_enable_dinit "$USERNAME"
elif [[ -f "$ROOT/usr/bin/rc-update" ]]; then
    svc_enable_openrc
    usr_svc_enable_openrc "$USERNAME"
elif [[ -f "$ROOT/usr/bin/runsvdir" ]]; then
    svc_enable_runit
elif [[ -f "$ROOT/usr/bin/s6-service" ]]; then
    svc_enable_s6
fi
