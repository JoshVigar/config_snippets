#!/usr/bin/env bash

# List aliases and functions contained in matching files.                       
eh() {
  local term=$1
  local match=false

  for FILE in `find $HOME/.sb/dev-cli/lib/aliases_and_functions/eh/ -type f`; do
    if [[ "$FILE" == *"$1"* ]]; then
      match=true
      # Read the file processing ANSI colors, preserving whitspace with sed
      echo -ne $(cat $FILE | sed  's/$/\\n/' | sed 's/ /\\a /g')
    fi                                                                          
  done
  if [ "$match" == false ]; then
    echo "No alias file found matching $1. Must be exact match."
  fi
}

sb_eh_files() {
 echo ''
}
