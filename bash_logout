#!/bin/bash
# .bash_logout

# when leaving the console clear the screen to increase privacy
if [ "${SHLVL}" = 1 ] && command -v clear &> /dev/null; then
  command clear
fi
