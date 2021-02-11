#!/bin/bash -eo pipefail
R --vanilla \<<- 'EOF'
options(repos = c(CRAN = "https://cloud.r-project.org"))
.libPaths()
install.packages(
    c("testthat", "yaml")
    )
EOF

echo "information about R-packages"
R --vanilla \<<- 'EOF'
installed.packages() -> d1
print('testthat')
print(d1[rownames(d1) == 'testthat', c("Version", "LibPath")])
print('yaml')
print(d1[rownames(d1) == 'yaml', c("Version", "LibPath")])
EOF
echo 'verify system installation step'
wget --version
curl --version
