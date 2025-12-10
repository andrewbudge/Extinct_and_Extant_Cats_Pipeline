#!/usr/bin/env bash

MITO_DIR="$1"
NUCLEAR_DIR="$2"
OUTPUT_DIR="$3"

for file in "$MITO_DIR"/*.fasta; do
    [[ -e "$file" ]] || continue
    filename=$(basename "$file")
    output_name="$OUTPUT_DIR/mito/$filename"

    seqkit seq -w 0 "$file" | \
        seqkit rename | \
        seqkit sort -l -r | \
        seqkit replace -p "^(.+)_\d+$" -r '$1' | \
        seqkit rmdup -n -o "$output_name"
done

for file in "$NUCLEAR_DIR"/*.fasta; do
    [[ -e "$file" ]] || continue
    filename=$(basename "$file")
    output_name="$OUTPUT_DIR/nuclear/$filename"

    seqkit seq -w 0 "$file" -o "$output_name"
done

