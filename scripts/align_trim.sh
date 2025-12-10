#!/usr/bin/env
set -e

INPUT_DIR="$1"   
ALIGNED_DIR="$2"    
TRIMMED_DIR="$3"   

mkdir -p "$ALIGNED_DIR" "$TRIMMED_DIR"

# Create temp for clipkit
python3 -m venv clipkitENV
source clipkitENV/bin/activate
pip install --quiet clipkit

# Align with MAFFT
for file in "$INPUT_DIR"/*.{fasta,fas,fa}; do
    [[ -e "$file" ]] || continue
    base=$(basename "$file")
    base_no_ext="${base%.*}"
    aligned_file="$ALIGNED_DIR/${base_no_ext}_aln.fasta"

    mafft --thread 6 --auto "$file" > "$aligned_file"
done

# rm MAFFT logs
find "$INPUT_DIR" -type f -name "*.log" -delete

# Trim alignments with ClipKIT
for aln in "$ALIGNED_DIR"/*_aln.fasta; do
    [[ -e "$aln" ]] || continue
    base=$(basename "$aln" _aln.fasta)
    trimmed_file="$TRIMMED_DIR/${base}_trm.fas"

    clipkit "$aln" -m smart-gap -o "$trimmed_file"
done

# Cleanup
deactivate
rm -rf clipkitENV/

