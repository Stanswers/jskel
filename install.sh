#!/bin/bash

copy() {
  local date=$(date +'%C%y%m%d_%H%M%S')
  local mode=0644
  [ $# -eq 2 ] && mode="${2}"
  printf "Installing: %s\n" "${HOME}/.${1}"
  install -m "${mode}" --backup --compare --suffix="~${date}" "${1}" "${HOME}/.${1}"
}

clean() {
  printf "Cleaning: %s\n" "${HOME}/.${1}"~*_*
  rm "${HOME}/.${1}"~*_* &> /dev/null || true
}

mkd() {
  printf "Creating directory: %s\n" "${HOME}/.${1}"
  if mkdir -p "${HOME}/.${1}" &> /dev/null && [ $# -eq 2 ]; then
    printf "Setting permission [%s]: %s\n" "${2}" "${HOME}/.${1}"
    chmod "${2}" "${HOME}/.${1}"
  fi
}

copyFiles() {
  for f in "${@}"; do
    copy "${f}"
  done
}

cleanFiles() {
  for f in "${@}"; do
    clean "${f}"
  done
}

gitInstall() {
  copyFiles "gitconfig" "gitk" "gitignore_global"
}

shellInstall() {
  copyFiles "bashrc" "bash_aliases" "bash_logout" "bash_profile" "inputrc" "sshrc"
  wget -q -nc \
    "https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark" \
    -O "${HOME}/.dircolors" || echo -n
  wget -q -nc \
    "https://raw.githubusercontent.com/juven/maven-bash-completion/master/bash_completion.bash" \
    -O "${HOME}/.bash_completion.maven" || echo -n
}

vimInstall() {
  mkd "vim/doc"
  copyFiles "vimrc" "vim/doc/hell.txt" "vim/doc/tags"
  if ! [ -d "${HOME}/.vim/bundle/Vundle.vim" ]; then
    mkdir -p "${HOME}/.vim/bundle" &> /dev/null;
    git clone https://github.com/VundleVim/Vundle.vim.git "${HOME}/.vim/bundle/Vundle.vim"
  fi
  if command -v vim &> /dev/null; then
    vim +PluginInstall +qall
  fi;
}

x11Install() {
  copyFiles "inputrc" "Xdefaults"
  # This is a trick to copy the existing file (the same as the others
  # before deleting the 2nd Xdefaults and making it a symlink
  if ! [ -L "${HOME}/.Xresources" ]; then
    install -m 0644 --backup --suffix="~$(DATE)" Xresources "${HOME}/.Xdefaults"
    rm "${HOME}/.Xresources"
    ln -s "${HOME}/.Xdefaults" "${HOME}/.Xresources"
  fi

  if command -v gsettings &> /dev/null; then
    gsettings set org.gnome.desktop.wm.preferences audible-bell false
  fi

  if command -v urxvtd &> /dev/null; then
    if command -v systemctl &> /dev/null; then
      mkdir -p "${HOME}/.config/systemd/user" &> /dev/null
      copyFiles "config/systemd/user/urxvtd.socket" \
        "config/systemd/user/urxvtd.service"
      if ! systemctl --user is-enabled urxvtd.service &> /dev/null; then
        systemctl --user enable urxvtd.service
      fi
      if ! systemctl --user is-active urxvtd.service &> /dev/null; then
        systemctl --user start urxvtd.service
      fi
    fi
  fi
}

cleanupInstall() {
  cleanFiles "gitconfig" "gitk" "gitignore_global" "bashrc" "bash_aliases" \
    "bash_logout" "bash_profile" "inputrc" "sshrc" "vimrc" \
    "vim/doc/hell.txt" "vim/doc/tags" "config/systemd/user/urxvtd.socket" \
    "config/systemd/user/urxvtd.service"
}

main() {
  [[ "${@}" =~ .*(-h +|--help).* ]] && echo HELP GOES HERE && return 0
  [ ${#} -eq 0 ] && gitInstall && shellInstall && vimInstall && x11Install
  while [ ${#} -ne 0 ]; do
    case "${1}" in
      git) gitInstall; shift;;
      shell) shellInstall; shift;;
      vim) vimInstall; shift;;
      x11) x11Install; shift;;
      clean) cleanupInstall; shift;;
      --) shift;;
      --* | -*) printf "WARN: Unknown option (ignored): %s\n"  "${1}" 1>&2; shift;;
      *) printf "WARN: Unknown target (ignored): %s\n"  "${1}" 1>&2; shift;;
    esac
  done
}

main "${@}"
