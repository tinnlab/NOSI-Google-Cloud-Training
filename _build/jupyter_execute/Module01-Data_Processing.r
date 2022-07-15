if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
f::install("GEOquery", update = F)

library("GEOquery")
## change my_id to be the dataset that you want.
my_id <- "GSE48350"
gse <- getGEO(my_id)

## check how many platforms used
length(gse)


# if more than one dataset is present, users can analyse the other dataset by changing the number inside the [[...]]
data <- gse[[1]]
# Get the samples information
samples = pData(data)
# Get the genes information
genes = fData(data)
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
if (LogC) { ex[which(ex <= 0)] <- NaN
norm_ex <- log2(ex+1) }
# Plot the boxplot of 10 samples
boxplot(norm_ex[,1:10],outline=FALSE)

# If users have installed readr package, please uncomment the line below to do so.
# install.packages("readr")
library(readr)
# Select 10 samples and 10 genes
norm_ex <- as.data.frame(norm_ex[1:10,1:10])
# Save expresion values to the csv format
write_csv(norm_ex, file="./data/GSE48350.csv")

# Save expresion values to the rds format
saveRDS(norm_ex, file="./data/GSE48350.rds")

