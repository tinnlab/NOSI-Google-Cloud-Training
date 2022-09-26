suppressMessages({if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("GEOquery", update = F)
})

suppressPackageStartupMessages(library("GEOquery"))
## change my_id to be the dataset that you want.
accession_ID <- "GSE48350"
suppressMessages({gse <- getGEO(accession_ID)})

## check how many platforms used
print(paste0("Number of platforms: ",length(gse)))

# if more than one dataset is present, users can analyse the other dataset by changing the number inside the [[...]]
data <- gse[[1]]
# Get the samples information
samples <- pData(data)
# Get the genes information
genes <- fData(data)
# View the first 5 samples/genes with some of their features
samples[1:5,1:5]
genes[1:5,1:5]

head(exprs(data)[,1:5])

summary(exprs(data)[,1:5])
range(exprs(data))

# Get expression matrix
ex <- exprs(data)
# Calculate data quantile and remove the NA value
qx <- as.numeric(quantile(ex, c(0., 0.25, 0.5, 0.75, 0.99, 1.0), na.rm=T))
LogC <- (qx[5] > 100) ||
  (qx[6]-qx[1] > 50 && qx[2] > 0)

# Replace negative values by NA and perform log transformation
if (LogC) {
   ex[which(ex <= 0)] <- NaN #
    norm_ex <- log2(ex+1)
}
# Plot the boxplot of 10 samples
boxplot(norm_ex[,1:10],outline=FALSE)

# Select 10 samples and 10 genes
norm_ex <- as.data.frame(norm_ex[1:10,1:10])

# Create a sub-directory data folder to save the expression matrix if it is not available
dir <- getwd()
subDir <- "/data"
path <- paste0(dir,subDir)
if (!file.exists(path)){
    dir.create(file.path(path))
}
# Save expresion values to the csv format in the local folder
write.csv(norm_ex, file="./data/GSE48350.csv")

# Save expresion values to the rds format
saveRDS(norm_ex, file="./data/GSE48350.rds")

