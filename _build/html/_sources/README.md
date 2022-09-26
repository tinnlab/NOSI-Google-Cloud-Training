# Consensus Pathway Analysis using Google Cloud Infrastructure


This cloud-based learning module teaches pathway analyses using omics datasets to discover consistent 
biological mechanism behind a condition.Pathway analysis refers to a set of widely used tools for research in life sciences 
intended to give meaning to high-throughput biological data.The main purpose of PA tools is to analyze these data, 
detecting relevant groups of related genes that are altered in case samples in comparison to a control.
Pathway analysis approaches use available pathway databases and the given gene expression data to identify the pathways
which are significantly impacted in a given condition.

The course is structured such that the content will be arranged in five sub-modules which allows us to:
1. Download and process data from public repositories,
2. Perform differential analysis,
3. Perform pathway analysis using different methods that seek to answer different research hypotheses,
4. Perform meta-analysis and combine methods and datasets to find consensus results, and
5. Interactively explore significantly impacted pathways across multiple analyses, and browsing relationships between 
pathways and genes.



## Overview of Page Contents


+ [Getting Started](#GS)
+ [Overview](#OV)
+ [Software Requirements](#SOF)



## <a name="GS">Getting Started</a>
Each learning submodules will be organized in a R Jupyter notebook to help the participants familiarize themselves 
with the cloud computing in the specific context of running bioinformatics workflows. Each notebook will include 
step-by-step hands-on practice with R command line to install necessary tools, obtain data, perform analyses, visualize 
and interpret the results.


## <a name='OV'>Overview</a>

The content of the course is organized in R Jupyter Notebooks. Then we use Jupyter Book which is a package to combine 
individuals Jupyter Notebooks into a web-interface for a better navigation. Details of installing the tools and formatting
the content can be found at: https://jupyterbook.org/en/stable/intro.html. The content of the course is reposed in the 
Github repository of Dr. Tin Nguyen's lab, and can be found at https://github.com/tinnlab/NOSI-Google-Cloud-Training.

Module 1 of the course provides basic knowledge of Data Processing. It walks the student through the process of obtaining data from
multiple platforms such as public repositories like the Gene Expression Omnibus (GEO), preprocessing and manipulating this 
data, normalization, loading and saving the Expression matrix. It also explains the concept of Probe Set ID and describes 
how to map probe IDs into gene identifiers and symbols.

Module 2 describes the next step in the Pathway Analysis workflow after data acquisition and preparation, which is 
Differential Expression Analysis. This is an important process, which goal is to determine which genes are expressed at 
different levels between two or more biological conditions. 

The results of DE analyses are often gene lists, which are difficult to interpret due to their large size and lack of 
useful annotations. Hence, Pathway Analysis aims to reduce the complexity of interpreting gene lists via mapping the 
listed genes to known biological pathways, processes and functions, which are contained in common curated biological 
databases. Module 3 introduces such databases including Gene Ontology (GO), Kyoto Encyclopedia of Genes and Genomes (KEGG).

In Module 4, some Enrichment Analysis methods, which help gain insight into obtained gene lists by identifying pathways that 
are enriched in a gene list more than would be expected by chance are introduced. The three major steps involved the process,
including definition of a gene list from omics data, determination of statistically enriched pathways, and visualization 
and interpretation of the results are explained. 

 Given the importance and applications of Pathway Analysis in physiological and biomedical research, many methods 
 have been developed to identify enriched pathways under different biological states within a genomic study. Also, as more
and more microarray datasets accumulate, meta-analysis methods have also been developed to integrate information among 
multiple studies, in a bid to understand the underlying biological phenomena behind the gene expression changes involved
 in a comparison of two phenotypes. Module 5 focuses on these methods and explores methods such as Fisher's and Stouffer's
methods in detail.

## **Software Requirements** <a name="SOF"></a>


This learning module does not require any computational hardware and local environment setting from users as the 
programs and scripts can be run in the browser-based development environment provided by Google. However, 
users need to have Google email account, sufficient internet access, and a standard web-browser (e.g. Chrome, Edge, 
Firefox etc., Chrome browser is recommended) to create a cloud virtual machine for analysis.

The Jupyter Book will run and test all codes in our notebooks and then build them into a website format. 
The website output is the `_build/html` folder in the repository. After the `_build/html` is completely built, the web 
version of the book will be uploaded from the `_build/html` folder to a Google bucket. 
The address of the cloud bucket can be found at: https://storage.googleapis.com/nosi-gcloud-course/html/intro.html. 
The link http://tinnguyen-lab.com/course/cpa-gcloud/intro.html is just a proxy to that link using Dr. Tin Nguyen's Lab
domain name.

A complete workflow from setting up the environment, building the book, to uploading the website to 
Google cloud bucket can be found here: https://github.com/tinnlab/NOSI-Google-Cloud-Training/blob/main/.github/workflows/main.yml. 
The logs for each time it builds the book are here: https://github.com/tinnlab/NOSI-Google-Cloud-Training/actions.


## **Workflow Diagrams** <a name="WORK"></a>

> Explain the cloud architecture/data flow of your workflow here, and include your data flow diagram here.

# <img src="./images/Intro/Main-img.png" width="900" height="700">

As seen in the image above, we will show how to download sequence data from sources such as the GEO repository using the
GEO website as well as the GEOquery package from the R programming language terminal.
We will use the getGEO function of the package to download GEO datasets, as identified by the accession ID. 
Exploration and preprocessing of the data follows, after which we export it to a desired format.
Next, we map the probe set IDs of the datasets to Entrez gene ID to achieve uniformity, before carrying out Differential
Gene Expression Analysis on the data, which is the focus of Module 2.
It involves assigning samples into groups and setting up design matrix, and then performing DE analysis using limma, t-test, 
edgeR and DESeq packages to produce results which are filtered and exported before being further visualized.

Module 3 introduces Ontology, Gene Ontology and the KEGG Pathway Database. Also, terms and pathway gene sets are downloaded 
from GO and KEGG and then the results are saved to the GMT file format. In Module 4, some Pathway Analysis methods are introduced, before Meta analysis methods are discussed in Module 5. 


## **Data** <a name="DATA"></a>
All data from module the was originally downloaded from the Gene Expression Omnibus (GEO) repository using the accession
number GSE48350 file. The data was originally generated by **Berchtold and Cotman, 2013**. We preprocessed this data and normalized it, 
after which we used it in the subsequent analyses.

## **Troubleshooting** <a name="TR"></a>

Describe common error encountered with your workflow and how to troubleshoot them
Prior to publishing, some common errors frequently encountered by the early users in the workflow include syntax errors
such as calling a library that has not been initialized.
Also, some users who were still beginners to Bioinformatics made basic errors such as confusing the meanings of terms such as 
Pathways and Gene Sets, and misunderstanding what these stand for. However, this is an error that is attributed to limited 
knowledge and is cleared by exposure to the first few sections of Module 1.

## **Funding** <a name="FUND"></a>

>Describe where your funding came from. You should list your NIGMS award and any other funding that contributed to building your module.

## **(Optional, but recommended) License for Data** <a name="LIC"></a>

Text and materials are licensed under a Creative Commons CC-BY-NC-SA license. The license allows you to copy, remix 
and redistribute any of our publicly available materials, under the condition that you attribute the work (details in the license)
and do not make profits from it. More information is available [here](https://tilburgsciencehub.com/about/#license).

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" 
style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />

This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative 
Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.






