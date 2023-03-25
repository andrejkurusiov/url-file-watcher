#!/usr/bin/env bash

# GENERAL INFO
echo "Read first the README and make sure 'LaunchControl' app and 'fdautil' utility installed and access rights for 'fdautil' are set."

# ASK IF USER IS READY TO PROCEED
read -t 10 -p "Have you done the above? (y/n): " input
[[ -z "$input" || ! "$input" =~ $(locale yesexpr) ]] && echo "Exiting..." && exit 1

# DEFINE THE PATH TO THE INPUT AND OUTPUT FILES
input_file="./source/input.plist"
output_file="$HOME/Library/LaunchAgents/com.$USER.url-file-watcher.plist"

# REPLACE the ~ character with the full path to the current user's home directory
sed "s#~#$HOME#g" "$input_file" > "$output_file"

# WATCHED URL
dir_path="$HOME/Desktop/url-file-watcher/"
mkdir -p $dir_path && touch "${dir_path}/url"

# COPY .SH file
scripts_path="$HOME/.config/scripts/"
mkdir -p "${scripts_path}" && cp ./source/url-file-watcher.sh "${scripts_path}"

# LAUNCH THE SERVICE
launchctl load ${output_file}

# INFORM USER
echo -e "\nThe .plist is copied to ${output_file}"
echo "The script is copied to ${scripts_path}url-file-watcher.sh"
echo "-> URL watching folder is at ${dir_path} (rename the 'url' file)."
echo -e "\n-> To uninstall just remove all files/folders mentioned above."
