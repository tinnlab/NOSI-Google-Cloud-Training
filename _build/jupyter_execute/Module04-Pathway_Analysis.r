data <- read_csv("./data/DE_genes.csv")


data.head()

mask <- data$adj.P.Val < 0.05 &
        abs(data$logFC) > log2(2)

deGenes <- rownames(data[mask,])


deGenes

length(deGenes)


geneUniverse <- rownames(data)


length(geneUniverse)


library(org.Hs.eg.db)


deGenes <- unlist(mget(deGenes, envir=org.Hs.egENSEMBL2EG,
                       ifnotfound = NA))


geneUniverse <- unlist(mget(geneUniverse, envir=org.Hs.egENSEMBL2EG,
                            ifnotfound = NA))


library(clusterProfiler)


ans.go <- enrichGO(gene = deGenes, ont = "BP",
                   OrgDb ="org.Hs.eg.db",
                   universe = geneUniverse,
                   readable=TRUE,
                   pvalueCutoff = 0.05)

tab.go <- as.data.frame(ans.go)


tab.go<- subset(tab.go, Count>5)


tab.go[1:5, 1:6]


library(enrichplot)


p1 <- barplot(ans.dis, showCategory=10)


p1

p2 <- dotplot(ans.kegg, showCategory=20) + ggtitle("KEGG")
p3 <- dotplot(ans.dis, showCategory=20) + ggtitle("Disease")


plot_grid(p2, p3, nrow=2)


p4 <- upsetplot(ans.dis)


p4

p5 <- emapplot(ans.kegg)


p5

 install.packages("cowplot")

cowplot::plot_grid(p1, p3, p5, ncol=2, labels=LETTERS[1:3])




library(tidyverse)


data <- read_csv("./data/DE_genes.csv")


data

mask <- data$adj.P.Val < 0.05 &
  abs(data$logFC) > log2(2)

deGenes <- rownames(data[mask,])


deGenes

length(deGenes)


geneUniverse <- rownames(data)


length(geneUniverse)


library(data.table)


library(fgsea)


library(ggplot2)


data(examplePathways)


data(exampleRanks)


fgseaRes <- fgsea(pathways = examplePathways,
                  stats    = exampleRanks,
                  eps      = 0.0,
                  minSize  = 15,
                  maxSize  = 500)

head(fgseaRes[order(pval), ])


plotEnrichment(examplePathways[["5991130_Programmed_Cell_Death"]],
               exampleRanks) + labs(title="Programmed Cell Death")


topPathwaysUp <- fgseaRes[ES > 0][head(order(pval), n=10), pathway]


topPathwaysDown <- fgseaRes[ES < 0][head(order(pval), n=10), pathway]


topPathways <- c(topPathwaysUp, rev(topPathwaysDown))


plotGseaTable(examplePathways[topPathways], exampleRanks, fgseaRes,
              gseaParam=0.5)







# To load the GMT file for enrichment analysis, we can use GSA.read.gmt function available in the GSA R package. Here is the code to install the package and load the GMT file

suppressMessages({
  suppressWarnings(install.packages("GSA"))
  suppressPackageStartupMessages({
    suppressWarnings(library(GSA))
  })
})

# Load the GMT file from disk, we use "invisible" function to supress the excessive output message from the "GSA.read.gmt" function

invisible(capture.output(pathways <- GSA::GSA.read.gmt("./data/KEGG_pathways.gmt")))

# View first five pathways and related gene sets
pathways$genesets[1:5]

# View the name of the pathways
pathways$geneset.names[1:5]

# View the description of each pathway
pathways$geneset.descriptions[1:5]



## Enrichment analysis using gsa


# // GSA using GO



# // GSA with KEGG


