#!/opt/homebrew/bin/bash

cd $(dirname ${BASH_SOURCE:-$0})

echo -n "-------- "; date

if [ ! -e stack ]; then
  touch stack
fi

readarray -t urls < stack
for i in "${!urls[@]}"; do
  echo "Downloading: ${urls[$i]}"
  if ~/Music/WWW/add.sh "${urls[$i]}"; then
    unset -v 'urls[$i]'
  fi
  echo
done
printf "%s\n" "${urls[@]}" > stack
