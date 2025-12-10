# Extinct_and_Extant_Cats_Pipeline
## Summary:
This is a phylogenomic pipeline to analyze genetic data of extinct and extant cats(felide) in order to understand the evolution and spread of cats around the world.

## Where to find Files

### Raw data collection and Alignments
* scripts/data_fetch.R collects our data from entrez database
* data/raw/ contains all of the files and relevant information about all of the genes
* scripts/filter.sh filters out the genes that we couldn't use
* scripts/get_mito_genes.sh found mitochondrial genes

### Alignment Curation
* scripts/align_trim.sh aligned and trimmed all of our alignments
* data/raw/align/ has all of our alignments
* data/raw/trimmed contains all of the trimmed alignments

### Supermatrix
* data/raw/super_matrix/cat_smx.fas

### Configurations
* scripts/beast2_cats_smx.xml BEAST configuration File
* scripts/partitions.nex partitions file for the supermatrix

### Outputs
* outputs/partitions.nex.iqtree logging output from IQTREE
* outputs/partitions.nex.tree IQTREE tree file
* outputs/thinned_trees_cats_smx.trees BEAST2 tree file
* outputs/beast2_cats_smx.xml.state BEAST2 logging output

### Draft Trees
* All draft trees are in the draft_trees/ directory

### Final Tree
* final_submissions/final_tree.pdf



