#!/bin/bash
#
# This file can contain commands that will be executed (as root) before
# Calamares is started. So here you may configure various settings.
#
# NOTE! This is an advanced feature, so you need to know *exactly* what
# you are doing. Otherwise bad things can happen...
# Sound knowledge of bash language and linux commands is required
# for a meaningful customization.
#
# If you add commands to this file, start the whole install process fresh
# with terminal command 'antergos-welcome' after saving this file.
#
# Tip: save your customized commands into a file on an internet server
# and fetch that file with command:
#
#     wget -O ~/user-commands-before.bash "URL-referring-the-file"
#
#----------------------------------------------------------------------------------
#
# Now *you* can add your commands into function _IsoConfig below.
#
#----------------------------------------------------------------------------------

_IsoConfig() {
    ## Add your ISO configurations here.
    ## This is executed as root before the installer is started.

    local -r install_mode="$1"          # 'online' or 'offline'

    ## Now your commands. Some examples:
    #
}

## Execute the commands if the parameter list is valid:

case "$1" in
    offline | online) _IsoConfig "$1" ;;
esac
