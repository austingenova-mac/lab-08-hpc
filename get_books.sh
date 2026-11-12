#!/bin/bash
set -euo pipefail

bucket="$1"
book_dir="$2"

# Create the book directory, then turn it into an absolute path
mkdir -p "$book_dir"
book_dir=$(realpath "$book_dir")

# Copy only the .txt files from the bucket
aws s3 cp "s3://$bucket" "$book_dir" --recursive --exclude "*" --include "*.txt"

# Write the header, then each book's absolute path in sorted order
echo "File path" > book_list.txt
find "$book_dir" -name "*.txt" | sort >> book_list.txt

# Count the books, skipping the header line
count=$(tail -n +2 book_list.txt | wc -l)
echo "Listed $count books"
