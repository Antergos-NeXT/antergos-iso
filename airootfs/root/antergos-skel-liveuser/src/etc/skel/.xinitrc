#!/bin/sh

# Force EGL
export EGL_PLATFORM=x11
export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=GNOME

# Start GNOME session on X11
exec gnome-session
