#!/bin/bash 
set -eo pipefail
# information about packages file
# r-pkg-deps.txt file ends with empty line
# contains list of R-packages to be installed, one per line
#

result_line=""
file="./.circleci/r-pkg-deps.txt"

if [ -f "$file" ]; then
    while read -r line
    do
        echo "line = $line"
        if [ -n "$result_line" ]; then
            result_line="$result_line, "
        fi
        result_line="$result_line \"$line\""
    done < "$file"

    if [ -n "$result_line" ]; then
        Rscript --vanilla -e 'options(repos = c(CRAN = "https://cloud.r-project.org"))' \
            -e '.libPaths()' \
            -e "install.packages(c($result_line))"

        echo "information about R-packages from list"
        while read -r line
        do
            echo "details about package: $line"
            Rscript --vanilla -e 'installed.packages() -> d1' \
                -e "print(d1[rownames(d1) == '$line', c('Version', 'LibPath')])"
        done < "$file"
    fi
else
    echo "R packages dependencies file ($file) does not exist"
fi
