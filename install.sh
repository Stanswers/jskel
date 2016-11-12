#!/bin/bash

copy() {
  local date=$(date +'%C%y%m%d_%H%M%S')
  local mode=0644
  local dst="${HOME}/.${1}"
  [ $# -eq 2 ] && mode="${2}"
  printf "   %-25s %-51s\n" "$(basename ${1})" "${dst}"
  install -m "${mode}" --backup --compare --suffix="~${date}" "${1}" "${dst}"
}

clean() {
  local files=("${HOME}/.${1}"~*_*)
  for file in ${files[@]}; do
    if [ -f ${file} ]; then
      printf "   %s\n" ${file}
      rm ${file}
    fi
  done
}

mkd() {
  local dir="${HOME}/.${1}"
  if ! [ -d "${dir}" ]; then
    printf "Creating directory: %s\n" "${dir}"
    if mkdir -p "${dir}" &> /dev/null && [ $# -eq 2 ]; then
      printf "Setting permission [%s]: %s\n" "${2}" "${dir}"
      chmod "${2}" "${dir}"
    fi
  fi
}

diffFiles() {
  printf "Diff files:\n"
  for f in "${@}"; do
    if [ -e "${HOME}/.${f}" ] && ! diff "${f}" "${HOME}/.${f}" &> /dev/null; then
      printf "\033[0;31m   %s\033[0m\n" "${f}"
    fi
  done
}

vimdiffFiles() {
  local files=()
  for f in "${@}"; do
    if [ -e "${HOME}/.${f}" ] && ! diff "${f}" "${HOME}/.${f}" &> /dev/null; then
      files+=("${f}")
    fi
  done
  local index=0
  for f in "${files[@]}"; do
    ((index++))
    printf "\nViewing (%d/%d): '%s'\n" ${index} ${#files[@]} "${f}"
    read -p "Launch 'vimdiff' [Y/n]: " -e answer
    answer=${answer:-"Y"}
    case ${answer} in
      [Yy]*) vimdiff "${f}" "${HOME}/.${f}";;
    esac
  done
}

copyFiles() {
  printf "Installing:\n"
  for f in "${@}"; do
    copy "${f}"
  done
}

cleanFiles() {
  printf "Removing:\n"
  for f in "${@}"; do
    clean "${f}"
  done
}

gitInstall() {
  copyFiles "gitconfig" "gitk" "gitignore_global"
}

shellInstall() {
  copyFiles "bashrc" "bash_aliases" "bash_logout" "bash_profile" "inputrc" \
    "sshrc"
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
    mkd -p "vim/bundle"
    git clone "https://github.com/VundleVim/Vundle.vim.git" \
      "${HOME}/.vim/bundle/Vundle.vim"
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
    local date=$(date +'%C%y%m%d_%H%M%S')
    install -m 0644 --backup --suffix="~${date}" Xresources "${HOME}/.Xdefaults"
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

printHelp() {
  local scriptName=$(basename "${0}")
cat <<END
Usage:  ${scriptName} [options] [git] [shell] [vim] [x11]
        ${scriptName} [options] [diff] [clean]
Install jskel git, shell, vim, and x11 files.
Clean backed up versions of jskel git, shell, vim, and x11 files.

Options:
  -h, --help                Prints this help menu

END
}

main() {
  local -A targets actions empty files
  files=([git]="gitconfig gitk gitignore_global" \
         [shell]="bashrc bash_aliases bash_logout bash_profile inputrc sshrc" \
         [vim]="vimrc vim/doc/hell.txt vim/doc/tags" \
         [x11]="config/systemd/user/urxvtd.socket config/systemd/user/urxvtd.service" )
  targets=([git]="gitInstall" [shell]="shellInstall" \
           [vim]="vimInstall" [x11]="x11Install")
  [ ${#} -eq 0 ] && actions=${targets[@]}
  while [ ${#} -ne 0 ]; do
    case "${1}" in
      git) actions[git]=${targets[git]}; shift;;
      shell) actions[shell]=${targets[shell]}; shift;;
      vim) actions[vim]=${targets[vim]}; shift;;
      x11) actions[x11]=${targets[x11]}; shift;;
      clean) actions=${empty[@]}; actions[clean]="cleanFiles"; break;;
      diff | d) diffFiles ${files[@]}; return 0;;
      vimdiff | vd) vimdiffFiles ${files[@]}; return 0;;
      -h) printHelp; return 0;;
      --help) printHelp; return 0;;
      --* | -*)
        printf "WARN: Unknown option (ignored): %s\n"  "${1}" 1>&2; shift;;
      *)
        printf "WARN: Unknown target (ignored): %s\n"  "${1}" 1>&2; shift;;
    esac
  done
  for action in ${actions[@]}; do
    ${action} ${files[${action}]}
  done
}

main "${@}"
