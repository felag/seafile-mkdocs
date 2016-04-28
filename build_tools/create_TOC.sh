#!/bin/sh

MKDOCS_DIR=..

output_toc="${MKDOCS_DIR}/mkdocs.yml"
temp_file="${MKDOCS_DIR}/temp_mydocs.yml"
# Following file needs to exist
input_toc="${MKDOCS_DIR}/docs/SUMMARY.md"
if [ ! -f ${input_toc} ]; then
  echo "${input_toc} file does not exist ! Aborting."
  exit 1
fi

# Following file needs to exist
index="${MKDOCS_DIR}/docs/README.md"
if [ ! -f ${index} ]; then
  echo "${index} file does not exist ! Aborting."
  exit 1
fi

# Set name
echo "site_name: Server Seafile Manual\n" > ${output_toc}

echo "\npages:" >> ${output_toc}

# For default page
cp "${index}" "${MKDOCS_DIR}/docs/index.md"
echo "\n- Summary: index.md" >> ${output_toc}


# Change current md TOC to mydocs

# "First level menus"
sed 's/^* \[\(.*\)\](\(.*\))/\- '\''\1'\'':\n   \- \2/g' < ${input_toc} > ${temp_file}

# "Second level menus"
sed -i 's/^   \* \[\(.*\)\](\(.*\))/\   - '\''\1'\'': \2/g' ${temp_file}

# "Third level menus"
sed -i 's/^       \* \[\(.*\)\](\(.*\))/\       - '\''\1'\'': \2/g' ${temp_file}

# Change sections names
sed 's/^\(.*\) \* \(.*\)$/\1 - '\''\2'\'':/g' ${temp_file} >> ${output_toc}

# add theme
echo "\ntheme: readthedocs" >> $output_toc

# remove temporary files
rm ${temp_file}

