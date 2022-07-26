#if (!require("BiocManager", quietly = TRUE)
#   install.packages("BiocManager")
BiocManager::install("hgu133plus2.db", update = F)

data = readRDS("./data/GSE48350.rds")
probeIDs = rownames(data)
probeIDs

library(hgu133plus2.db)

annotLookup <- select(hgu133plus2.db, keys = probeIDs, columns = c('PROBEID', 'ENSEMBL', 'SYMBOL'))

annotLookup

rownames(data) <- unique(annotLookup$SYMBOL)

data

