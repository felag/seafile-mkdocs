#!/bin/sh

output_toc=seafile-docs/mydocs.yml

temp_file=temp_mydocs.yml

input_toc=seafile-docs/docs/SUMMARY.md

# Set name
echo "site_name: Server Seafile Manual\n" > $output_toc
echo "\npages:" >> $output_toc

# Change current md TOC to mydocs
sed 's/^* \[\(.*\)\](\(.*\))/\- '\''\1'\'':\n   \- \2/g' < $input_toc > $temp_file
sed 's/* \[\(.*\)\](\(.*\))/\- '\''\1'\'': '\''\2'\''/g' < $temp_file >> $output_toc

#sed 's/^* \[(*.)/- '\''/g
#s/* \[/- '\''/g
#s/\](/'\'': '\''/g
#s/)/'\''/g' < $input_toc >> $output_toc

echo "\ntheme: readthedocs" >> $output_toc
