#!/bin/bash
csvlook --help  &>/dev/null
checkout=$?
if [ $checkout -ne 0 ]; then
	echo "Error: This script requires csvlook, provided by csvkit"
	exit
fi

full_path=$(realpath $0)
 
dir_path=$(dirname $full_path)
outname=E4S_Products.md
echo -e "# E4S Product Dictionary
<!---This file should not be edited manually. Modify E4S_Products.csv and run bin/generate_E4S_Products.sh --->" > $dir_path/../$outname
csvlook $dir_path/../E4S_Products.csv >> $dir_path/../$outname

