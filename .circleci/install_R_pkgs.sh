#!/bin/bash 
set -eo pipefail
result_line=""
file="./.circleci/r-pkg-deps.txt"

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

echo "information about R-packages"
R --vanilla <<- 'EOF'
installed.packages() -> d1
print('testthat')
print(d1[rownames(d1) == 'testthat', c("Version", "LibPath")])
print('yaml')
print(d1[rownames(d1) == 'yaml', c("Version", "LibPath")])
EOF
echo 'verify system installation step'

fi
