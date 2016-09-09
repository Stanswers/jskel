#!/bin/bash
# .bash_profile

# Get the aliases and functions
[ -f ${HOME}/.bashrc ] && source ${HOME}/.bashrc

# User specific environment and startup programs
for p in "${HOME}/.local/bin" "${HOME}/bin" "${HOME}/scripts" \
         "${HOME}/.cabal/bin"; do
  [ -d ${p} ] && PATH=${PATH}:${p}
done
export PATH

[ -f ${HOME}/.bash_profile.tbricks ] && source ${HOME}/.bash_profile.tbricks

