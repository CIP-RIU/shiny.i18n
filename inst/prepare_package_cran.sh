#!/bin/bash
echo "==> Switching to cran-release branch."
BASENAME=$(dirname "$0")
cd $BASENAME/..
git checkout -B temp_cran_release

echo "==> Preparing package for CRAN release."
rm -r build/ docs/ examples/ LICENSE.md CHANGELOG.md README.Rmd README_files build_readme.R examples/ readme_assets/ readme_rmd_template/ inst/semantic/.versions .github/ .travis.yml

echo "==> Cleaning README"
sed -i '' '/link href/d' README.md

mkdir build

echo "==> Building package tar.gz archive."
R CMD build ../shiny.i18n
zip_file=$(find *tar.gz)

echo "==> Checking package."
R CMD check --as-cran $zip_file
mv $zip_file build/
rm -r shiny.i18n.Rcheck/

echo "==> Reset changes and switching to master branch."
git reset --hard
git checkout master
git branch -D temp_cran_release
