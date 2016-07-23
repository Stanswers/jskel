# Synergy

## About

Synergy is a software KVM that connects via a network connection.  Debut
includes some systemd service files and synergy configuration files.

## Install

Both the client server systemd/synergys configs are host specific and thus
are not included in the install.  Copy the respective files into place then
enable and start the daemon with systemd.

Create the user systemd directory if it doesn't exist:

```bash
mkdir -p ~/.config/systemd/user/
```

Server install:

```bash
cp config/systemd/user/synergys.service ~/.config/systemd/user/
cp synergy.conf ~/.synergy.conf
systemctl --user enable synergys.service
systemctl --user start synergys.service
```

Client install:

```bash
cp config/systemd/user/synergyc.service ~/.config/systemd/user/
systemctl --user enable synergyc.service
systemctl --user start synergyc.service
```

Be sure to configure `~/.synergy.conf` for servers or
`~/.config/systemd/user/synergyc.service` for clients before hand.

