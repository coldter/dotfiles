#!/bin/bash

set +x
# Determine the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source $SCRIPT_DIR/global_fn.sh
if [ $? -ne 0 ]; then
  echo "Error: unable to source global_fn.sh, please execute from $(dirname $(realpath $0))..."
  exit 1
fi

cat $SCRIPT_DIR/gtk_themes.lst | while read lst; do

  fnt=$(echo $lst | awk -F '|' '{print $1}')
  tgt=$(echo $lst | awk -F '|' '{print $2}')
  tgt=$(eval "echo $tgt")

  if [ ! -d "${tgt}" ]; then
    mkdir -p ${tgt} || echo "creating the directory as root instead..." && sudo mkdir -p ${tgt}
    echo "${tgt} directory created..."
  fi

  echo "copying ${fnt}.tar.gz --> ${tgt}..."
  sudo tar -xzf ${CloneDir}/assets/${fnt}.tar.gz -C ${tgt}/
  echo "uncompressing ${fnt}.tar.gz --> ${tgt}..."

done

echo "rebuilding font cache..."
fc-cache -f
