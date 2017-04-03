#!/bin/bash
# .bash_profile

# Get the aliases and functions
[ -f "${HOME}/.bashrc" ] && source "${HOME}/.bashrc"

# User specific environment and startup programs
for p in "${HOME}/.local/bin" "${HOME}/bin" "${HOME}/.cabal/bin" "/opt/tbricks/admin/bin"; do
  case ":${PATH}:" in
    *:"${p}":*) ;;
    *) [ -d "${p}" ] && PATH=${PATH}:${p} ;;
  esac
done
export PATH

