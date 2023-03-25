#!/usr/bin/env bash
#OR !/bin/bash

# MYLOGLINE="`date +"%b %d %Y %H:%M"` $0:"
# Logging ensured in a .plist by StandardOutPath and StandardErrorPath keys

# set url placeholder name
url_placeholder="url"

curl_path="$(which curl)"
sed_path="$(which sed)"
find_path="$(which find)"

dir_path="$HOME/Desktop/url-file-watcher"

# skip the hidden files
files=( $("${find_path}" "${dir_path}" -maxdepth 1 -type f -not -path '*/\.*') )
the_file=${files[0]}

# if "the_file" variable is empty
if [[ -z "$the_file" ]] || [[ "$the_file" == "${dir_path}/${url_placeholder}" ]]; then
    # echo "$MYLOGLINE no files or a placeholder case; exit."
    exit 0
fi

# Get only the file name without the path and replace ":" with "/"
url_from_file="$(basename "$the_file" | ${sed_path} -E 's/:/\//g')"
if [[ -z "$url_from_file" ]]; then
    # echo "$MYLOGLINE url_from_file empty case; exit."
    exit 0
fi

# form output file name;
# replace one or more non-alphanumeric characters (excluding periods, underscores, and hyphens) with a single hyphen
file_name="$(basename "$url_from_file" | ${sed_path} -E 's/[^[:alnum:]._-]+/-/g')"
# echo "$MYLOGLINE file_name = ${file_name}"

rm "$the_file"

${curl_path} --fail --silent --show-error "https://$url_from_file" --output "${dir_path}/${file_name}" || \
${curl_path} --fail --silent --show-error "http://$url_from_file" --output "${dir_path}/${file_name}"

sleep 15

rm "${dir_path}"/*
touch "${dir_path}/${url_placeholder}"
