# Grub

A few tips for configuring grub.

## Set default grub entry to last used

Although `/etc/default/grub` contains `GRUB_DEFAULT=saved` it doesn't
set `GRUB_SAVEDEFAULT` so the last grub entry used to boot is not saved.  Add
the following to `/etc/default/grub`:

```
GRUB_SAVEDEFAULT="true"
```

Update the grub config:

```bash
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
```

note: grub config location can vary (i.e. UEFI vs MBR)

## HiDpi grub menu

Well grub doesn't support hidpi displays.  To work around this we must
convert a font at a desired size into a format that grub can use.

```bash
sudo grub2-mkfont -s 48 -o /boot/grub2/consola.pf2 ~/.local/share/fonts/consola.ttf
```

Add the following to `/etc/default/grub`:

```bash
GRUB_FONT=/boot/grub2/consola.pf2
```

Update the grub config:

```bash
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
```
