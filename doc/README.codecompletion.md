# Code Completion

Code completion using RTags, Bear, vim-rtags, and neocomplete.  Bear is used
to generate the `compile_commands.json` file required by RTags.  RTags
provides completions for C/C++.  vim-rtags plugin provides RTags bindings for
VIM.  Neocomplete improves auto completion for VIM.

## Clone, configure, and install RTags

Clone the RTags repository then build and install rtags.
```
git clone https://github.com/Andersbakken/rtags.git
cd rtags
mkdir build
cmake ../
make
sudo make install
```

Configure Systemd
```
cp <jskel>/config/systemd/user/rdm.* ~/.config/systemd/user/
systemctl --user enable rdm.socket
systemctl --user start rdm.socket
```
See [rtags](https://github.com/Andersbakken/rtags) for more information.

## Clone and Install Bear

Clone the Bear repository then build and install Bear.
```
git clone https://github.com/rizsotto/Bear.git
cd Bear
mkdir build
cmake ../
make
sudo make install
```

See [Bear](https://github.com/rizsotto/Bear) for more information.

## VIM Plugins (vim-rtags and neocomplete)

vim-rtags and neocomplete are configured in the vimrc file.  The plugins are
managed by Vundle and can be installed by executing :PluginInstall.

