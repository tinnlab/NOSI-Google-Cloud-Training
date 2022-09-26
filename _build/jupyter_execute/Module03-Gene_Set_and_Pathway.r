# Gene set and pathway

![](./images/Module3/Workflow3.jpg)

Differential expression (DE) analysis typically yields a list of genes or proteins that require further interpretation.
Our intention is to use such lists to gain novel insights about genes and proteins that may have roles in a given
phenomenon, phenotype or disease progression. However, in many cases, gene lists generated from DE analysis are
difficult to interpret due to their large size and lack of useful annotations. Hence, pathway analysis (also known
as gene set analysis or over-representation analysis), aims to reduce the complexity of interpreting gene lists
via mapping the listed genes to known (i.e. annotated) biological pathways, processes and functions.
This learning module introduces common curated biological databases including Gene Ontology (GO),
Kyoto Encyclopedia of Genes and Genomes (KEGG).

## Learning Objectives:
1. Introduction to Ontology and Gene Ontology.
2. Introduction to KEGG Pathway Database.
3. Downloading terms, pathway gene set from GO and KEGG.
4. Saving results to GMT file format.

# Installation of topGO and hgu133plus2.db package
suppressMessages({if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
  suppressWarnings(BiocManager::install("topGO", update = F))
  suppressWarnings(BiocManager::install("hgu133plus2.db", update = F))
})
# Loading the library
suppressPackageStartupMessages({
  library("topGO")
  library("hgu133plus2.db")
})

data = readRDS("./data/DE_genes.rds")

# Get p-value from DE results
genelist <- data$adj.P.Val
# Assgin gene IDs to associated p-values
names(genelist) <- data$ID

# Map gene IDs to gene symbols
gene <- select(hgu133plus2.db, names(genelist), "SYMBOL")
# Remove duplicated gene IDs
gene <- gene[!duplicated(gene[,1]),]

# Assign result to a new genlist with gene symbols
geneList2 <- genelist
names(geneList2) <- gene[,2]

GOdata <- new("topGOdata", description = "",ontology = "BP",
                    allGenes = geneList2, geneSel = function(x)x, nodeSize = 10,
                    annot = annFUN.org, ID = "alias", mapping = "org.Hs.eg")

allGO = genesInTerm(GOdata)
allGO[1:5]

suppressMessages({if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
  suppressWarnings(BiocManager::install("GO.db", update = F))
})
library(GO.db)

terms <- names(allGO)
descriptions <-lapply(Term(terms), `[[`, 1)

.libPaths()

writeGMT <- function(genesets, descriptions, outfile) {

  if (file.exists(outfile)) {
    file.remove(outfile)
  }
  for (gs in names(genesets)) {
    write(c(gs, gsub("\t", " ", descriptions[[gs]]), genesets[[gs]]), file=outfile, sep="\t", append=TRUE, ncolumns=length(genesets[[gs]]) + 2)
  }
}
outfile <- "./data/GO_terms.gmt"
writeGMT(allGO, descriptions, outfile)

suppressMessages({if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
  suppressWarnings(BiocManager::install("KEGGREST", update = F))
})
suppressPackageStartupMessages({
  library(KEGGREST)
})

library(KEGGREST)

KEGGREST::listDatabases()

organism <- keggList("organism")

print(paste0("KEGG supports ",dim(organism)[1]," organisms"))

head(organism)

pathways.list <- keggList("pathway", "hsa")

pathways.list[1:5]

pathway.codes <- sub("path:", "", names(pathways.list))

print(paste0("Number of available pathways for human are: ", length(pathway.codes)))

genes.by.pathway <- sapply(pathway.codes,
                            function(pwid){
                              pw <- keggGet(pwid)
                              if (is.null(pw[[1]]$GENE)) return(NA)
                              pw2 <- pw[[1]]$GENE[2]
                              pw2 <- unlist(lapply(strsplit(pw2, split = ";", fixed = T), function(x)x[1]))
                              return(pw2)
                            }
)

 description.by.pathway <- sapply(pathway.codes,
                                  function(pwid){
                                    pw <- keggGet(pwid)
                                    if (is.null(pw[[1]]$NAME)) return(NA)
                                    pw2 <- pw[[1]]$NAME
                                    return(pw2)
                                  }
 )
 description.by.pathway <- as.list(description.by.pathway)

outfile <- "./data/KEGG_pathways.gmt"
writeGMT(genes.by.pathway, description.by.pathway, outfile)

suppressMessages({
  suppressWarnings(install.packages("GSA"))
  suppressPackageStartupMessages({
  suppressWarnings(library(GSA))
})
})

# Load the GMT file from disk, we use "invisible" function to supress the excessive
# output message from the "GSA.read.gmt" function
invisible(capture.output(pathways <- GSA::GSA.read.gmt("./data/KEGG_pathways.gmt")))

# View first five pathways and related gene sets
pathways$genesets[1:5]

# View the name of the pathways
pathways$geneset.names[1:5]

# View the description of each pathway
pathways$geneset.descriptions[1:5]



