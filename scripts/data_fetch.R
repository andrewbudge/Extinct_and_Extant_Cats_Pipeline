#### Imports ####
library(rentrez)
library(XML)
library(dplyr)
library(httr)
library(seqinr)
library(progress)

#### Gathering taxa-ids ####
cat_tax <- entrez_search(db='taxonomy', term='txid9681[SBTR]', retmax=2000)
cat_tax_sum <- entrez_summary(db='taxonomy', cat_tax$ids)


#### Creating a matrix for sequence data ####
catdat <- matrix(, nrow=(length(unique(cat_tax$ids))), ncol=5)
colnames(catdat)<-c('taxid', 'speciesname', 'accnum', 'seqname', 'slen')
i <- 1
mitosequence <- character()
gene <- 'MITOCHONDRION'
for (i in 1:length(unique(cat_tax$ids))){
  print(i)
  catdat[i,1] <- cat_tax$ids[i]
  record <- entrez_summary(db='taxonomy', id=cat_tax$ids[i])
  catdat[i,2] <- record$scientificname
  seqout <- entrez_search(db='nuccore', 
                          term=paste0('txid', cat_tax$ids[i], '[ORGN] AND ', gene,'[ALL]'),
                          retmax=1)
  if (length(seqout$ids) < 1) {
    catdat[i,3:5] <- NA
    
  }
  else {
    sumout <- entrez_summary(db='nuccore', id=seqout$ids)
    catdat[i,3] <- sumout$accessionversion
    catdat[i,4] <- sumout$title
    catdat[i,5] <- sumout$slen
    seq.dat <- entrez_fetch(db='nuccore', id=sumout$accessionversion, rettype='fasta')
    seq.dat <- sub(">([^\n]*)", paste0(">", sumout$organism), seq.dat)
    seq.dat <- gsub(" ", "_", seq.dat)
    mitosequence <- c(mitosequence, seq.dat) 
  }
}


write.csv(catdat, paste0('catdat_',gene, '.csv'), row.names=FALSE)
write(mitosequence, file=paste0(gene,"_test.fasta"))

#### Creating the function for the process ####
cat_dat_collection <- function(gene) {

  catdat <- matrix(, nrow=(length(unique(cat_tax$ids))), ncol=5)
  colnames(catdat)<-c('taxid', 'speciesname', 'accnum', 'seqname', 'slen')
  i <- 1
  mitosequence <- character()
  for (i in 1:length(unique(cat_tax$ids))){
    print(i)
    catdat[i,1] <- cat_tax$ids[i]
    record <- entrez_summary(db='taxonomy', id=cat_tax$ids[i])
    catdat[i,2] <- record$scientificname
    seqout <- entrez_search(db='nuccore', 
                            term=paste0('txid', 
                                        cat_tax$ids[i], 
                                        '[ORGN] AND ', 
                                        gene,
                                        '[GENE] AND ("1"[SLEN] : "50000"[SLEN])'),
                            retmax=1)
    if (length(seqout$ids) < 1) {
      catdat[i,3:5] <- NA
      
    }
    else {
      sumout <- entrez_summary(db='nuccore', id=seqout$ids)
      catdat[i,3] <- sumout$accessionversion
      catdat[i,4] <- sumout$title
      catdat[i,5] <- sumout$slen
      seq.dat <- entrez_fetch(db='nuccore', id=sumout$accessionversion, rettype='fasta')
      seq.dat <- sub(">([^\n]*)", paste0(">", sumout$organism), seq.dat)
      seq.dat <- gsub(" ", "_", seq.dat)
      mitosequence <- c(mitosequence, seq.dat) 
    }
  }
  
  
  write.csv(catdat, paste0('data/catdat_',gene, '.csv'), row.names=FALSE)
  write(mitosequence, file=paste0('data/', gene,"_test.fasta"))
  
}

# Collecting for individual genes
cat_dat_collection(gene='NCR1')
cat_dat_collection(gene='ASIP')
cat_dat_collection(gene='CMAH')
cat_dat_collection(gene='KIT')











