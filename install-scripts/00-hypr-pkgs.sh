#!/bin/bash

# https://github.com/JaKooLit

# edit your packages desired here.
# WARNING! If you remove packages here, dotfiles may not work properly.
# and also, ensure that packages are present in AUR and official Arch Repo

# add packages wanted here
Extra=(
  firefox
  neofetch
  visual-studio-code-bin
  eza
  pokemon-colorscripts-git
  micro
  neovim
  htop
  zip
  unzip
)

hypr_package=(
  pipewire
  pipewire-alsa
  pipewire-audio
  pipewire-jack
  pipewire-pulse
  gst-plugin-pipewire
  wireplumber
  networkmanager
  network-manager-applet
  brightnessctl
  qt5-wayland
  qt6-wayland
  qt5-quickcontrols
  qt5-quickcontrols2
  qt5-graphicaleffects
  dunst
  rofi-lbonn-wayland-git
  waybar
  swww
  swaylock-effects
  # python-pyamdgpuinfo
  jq
  wlogout
  grim
  slurp
  swappy
  cliphist
  polkit-kde-agent
  pacman-contrib
  imagemagick
  qt5-imageformats
  pavucontrol
  pamixer
  kvantum
  qt5ct
  kitty
  # alacritty
  wget
  gvfs
  gvfs-mtp
  xdg-user-dirs
  xfce4-settings
  # wofi
  # wl-clipboard
  # swayidle
)

# the following packages can be deleted. however, dotfiles may not work properly
hypr_package_2=(
  btop
  cava
  ffmpegthumbs
  gnome-system-monitor
  mousepad
  nvtop
  nwg-look-bin
  # swaybg
  viewnior
  vim
  wlsunset
  polkit-gnome
  xdg-utils
  ntfs-3g
)

fonts=(
  adobe-source-code-pro-fonts
  noto-fonts-emoji
  otf-font-awesome
  otf-font-awesome-4
  ttf-droid
  ttf-fantasque-sans-mono
  ttf-jetbrains-mono
  ttf-jetbrains-mono-nerd
)

############## WARNING DO NOT EDIT BEYOND THIS LINE if you dont know what you are doing! ######################################

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Set the name of the log file to include the current date and time
LOG="install-$(date +%d-%H%M%S)_hypr-pkgs.log"

ISAUR=$(command -v yay || command -v paru)

# Set the script to exit on error
set -e

# Function for installing packages
install_package() {
  # Checking if package is already installed
  if $ISAUR -Q "$1" &>>/dev/null; then
    echo -e "${OK} $1 is already installed. Skipping..."
  else
    # Package not installed
    echo -e "${NOTE} Installing $1 ..."
    $ISAUR -S --noconfirm "$1" 2>&1 | tee -a "$LOG"
    # Making sure package is installed
    if $ISAUR -Q "$1" &>>/dev/null; then
      echo -e "\e[1A\e[K${OK} $1 was installed."
    else
      # Something is missing, exiting to review log
      echo -e "\e[1A\e[K${ERROR} $1 failed to install :( , please check the install.log. You may need to install manually! Sorry I have tried :("
      exit 1
    fi
  fi
}

# Installation of main components
printf "\n%s - Installing hyprland packages.... \n" "${NOTE}"

for PKG1 in "${hypr_package[@]}" "${hypr_package_2[@]}" "${fonts[@]}" "${Extra[@]}"; do
  install_package "$PKG1" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
    echo -e "\e[1A\e[K${ERROR} - $PKG1 install had failed, please check the install.log"
    exit 1
  fi
done

clear
