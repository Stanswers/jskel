#!/bin/bash
# .bash_profile

append_to_path() {
  for p in $@; do
    [ -d ${p} ] && ! [[ $PATH =~ .*${p}.* ]] && PATH=${PATH}:${p}
  done
  export PATH
}
remove_from_path() {
  for p in $@; do
    PATH=$(echo -n $PATH | sed "s;:\?${p};;")
  done
  export PATH
}

# Get the aliases and functions
[ -f ${HOME}/.bashrc ] && source ${HOME}/.bashrc

# User specific environment and startup programs
append_to_path "${HOME}/.local/bin" "${HOME}/bin" "${HOME}/.cabal/bin" "/opt/tbricks/admin"

