#!/bin/bash

IFS=$'\n'

sortpath=$1
declare -a dirarr=( `find $sortpath -type d` )
declare -a dupes
declare -a output

for directory in "${dirarr[@]}"; do
  dupes=( `find $directory -maxdepth 1 -type f| tr '[:upper:]' '[:lower:]'| sed -n 's/.*\.\(s[0-9][0-9]e[0-9][0-9]\)\..*/\1/p'|sort|uniq -d` )
  for files in "${dupes[@]}"; do
    output=( $(ls -d -1 $directory/*.* |grep -i $files) )

    echo "Duplicates found:"
    echo "$(ls $directory)"

    for file in "${output[@]}"; do
      echo "$(ls -alh $file)"
    done

    for file in "${output[@]}"; do
      read -p "Do you wish to remove $file? [y/n]: " response
      if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
        rm -f "$file"
      fi
    done

  done
done
