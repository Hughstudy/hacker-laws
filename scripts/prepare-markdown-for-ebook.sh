#!/usr/bin/env bash

# Fail on errors.
set -e -o pipefail

# Check if parameters are provided
input="$1"
output="$2"
if [ -z "${input}" ] || [ -z "${output}" ]; then
    echo "usage: $(basename "$0") <input> <output>" >&2
    echo "  input: source markdown file (usually README.md)" >&2
    echo "  output: output markdown file (usually hacker-laws.md)" >&2
    exit 1
fi

# Grab env vars used to configure output, fail if required are missing.
export date="${DATE:-$(date +%F)}"
export version="${VERSION?error: VERSION must be set}"

# Update the input file to an intermedate.
intermediate="${input}.temp"
DATE="${date}" VERSION="${version}" envsubst < "${input}" > "${intermediate}"

# Use a single `sed` command to clean up unwanted lines and emojis in one pass.
sed      -e '/💻📖.*/d' \
         -e 's/❗/Warning/g' \
         -e '/^\[Translations.*/d' \
         -e '/\*.*/d' \
         -e '/    \*.*/d' \
         -e '/## Translations/,$d' "${intermediate}" > "${output}"
rm "${intermediate}"

echo "${output} prepared successfully."
