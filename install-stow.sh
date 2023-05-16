#!/bin/bash

# check pacage mananger
DNF_CMD=$(which dnf)
APT_CMD=$(which apt-get)

if [[ ! -z $DNF_CMD ]]; then
    # install stow for fedora
    sudo $DNF_CMD install -y stow
elif [[ ! -z $APT_CMD ]]; then
    # install stow for debian
    sudo $APT_CMD install -y stow
else
    echo "No package manager found"
    exit 1
fi

stow -V
