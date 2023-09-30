#!/bin/bash

clear

# Welcome message
echo "$(tput setaf 6)Welcome to Arch-Hyprland Install Script!$(tput sgr0)"
echo
echo "$(tput setaf 3)NOTE: You will be required to answer some questions during the installation! $(tput sgr0)"
echo

read -p "$(tput setaf 6)Would you like to proceed? (y/n): $(tput sgr0)" proceed

if [ "$proceed" != "y" ]; then
    echo "Installation aborted."
    exit 1
fi

# Check if running as root. If root, script will exit
if [[ $EUID -eq 0 ]]; then
    echo "This script should not be executed as root! Exiting......."
    exit 1
fi

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 166)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Function to colorize prompts
colorize_prompt() {
    local color="$1"
    local message="$2"
    echo -n "${color}${message}$(tput sgr0)"
}

# Set the name of the log file to include the current date and time
LOG="install-$(date +%d-%H%M%S).log"

# Initialize variables to store user responses
aur_helper=""
bluetooth=""
dots=""
gtk_themes=""
nvidia=""
sddm=""
thunar=""
xdph=""

# Define the directory where your scripts are located
script_directory=install-scripts

# Function to ask a yes/no question and set the response in a variable
ask_yes_no() {
    while true; do
        read -p "$(colorize_prompt "$CAT" "$1 (y/n): ")" choice
        case "$choice" in
        [Yy]*)
            eval "$2='Y'"
            return 0
            ;;
        [Nn]*)
            eval "$2='N'"
            return 1
            ;;
        *) echo "Please answer with y or n." ;;
        esac
    done
}

# Function to ask a custom question with specific options and set the response in a variable
ask_custom_option() {
    local prompt="$1"
    local valid_options="$2"
    local response_var="$3"

    while true; do
        read -p "$(colorize_prompt "$CAT" "$prompt ($valid_options): ")" choice
        if [[ " $valid_options " == *" $choice "* ]]; then
            eval "$response_var='$choice'"
            return 0
        else
            echo "Please choose one of the provided options: $valid_options"
        fi
    done
}
# Function to execute a script if it exists and make it executable
execute_script() {
    local script="$1"
    local script_path="$script_directory/$script"
    if [ -f "$script_path" ]; then
        chmod +x "$script_path"
        if [ -x "$script_path" ]; then
            "$script_path"
        else
            echo "Failed to make script '$script' executable."
        fi
    else
        echo "Script '$script' not found in '$script_directory'."
    fi
}

# Collect user responses to all questions
printf "\n"
ask_custom_option "Select AUR helper" "paru or yay" aur_helper
printf "\n"
ask_yes_no "Do you have nvidia gpu?" nvidia
printf "\n"
ask_yes_no "Do you want to install GTK themes?" gtk_themes
printf "\n"
ask_yes_no "Do you want to configure Bluetooth?" bluetooth
printf "\n"
ask_yes_no "Do you want to install Thunar file manager?" thunar
printf "\n"
ask_yes_no "Do you want to install and configure SDDM?" sddm
printf "\n"
ask_yes_no "Do you want to install XDG-DESKTOP-PORTAL-HYPRLAND?" xdph
printf "\n"
# ask_yes_no "Do you want to link dotfiles?" dots
# printf "\n"
# Ensuring all in the scripts folder are made executable
chmod +x $script_directory/*

# Execute AUR helper script based on user choice
if [ "$aur_helper" == "paru" ]; then
    execute_script "paru.sh"
elif [ "$aur_helper" == "yay" ]; then
    execute_script "yay.sh"
else
    echo "No AUR helper selected."
    exit 1
fi

# Install hyprland packages
execute_script "00-hypr-pkgs.sh"

#  TODO: uncomment this when the script is ready
# if [ "$nvidia" == "Y" ]; then
#     execute_script "nvidia.sh"
# fi

# if [ "$nvidia" == "N" ]; then
#     execute_script "hyprland.sh"
# fi

# if [ "$gtk_themes" == "Y" ]; then
#     execute_script "gtk_themes.sh"
# fi

# if [ "$bluetooth" == "Y" ]; then
#     execute_script "bluetooth.sh"
# fi

# if [ "$thunar" == "Y" ]; then
#     execute_script "thunar.sh"
# fi

# if [ "$sddm" == "Y" ]; then
#     execute_script "sddm.sh"
# fi

# if [ "$xdph" == "Y" ]; then
#     execute_script "xdph.sh"
# fi
