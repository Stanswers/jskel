#!/bin/bash
# .bashrc

set -o vi

# Source global definitions
[ -f /etc/bashrc ] && source /etc/bashrc
[ -f /etc/bash.bashrc ] && source /etc/bash.bashrc
[ -f "${HOME}/.bashrc.itiviti" ] && source "${HOME}/.bashrc.itiviti"
[ -z "$PS1" ] && return

for p in "${HOME}/.local/bin" "${HOME}/bin" "${HOME}/.cabal/bin" /usr/local/usr/bin; do
  case ":${PATH}:" in
    *:"${p}":*) ;;
    *) [ -d "${p}" ] && PATH=${PATH}:${p} ;;
  esac
done
export PATH

if command -v gcc &> /dev/null; then
  GNUCC_VER="$(gcc -v &> >(grep -oP 'gcc version \K([0-9]+.[0-9]+.[0-9]+)'))"
  export GNUCC_VER
fi

case "$(uname -s)" in
  CYGWIN*|MINGW32*|MSYS*)
    # let windows set the JAVA_HOME and M2_REPO environment variables
    ;;
  *)
    if command -v mvn &> /dev/null && [ -d "${HOME}/.m2/repository" ]; then
      export M2_REPO=${HOME}/.m2/repository
    fi
    if command -v javac &> /dev/null; then
      JAVA_HOME=$(readlink -f "$(which javac)" | sed "s:/bin/javac::")
      export JAVA_HOME
    fi
    if grep -q Microsoft /proc/version &> /dev/null; then
      umask 022
    fi
    if [ -f /etc/debian_version ]; then
      if ! shopt -oq posix; then
        if [ -f /usr/share/bash-completion/bash_completion ]; then
          source /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
          source /etc/bash_completion
        fi
      fi
    fi
    ;;
esac

[ -d "${HOME}/go" ] && export GOPATH="${HOME}/go"
export LESS="-RXQ"
export PAGER=/usr/bin/less
export SYSTEMD_PAGER=/usr/bin/less
if [ -n "${DISPLAY}" ] && command -v vimx &> /dev/null; then
  export EDITOR=/usr/bin/vimx
else
  export EDITOR=/usr/bin/vim
fi
export SVN_MERGE='vim -d'
export PROMPT_COMMAND='last=$?;history -a;if git rev-parse &> /dev/null; then repo="$(git rev-parse --abbrev-ref HEAD) "; else repo=""; fi;printf "\e]0;${HOSTNAME} ${repo}$(basename "${PWD}"):${last}\007";unset last; unset repo;'
export PS1='[\u@\h:\w] '
export FIGNORE='.svn:.git:.pyc'
export HISTFILESIZE=10000
export HISTSIZE=10000
export GTEST_COLOR=yes
# Not everyone does dircolors in the /etc bash scripts so lets just do it here
[ -f "${HOME}/.dircolors" ] && eval "$(dircolors -b "${HOME}/.dircolors")"
# Source completeion scripts
command -v mvn &> /dev/null && [ -f "${HOME}/.bash_completion.maven" ] && source "${HOME}/.bash_completion.maven"
# Source aliases
[ -f "${HOME}/.bash_aliases" ] && source "${HOME}/.bash_aliases"
# append to the history file, don't overwrite it
shopt -s histappend
# Combine multiline commands into one in history
shopt -s cmdhist
# enable XON/XOFF flow control
stty -ixon

# added by travis gem
[ -f "${HOME}/.travis/travis.sh" ] && source "${HOME}/.travis/travis.sh" || true

