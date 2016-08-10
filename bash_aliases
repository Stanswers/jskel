#!/bin/bash
# .bash_aliases

man() {
  env LESS_TERMCAP_mb="$(printf "\e[1;31m")" \
      LESS_TERMCAP_md="$(printf "\e[1;31m")" \
      LESS_TERMCAP_me="$(printf "\e[0m")" \
      LESS_TERMCAP_se="$(printf "\e[0m")" \
      LESS_TERMCAP_so="$(printf "\e[1;44;33m")" \
      LESS_TERMCAP_ue="$(printf "\e[0m")" \
      LESS_TERMCAP_us="$(printf "\e[1;32m")" \
      man "$@"
}

sshenv() {
  local sshrc="$(cat ${HOME}/.sshrc)"
  # Note that, unescaped "echo \"${SSHRC}\", this expands on the client side.
  # This behavior is desired
  ssh -t "${1}@${2}" "${3}" "${4}" "echo \"${sshrc}\" > /tmp/.sshrc; bash --rcfile /tmp/.sshrc; \rm /tmp/.sshrc &> /dev/null"
}

installSshKey() {
  cat ~/.ssh/id_rsa.pub | ssh "${1}" 'cat >> ${HOME}/.ssh/authorized_keys; chmod 0600 ${HOME}/.ssh/authorized_keys'
}

installJaxpProperties() {
  if [ -d $JAVA_HOME/jre/lib ] && [ ! -f $JAVA_HOME/jre/lib/jaxp.properties ]; then
    sudo sh -c "echo 'javax.xml.accessExternalSchema = all' > $JAVA_HOME/jre/lib/jaxp.properties"
  fi
}

sunnyInPhlly() {
  if curl -s --connect-timeout 1 'http://rss.accuweather.com/rss/liveweather_rss.asp?metric=0&locCode=19106' | xmlstarlet sel -t -v "rss/channel/item/title[starts-with(., 'Currently') and contains(., 'Sun')]" &> /dev/null; then
    echo "It is sunny in philadelphia!"
  else
    echo "It is NOT sunny in philadelphia!"
  fi
}

up() {
  local search="$( [[ "${1}" ]] && echo "${1}" || echo "." )"
  local dir="$( dirname "$( pwd )" )"
  while [ "${dir}" != "/" ]; do
    if [ -d "${dir}/${search}" ]; then
      cd "${dir}/${search}"
      return 0
    fi
    dir="$( dirname "${dir}" )"
  done
  cd "/${search}" 2>/dev/null || echo "up: ${search}: no such directory" >&2
}

_up() {
  local cur base
  if [[ "$(type -t _init_completion)" == "function" ]]; then
    _init_completion || return
  else
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
  fi

  if command -v comopt >/dev/null 2>&1; then
    comopt -o filenames
  fi

  # error on leading /, ./ or ../
  local regex="?(.)?(.)/*"
  if [[ "${cur}" == ${regex} ]]; then
    return 1
  fi
  local base="$(pwd)/f"
  if [ -n "${cur}" ]; then
    base="$(dirname "${base}")"
  fi
  while [ "${base}" != "/" ]; do
    base="$(dirname "${base}")"
    while IFS=$'\n' read -r dir; do
      # escape and remove leading $base/ from dir
      COMPREPLY+=( "$(printf '%q' "${dir:$((${#base}+1))}")/" )
    done < <( compgen -d -- "${base}/${cur}" )
  done
}
complete -o nospace -F _up up

cdpath() {
  cd "${1}/${2}"
}

_cdpath() {
  local cur path len dirs
  cur="${COMP_WORDS[COMP_CWORD]}"
  path="${1}"
  len=$((${#path} + 1))
  for d in "${path}/${cur}"*; do
    if [ -d "${d}" ] && [[ "${d}" != */target* ]]; then
      dirs+="${d:$len}/ "
    fi
  done
  COMPREPLY=( $(compgen -W "${dirs}" "${cur}") )
}

if [ -d ${HOME}/workspace/maven-projects/gateways ]; then
  _gw() {
    _cdpath "${HOME}/workspace/maven-projects/gateways"
  }
  complete -o nospace -F _gw gw
  alias gw='cdpath ${HOME}/workspace/maven-projects/gateways'
fi

if [ -d ${HOME}/workspace/maven-projects ]; then
  _mp() {
    _cdpath "${HOME}/workspace/maven-projects"
  }
  complete -o nospace -F _mp mp
  alias mp='cdpath ${HOME}/workspace/maven-projects'
fi

if [ -d ${HOME}/workspace/tb ]; then
  _tb() {
    _cdpath "${HOME}/workspace/tb"
  }
  complete -o nospace -F _tb tb
  alias tb='cdpath ${HOME}/workspace/tb'
fi

if [ -d ${HOME}/workspace ]; then
  _ws() {
    _cdpath "${HOME}/workspace"
  }
  complete -o nospace -F _ws ws
  alias ws='cdpath ${HOME}/workspace'
fi

alias du='du -h'
alias df='df -h'
alias ls='ls -hl --color=auto'
alias ll='ls -F'
alias la='ls -AF'
alias l.='ls -d .*'
alias rmhtml='sed '\''s/<[^>]\+>/ /g'\'' '
alias rtfm='man '
alias pss='ps -ef | grep --color -v grep | sed '\''s/ -cp [-./_:0-9A-Za-z]*//g'\''  | grep --color -i '
alias grep='grep --color=auto'
alias colors='for x in {0..8} ;do for i in $(seq 30 37); do for a in $(seq 40 47);do  echo -ne "\e[${x};${i};${a}""m\\\e[${x};${i};${a}""m\e[0;37;40m \e[0m";done;echo ;done;done;echo ""; echo "Use CTRL+q CTRL+[ in place of \\e in emacs"'
alias colors2='for i in {1..0}; do for j in {0..255}; do printf "\033[${i};38;5;${j}m %-3s\033[0m" $j; [ $(( $(($j + 1)) % 16 )) -eq 0 ] && echo "";done; echo ""; done'
alias httpserv='python -m SimpleHTTPServer'
alias top='htop'
alias yum='sudo dnf '
alias dnf='sudo dnf '
alias xo='xdg-open '
alias mi='mvn clean install -DskipTests -Dmaven.test.skip=true -Djavax.xml.accessExternalSchema=all -Dmaven.javadoc.skip=true'
alias mit='mvn clean install -Djavax.xml.accessExternalSchema=all -Dmaven.javadoc.skip=true'
alias me='mvn eclipse:eclipse'
alias mime='mvn clean install eclipse:eclipse -DskipTests'
alias cobertura='mvn clean cobertura:cobertura'
alias gwdb='${HOME}/scripts/gwdb.sh'
alias keyboard='sudo sh -c "echo 2 > /sys/module/hid_apple/parameters/fnmode"'
alias rdp='rdesktop-vrdp -g 1920x1165 -u "orc\justinh" ts1.chicago.orcsoftware.com'

