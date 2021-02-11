#!/bin/bash
set -eo pipefail
# system-deps.txt file ends with empty line

result_line=""

file="./.circleci/system-deps.txt"

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
    wget --version
    curl --version
fi
