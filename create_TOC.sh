#!/bin/sh

output_toc=mkdocs.yml

temp_file=temp_mydocs.yml

input_toc=seafile-docs/docs/SUMMARY.md

# Set name
echo "site_name: Server Seafile Manual\n" > ${output_toc}

echo "\npages:" >> ${output_toc}

# Change current md TOC to mydocs

# "First level menus"
sed 's/^* \[\(.*\)\](\(.*\))/\- '\''\1'\'':\n   \- \2/g' < ${input_toc} > ${temp_file}

# "Second level menus"
sed -i 's/^   \* \[\(.*\)\](\(.*\))/\   - '\''\1'\'': \2/g' ${temp_file}

# "Third level menus"
sed 's/^       \* \[\(.*\)\](\(.*\))/\       - '\''\1'\'': \2/g' < ${temp_file} >> ${output_toc}


# add theme
echo "\ntheme: readthedocs" >> $output_toc

# remove temporary files
rm ${temp_file}

