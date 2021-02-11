#!/bin/bash 
set -eo pipefail
result_line=""

while read -r line
do
    echo "line = $line"
    if [ -n "$result_line" ]; then
        result_line="$result_line, "
    fi
    result_line="$result_line \"$line\""
done < "r-pkg-deps.txt"

if [ -n "$result_line" ]; then
R --vanilla <<- 'EOF'
options(repos = c(CRAN = "https://cloud.r-project.org"))
.libPaths()
install.packages(
    c("$result_line")
    )
EOF

echo "information about R-packages"
R --vanilla <<- 'EOF'
installed.packages() -> d1
print('testthat')
print(d1[rownames(d1) == 'testthat', c("Version", "LibPath")])
print('yaml')
print(d1[rownames(d1) == 'yaml', c("Version", "LibPath")])
EOF
echo 'verify system installation step'
wget --version
curl --version
fi
