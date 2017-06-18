#!/bin/bash
# .bashrc

# Source global definitions
[ -f /etc/bashrc ] && source /etc/bashrc
[ -f /etc/bash.bashrc ] && source /etc/bash.bashrc
[ -z "$PS1" ] && return

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

append_to_path() {
  for p in "${@}"; do
    case ":${PATH}:" in
      *:"${p}":*) ;;
      *) [ -d "${p}" ] && PATH=${PATH}:${p} ;;
    esac
  done
  export PATH
}

remove_from_path() {
  for p in "${@}"; do
    PATH=:${PATH}:
    PATH=${PATH//:${p}:/:}
    PATH=${PATH#:}
    PATH=${PATH%:}
    done
  export PATH
}

if [ -d "${HOME}/src/tb" ] || [ -s "${HOME}/src/tbdev" ]; then
  jhdevsys() {
    export TBRICKS_SYSTEM=jh_dev_sys
    export SYSTEM=jh_dev_sys
    remove_from_path "${TBRICKS_TRUNK}/toolchain/x86_64-unknown-linux/bin" \
                     "${TBRICKS_TRUNK}/build.x86_64-unknown-linux/bin"
    export TBRICKS_TRUNK="${HOME}/src/tbdev"
    append_to_path "${TBRICKS_TRUNK}/toolchain/x86_64-unknown-linux/bin" \
                   "${TBRICKS_TRUNK}/build.x86_64-unknown-linux/bin"
  }

  jhsys() {
    export TBRICKS_SYSTEM=jh_sys
    export SYSTEM=jh_sys
    remove_from_path "${TBRICKS_TRUNK}/toolchain/x86_64-unknown-linux/bin" \
                     "${TBRICKS_TRUNK}/build.x86_64-unknown-linux/bin"
    export TBRICKS_TRUNK="${HOME}/src/tb"
    append_to_path "${TBRICKS_TRUNK}/toolchain/x86_64-unknown-linux/bin" \
                   "${TBRICKS_TRUNK}/build.x86_64-unknown-linux/bin"
  }
  jhdevsys
fi
if [ -d /opt/tbricks ]; then
  export TBRICKS_ADMIN_CENTER=jh_admin_sys
  export TBRICKS_USER=justinh
  export TBRICKS_TBLOG_SNAPSHOT_SIZE=60000
fi
[ -d /etc/tbricks ] && export TBRICKS_ETC=/etc/tbricks

[ -d "${HOME}/go" ] && export GOPATH="${HOME}/go"
export PAGER=/usr/bin/less
export SYSTEMD_PAGER=/usr/bin/less
if [ -n "${DISPLAY}" ] && command -v vimx &> /dev/null; then
  export EDITOR=/usr/bin/vimx
else
  export EDITOR=/usr/bin/vim
fi
export SVN_MERGE='vim -d'
export PROMPT_COMMAND='last=$?;history -a;printf "\e]0;${HOSTNAME} $(date +%H:%M:%S) ${PWD}:${last}\007"'
export PS1='[\u@\h:\w] '
export FIGNORE='.svn:.git:.pyc'
export HISTFILESIZE=10000
export HISTSIZE=10000
# Not everyone does dircolors in the /etc bash scripts so lets just do it here
[ -f "${HOME}/.dircolors" ] && eval "$(dircolors -b "${HOME}/.dircolors")"
# Source completeion scripts
command -v mvn &> /dev/null && [ -f "${HOME}/.bash_completion.maven" ] && source "${HOME}/.bash_completion.maven"
[ -f /opt/tbricks/admin/etc/bash/.tbricks_completion.bash ] && source /opt/tbricks/admin/etc/bash/.tbricks_completion.bash
# Source aliases
[ -f "${HOME}/.bash_aliases" ] && source "${HOME}/.bash_aliases"
# append to the history file, don't overwrite it
shopt -s histappend
# Combine multiline commands into one in history
shopt -s cmdhist
# enable XON/XOFF flow control
stty -ixon

# added by travis gem
[ -f "${HOME}/.travis/travis.sh" ] && source "${HOME}/.travis/travis.sh"
true

