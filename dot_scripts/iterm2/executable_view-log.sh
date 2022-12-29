#!/bin/bash
cd ~/.cache/iterm2
PATH="/opt/homebrew/bin:$PATH"
SHOWLOGFILE="$(fd . | cut -c 3-17 - | fzf --tac --reverse)*"
cat ${SHOWLOGFILE:-20220811_161657*}
tail -n 1 -f ${SHOWLOGFILE:-20220811_161657*}
