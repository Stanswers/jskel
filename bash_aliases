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
      man "${@}"
}

installSshKey() {
  cat ~/.ssh/id_rsa.pub | ssh "${1}" 'cat >> ${HOME}/.ssh/authorized_keys; chmod 0600 ${HOME}/.ssh/authorized_keys'
}

installJaxpProperties() {
  if [ -d "${JAVA_HOME}/jre/lib" ] && [ ! -f "${JAVA_HOME}/jre/lib/jaxp.properties" ]; then
    sudo sh -c "echo 'javax.xml.accessExternalSchema = all' > ${JAVA_HOME}/jre/lib/jaxp.properties"
  fi
}

lsop() {
    local args=("-nP")
    case "${1}" in
        [0-9]*) args+=("-iTCP:${1}");;
        -l) args+=("-sTCP:LISTEN" "-iTCP:${2}");;
        -u) args+=("-iUDP:${2}");;
        *)
            echo "Usage: ${FUNCNAME[0]} [-i -l] port" >&2
            return 1
    esac
    sudo lsof "${args[@]}"
}

up() {
  local search dir
  search="$( [[ "${1}" ]] && echo "${1}" || echo "." )"
  dir="$( dirname "$( pwd )" )"
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

  if command -v comopt &> /dev/null; then
    comopt -o filenames
  fi

  # error on leading /, ./ or ../
  local regex="?(.)?(.)/*"
  if [[ ${regex} == "${cur}" ]]; then
    return 1
  fi
  base="$(pwd)/f"
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

_makecdpath() {
  local -A paths=( [ws]="${HOME}/workspace" \
                   [src]="${HOME}/src" \
                   [gw]="${HOME}/workspace/maven-projects/gateways" \
                   [mp]="${HOME}/workspace/maven-projects" \
                   [dev]="${HOME}/src/tbdev" \
                   [rel]="${HOME}/src/tb" )
  for p in "${!paths[@]}"; do
    if [ -d "${paths[${p}]}" ]; then
      eval "_${p}() { _cdpath ${paths[${p}]}; }"
      complete -o nospace -F _${p} ${p}
      alias ${p}="cdpath ${paths[${p}]}"
    fi
  done
}
_makecdpath
unset -f _makecdpath

if [ -f "${HOME}/.sshrc" ]; then
  sshenv() {
    local sshrc
    sshrc="$(cat "${HOME}/.sshrc")"
    # Note that, unescaped "echo \"${SSHRC}\", this expands on the client side.
    # This behavior is desired
    ssh -t "${1}@${2}" "${3}" "${4}" "echo \"${sshrc}\" > /tmp/.sshrc; bash --rcfile /tmp/.sshrc; \rm /tmp/.sshrc &> /dev/null"
  }
fi

if command -v curl &> /dev/null && command -v xmlstarlet &> /dev/null; then
  sunnyInPhlly() {
    if curl -s --connect-timeout 1 'http://rss.accuweather.com/rss/liveweather_rss.asp?metric=0&locCode=19106' | \
      xmlstarlet sel -t -v "rss/channel/item/title[starts-with(., 'Currently') and contains(., 'Sun')]" &> /dev/null; then
      echo "It is sunny in philadelphia!"
    else
      echo "It is NOT sunny in philadelphia!"
    fi
  }
fi

if [ -n "${DISPLAY}" ]; then
  if command -v vimx &> /dev/null; then
    alias vi='vimx'
    alias vim='vimx'
  fi
  if command -v notify-send &> /dev/null; then
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo face-laugh || echo face-angry)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\{0,2\}\s*alert$//'\'')"'
    #alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\{0,2\}\s*alert$//'\'')"'
  fi
fi
if command -v tbcomponent &> /dev/null; then
  alias lsgw='tbcomponent ls | grep -vP "^ +${TBRICKS_SYSTEM%_sys}.*"'
  alias lscore='tbcomponent ls ${TBRICKS_SYSTEM%_sys}\*'
fi
if command -v htop &> /dev/null; then
  alias top='htop'
fi
if command -v dnf &> /dev/null; then
  alias yum='sudo dnf '
  alias dnf='sudo dnf '
fi
if command -v apt-get &> /dev/null; then
  alias apt-get='sudo apt-get '
fi
if command -v xdg-open &> /dev/null; then
  alias xo='xdg-open '
fi
if command -v mvn &> /dev/null; then
  alias mi='mvn install -DskipTests -Dmaven.test.skip=true -Djavax.xml.accessExternalSchema=all'
  alias me='mvn eclipse:eclipse -Djavax.xml.accessExternalSchema=all'
  alias mie='mvn install eclipse:eclipse -DskipTests -Dmaven.test.skip=true -Djavax.xml.accessExternalSchema=all'
  alias mit='mvn install -Djavax.xml.accessExternalSchema=all'
  alias mc="mvn clean"
  alias mcec="mvn clean eclipse:clean"
  alias cobertura='mvn cobertura:cobertura'
fi
if command -v rdesktop-vrdp &> /dev/null; then
  alias rdp='rdesktop-vrdp -g 1920x1165 -u "orc\justinh" ts1.chicago.orcsoftware.com'
fi
if command -v python &> /dev/null; then
  alias httpserv='python -m SimpleHTTPServer'
fi
if command -v killall &> /dev/null; then
  alias killall='killall -u ${USER}'
fi
alias du='du -h'
alias df='df -h'
alias ls='ls -hl --color=auto'
alias ll='ls -F'
alias la='ls -AF'
alias l.='ls -d .*'
alias grep='grep --color=auto'
alias rtfm='man '
alias rmhtml='sed '\''s/<[^>]\+>/ /g'\'' '
alias pss='ps -ef | grep --color -v grep | sed '\''s/ -cp [-./_:0-9A-Za-z]*//g'\''  | grep --color -i '
alias colors='for x in {0..8} ;do for i in $(seq 30 37); do for a in $(seq 40 47);do  echo -ne "\e[${x};${i};${a}""m\\\e[${x};${i};${a}""m\e[0;37;40m \e[0m";done;echo ;done;done;echo ""; echo "Use CTRL+q CTRL+[ in place of \\e in emacs"'
alias colors2='for i in {1..0}; do for j in {0..255}; do printf "\033[${i};38;5;${j}m %-3s\033[0m" $j; [ $(( $(($j + 1)) % 16 )) -eq 0 ] && echo "";done; echo ""; done'
alias keyboard='sudo sh -c "echo 2 > /sys/module/hid_apple/parameters/fnmode"'

