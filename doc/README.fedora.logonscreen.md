# Fedora logon screen customizations

Just a few tips on how to tweak fedora's logon screen

## Set time to default to 12h clock on logon screen and newly create users

Create override file.
```
sudo cat >> /usr/share/glib-2.0/schemas/org.gnome.desktop.interface.gschema.override << EOF
[org.gnome.desktop.interface]
clock-format='12h
EOF
```

Recompile schemas
```
sudo glib-compile-schemas /usr/share/glib-2.0/schemas
```

## Set the gnome display setting on Wayland logon screen

From the logon screen select the settings wheel -> "GNOME on Wayland" and
logon with your user.  Then customize the display as you see fit.  Copy the
monitors configuration.

```
cp ~/.config/monitors.xml /var/lib/gdm/.config/monitors.xml
```

Note:  It looks like Wayland names things differently requiring you to
configure it while logged in using Wayland.  X11 seems to work with the
Wayland format so no worries logging in normally.

Optionally configure while logged in normally, copy the monitors.xml and
disable Wayland all together.  Disable Wayland by un-commenting
`WaylandEnable=false` in `/etc/gdm/custom.conf`.
