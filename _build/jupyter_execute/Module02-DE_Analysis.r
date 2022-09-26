suppressMessages({if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
  suppressWarnings(BiocManager::install("GEOquery", update = T))
  suppressWarnings(BiocManager::install("limma", update = T))
})

suppressPackageStartupMessages({
  library("GEOquery")
  library("limma")
})

# Load series and platform data from GEO
gset <- suppressMessages(getGEO("GSE48350", GSEMatrix =TRUE, AnnotGPL=TRUE))
# Check how many platform available
if (length(gset) > 1) idx <- grep("GPL570", attr(gset, "names")) else idx <- 1
gset <- gset[[idx]]
# Get expression data matric
expression_data <- exprs(gset)

print(paste0("#Genes: ",dim(expression_data)[1]," - #Samples: ",dim(expression_data)[2]))

# Get samples information
samples <- pData(gset)
# Select sample from Entorhinal Cortex region
idx <- grep("entorhinal", samples$`brain region:ch1`)
gset = gset[ ,idx]
samples = samples[idx,]
# Get expression data for samples collected from entorhinal cortex region
expression_data = expression_data[,idx]
# Print out new number genes and samples
print(paste0("#Genes: ",dim(expression_data)[1]," - #Samples: ",dim(expression_data)[2]))

# Calculate quantile values from the data
qx <- as.numeric(quantile(expression_data, c(0., 0.25, 0.5, 0.75, 0.99, 1.0), na.rm=T))
# Perform log2 transformation
LogC <- (qx[5] > 100) || (qx[6]-qx[1] > 50 && qx[2] > 0)
if (LogC) { expression_data[which(expression_data <= 0)] <- NaN
exprs(gset) <- log2(expression_data)}

# Select diease samples
disease_idx <- grep("AD", samples$source_name_ch1)
# Create a vector to store label
groups <- rep("X", nrow(samples))
# Annotate a diasease sameples as "d"
groups[disease_idx] <- "d"
# Control samples are labeled as "c"
groups[which(groups!="d")] <- "c"
groups <- factor(groups)

# Add groups to gset object
gset$group <- groups
design <- model.matrix(~group + 0, gset)
colnames(design) <- levels(groups)
fit <- lmFit(gset, design)  # fit linear model
# set up contrasts of interest and recalculate model coefficients
cts <- paste("c", "d", sep="-")
cont.matrix <- makeContrasts(contrasts=cts, levels=design)
fit2 <- contrasts.fit(fit, cont.matrix)

# compute statistics and table of top significant genes
fit2 <- eBayes(fit2, 0.01)

dt <- decideTests(fit2,p.value=0.05)
summary(dt)

top_genes <- topTable(fit2, adjust="fdr", sort.by="B", number=1000)

top_genes <- subset(top_genes, select=c("ID","Gene.symbol","adj.P.Val","P.Value","t","B","logFC"))

top_genes <- top_genes[which(top_genes$adj.P.Val<0.05),]
top_genes <- top_genes[which(top_genes$Gene.symbol!=""),]
head(top_genes)

saveRDS(top_genes, file="./data/DE_genes.rds")

suppressMessages({
  suppressWarnings(install.packages("matrixTests",quiet= T))
})
# Load matrixTests package
suppressPackageStartupMessages({library("matrixTests")})

count <- expression_data
X <- count[,groups=="c"]
Y <- count[,groups=="d"]

res <- row_t_equalvar(X,Y,alternative = "two.sided", mu = 0, conf.level = 0.95)

res <- res[order(res$pvalue),]
res <- res[res$pvalue<0.05,]

suppressMessages({ if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
  suppressWarnings(BiocManager::install("edgeR", update = F))
})

# Load edgeR package
suppressPackageStartupMessages({library("edgeR")})

count <- expression_data

dge <- DGEList(counts = count, group = factor(gset$group))
keep <- filterByExpr(y = dge)
dge <- dge[keep,keep.lib.sizes=TRUE]
dge <- calcNormFactors(object = dge)
dge <- estimateDisp(y = dge)
et <- exactTest(object = dge)
top_degs = topTags(object = et, n = "Inf")

write.csv(et$table, file="./data/edgeR_Results.csv")
saveRDS(et$table, file="./data/edgeR_Results.rds")

summary(decideTests(object = et, lfc = 1))

## DE analysis using DESeq2

suppressMessages({ if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
  suppressWarnings(BiocManager::install("DESeq2", update = F))
})
suppressPackageStartupMessages({library("DESeq2")})

coldata <- data.frame(
  sample = colnames(expression_data),
  condition = as.factor(groups),
  row.names = "sample" )

head(coldata)

range(count)

dds <- DESeqDataSetFromMatrix(countData = round(count), colData = coldata,
                              design = ~ condition)

dds <- dds[rowSums(counts(dds)) >= 10,]
dds$condition <- relevel(dds$condition, ref = "c")
dds <- DESeq(dds)
resultsNames(dds)
res <- results(dds)
res <- as.data.frame(res[order(res$padj),])

summary(results(dds),alpha = 0.05)

write.csv(res, file="./data/DESeq2_Results.csv")
saveRDS(res, file="./data/DESeq2_Results.rds")

plotMD(fit2, column=1, status=dt[,1], main=colnames(fit2)[1],
       xlim=c(-8,13),pch=20, cex=1)
abline(h=0)

# summarize test results as "up", "down" or "not expressed"
dT <- decideTests(fit2, adjust.method="fdr", p.value=0.05)
# Venn diagram of results
vennDiagram(dT, circle.col=palette())

# Visualize and quality control test results.
# Build histogram of P-values for all genes. Normal test
# assumption is that most genes are not differentially expressed.
tT2 <- topTable(fit2, adjust="fdr", sort.by="B", number=Inf)
hist(tT2$adj.P.Val, col = "grey", border = "white", xlab = "P-adj",
     ylab = "Number of genes", main = "P-adj value distribution")

# create Q-Q plot for t-statistic
t.good <- which(!is.na(fit2$F)) # filter out bad probes
qqt(fit2$t[t.good], fit2$df.total[t.good], main="Moderated t statistic")

# volcano plot (log P-value vs log fold change)
colnames(fit2) # list contrast names
ct <- 1        # choose contrast of interest
volcanoplot(fit2, coef=ct, main=colnames(fit2)[ct], pch=20,
            highlight=length(which(dT[,ct]!=0)), names=rep('+', nrow(fit2)))


