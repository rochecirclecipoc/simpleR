#!/bin/bash
set -eo pipefail
# information about packages file
# system-deps.txt file ends with empty line
# contains list of system packages to be installed, one per line
#

result_line=""

file="./.circleci/system-deps.txt"

if [ -f "$file" ]; then
    while read -r line
    do
        echo "line = $line"
        result_line="$result_line $line"
    done < "$file"

    echo "result_line = $result_line"

    if [ -n "$result_line" ]; then
        apt-get update
        apt-get install --no-install-recommends -y --verbose-versions $result_line
        apt-get clean
    fi
else
    echo "System dependencies file ($file) does not exist"
fi
