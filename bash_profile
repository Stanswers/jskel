#!/bin/bash
# .bash_profile

# Get the aliases and functions
[ -f ${HOME}/.bashrc ] && source ${HOME}/.bashrc

# User specific environment and startup programs
for p in "${HOME}/.local/bin" "${HOME}/bin" "${HOME}/scripts" "${HOME}/.cabal/bin" \
         "${HOME}/workspace/tb/toolchain/x86_64-unknown-linux/bin" \
         "${HOME}/workspace/tb/build.x86_64-unknown-linux/bin"; do
  [ -d ${p} ] && PATH=${PATH}:${p}
done
export PATH

