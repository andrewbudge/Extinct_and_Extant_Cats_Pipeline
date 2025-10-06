#!/bin/bash

# Dec vars
# MAKE SURE TO SET THIS FIRST TO BE CORRECT!
CSV=${1:-"felidae_MITOCHONDRION_info.csv"}
OUTDIR=${2:-"./"}
SEQRIPPER=${3:-"SeqRipper.py"}
MITO_ACC_NUMS="mito_acc_nums.txt"

# extract mito nums exculdeing the NA's
awk -F, 'NR>1 {
    gsub(/"/, "", $3)
    if (toupper($3) != "NA" && $3 != "")
        print $3
}' "$CSV" > "$MITO_ACC_NUMS"

# run seqipper
python3 "$SEQRIPPER" -i "$MITO_ACC_NUMS" -g ATP8 ND5 COI CYTB 12S 16S -o "$OUTDIR"

# Put all genes together into one fasta file
for gene in ATP8 ND5 COI CYTB 12S 16S; do
    cat *"$gene"* > "${gene}.fas"
done

# This will remove all the individual fasta *THIS IS RISKY BUT IT WORKS SO WE WILL KEEP IT*
rm *.fasta





