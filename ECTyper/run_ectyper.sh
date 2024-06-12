#!/bin/bash

# Read file content from stdin (provided by tar --to-command)
input=$(cat)

# Get file name
prefix=$(basename "$1" .fa)
echo $1

# Create a temporary file to store input in the specified directory
temp_dir=$(mktemp -d ./tmpdir.XXXXXX)
tmp_input="${temp_dir}/${prefix}.fa"
echo "$input" > "$tmp_input"

# Run ECTyper
ectyper -c 1 -i ${tmp_input} -o ${temp_dir} 2>> ectyper_error.log
mv ${temp_dir}/output.tsv ${2}/${prefix}.tsv

# Clean up
rm -r $temp_dir