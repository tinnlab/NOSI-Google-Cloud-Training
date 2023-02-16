# Consensus Pathway Analysis using Google Cloud Infrastructure
Authors: Bang Tran, Hung Nguyen, Nicole Schrad, Juli Petereit, and Tin Nguyen

This Cloud-based learning module teaches Pathway Analysis, a term that describes the set of tools and techniques used in
life sciences research to discover the biological mechanism behind a condition from high throughput biological data. 
Pathway Analysis tools are primarily used to analyze these omics datasets to detect relevant groups of genes that are 
altered in case samples when compared to a control group. Pathway Analysis approaches make use of already existing pathway 
databases and given gene expression data to identify the pathways which are significantly impacted in a given condition.

The course is structured such that the content will be arranged in five submodules which allows us to:
1. Download and process data from public repositories,
2. Perform differential analysis,
3. Perform pathway analysis using different methods that seek to answer different research hypotheses,
4. Perform meta-analysis and combine methods and datasets to find consensus results, and
5. Interactively explore significantly impacted pathways across multiple analyses, and browsing relationships between 
pathways and genes.

## Overview of Page Contents

+ [Getting Started](#GS)
+ [Google Cloud Buckets](#BUCKET)
+ [Workflow Diagrams](#WORK)
+ [Google Cloud Architecture](#ARCH)
+ [Software Requirements](#SOF)
+ [Data](#DATA)
+ [TroubleShooting](#TR)
+ [Funding](#FUND)
+ [License](#LIC)

## <a name="GS">Getting Started</a>
Each learning submodules will be organized in a R Jupyter notebook with step-by-step hands-on practice with R command 
line to install necessary tools, obtain data, perform analyses, visualize and interpret the results. The notebook will 
be executed in the Google Cloud environment. Therefore, the first step is to set up a virtual machine VertexAI.

### Signing in Google Cloud Platform
You can begin by first navigating to https://console.cloud.google.com/ and logging in with your credentials. 

![](./images/SettingGC/Login.png)

After a few moments, the GCP console opens with following dashboard.

![](./images/SettingGC/Dashboard.png)

### Navigating to the Vertex AI Workbench

Once the login process is done, we can create a virtual machine for analysis using Vertex AI Workbench. 
There are two ways to navigate to Vertex AI. In the first method, we can click the __Navigation menu__ at the top-left, 
next to “Google Cloud Platform”. Then, navigate to <a href="https://console.cloud.google.com/vertex-ai">Vertex AI</a> 
and select <a href="https://console.cloud.google.com/vertex-ai/workbench">Workbench</a>. In the second method, we can 
 go to __Google Cloud Console Menu__ in the __Search products and resources__, enter "Workbench" and then select 
__Workbench Vertex AI__.

![](./images/SettingGC/Vertex-1.png)

If it isn't already enabled we click __Enable__ to start using the API.

![](./images/SettingGC/Enable_API.png)

### Creating a Virtual Machine

Within the Workbench screen, click __MANAGED NOTEBOOKS__, select the region which is closed to your physical location 
and click __CREATE NOTEBOOK__. Since our analyses will be based on R programing language, we need to select R 4.1 as 
our development environment. Then, set a name for your virutal machine and select the server which is closed to you 
physical location. In our learning module, a default machine with 4 vCPUS and 15GB RAM would be suffice. Finally, 
click __CREATE__ to get the new machine up and running.

![](./images/SettingGC/Create_Notebook.png)

Creating a machine may take a few minutes to finish and you should see a new notebook with your designed name appears 
within the workbench dashboard when the process is completed. 

![](./images/SettingGC/New_Notebook.png)

To start the virtual machine, select your notebook in the __USER-MANAGED NOTESBOOK__ and click on __START__ button 
on the top menu bar. The starting process might take up to several minutes. When it is done, the green checkmark 
indicates that your virtual machine is running.  Next, clicking __OPEN JUPYTER LAB__ to access the notebook.

![](./images/SettingGC/Start_Machine.png)

### Downloading and Running Tutorial Files

Now that you have successfully created your virtual machine, and you will be directed to Jupyterlab screen. 
The next step is to import our CPA's notebooks start the course. 
This can be done by selecting the __Git__ from the top menu in Jupyterlab, and choosing the __Clone a Repository__ 
option. 
Next you can copy and paste in the link of repository: "https://github.com/tinnlab/NOSI-Google-Cloud-Training.git" 
(without quotation marks) and click __Clone__.

![](./images/SettingGC/Clone_Git.png)

This should download our repository to Jupyterlab folder. All tutorial files for five sub-moudule are in Jupyter 
format with *.ipynv* extension . Double click on each file to view the lab content and running the code. This will 
open the Jupyter file in Jupyter notebook. From here you can run each section, or 'cell', of the code, one by one, 
by pushing the 'Play' button on the above menu.

![](./images/SettingGC/Run_Cell.png)

Some 'cells' of code take longer for the computer to process than others. You will know a cell is running when a cell 
has an asterisk next to it \[\*\]. When the cell finishes running, that asterisk will be replaced with a number which 
represents the order that cell was run in. You can now explore the tutorials by running the code in each, from top to 
bottom. Look at the 'workflows' section below for a short description of each tutorial.

Jupyter is a powerful tool, with many useful features. For more information on how to use Jupyter, we recommend 
searching for Jupyter tutorials and literature online.

### Stopping Your Virtual Machine

When you are finished running code, you should turn off your virtual machine to prevent unneeded billing or resource 
use by checking your notebook and pushing the __STOP__ button.

## <a name="WORK">Workflow Diagrams</a>

The content of the course is organized in R Jupyter Notebooks. Then we use Jupyter Book which is a package to combine 
individuals Jupyter Notebooks into a web-interface for a better navigation. Details of installing the tools and formatting
the content can be found at: https://jupyterbook.org/en/stable/intro.html. The content of the course is reposed in the 
Github repository of Dr. Tin Nguyen's lab, and can be found at https://github.com/tinnlab/NOSI-Google-Cloud-Training.
The overall structure of the modules is explained below:

+ [**Submodule 01**](./Module01-GEO_Data_Processing.ipynb) describes how to obtain data from public repository, process 
+ and save the expression matrix and shows how to map probe IDs into gene symbols.
+ [**Submodule 02**](./Module02-DE_Analysis.ipynb) focuses on Differential Expression Analysis using `limma`, `t-test`, 
`edgeR`, and `DESeq2`.
+ [**Submodule 03**](./Module03-Gene_Set_and_Pathway.ipynb) introduces common curated biological databases such as Gene 
+ Ontology (GO), Kyoto Encyclopedia of Genes and 
Genomes (KEGG)
+ [**Submodule 04**](./Module04-Pathway_Analysis.ipynb) aims at performing Enrichment Analysis methods using popular 
+ methods such as `ORA`, `FGSEA`, and `GSA`.

# <img src="./images/Intro/Main-img.png" width="900" height="550">

## <a name="BUCKET">Creating Google Cloud Storage Buckets</a>
In this section, we will describe the steps to create Google Cloud Storage Buckets to store data generated during 
analysis.  The bucket can be created via GUI or using the command line.
To use the GUI, the user has to first visit https://console.cloud.google.com/storage/, sign in, click on __Buckets__ 
on the left menu.

# <img src="./images/Bucket/Step0.png">
Next, click on the __CREATE__ button below the search bar to start creating a new bucket.

# <img src="./images/Bucket/Step1.png">

This will then open a page where the user will provide the unique name of the bucket, the
location, access control and other information about the bucket. Here, we named our bucket as _cpa-output_. After this 
the user will click on the __CREATE__ button to complete the process.

# <img src="./images/Bucket/Step2.png">

To create a Bucket using the command line, the user can use the gcloud storage buckets `create` command
`gcloud storage buckets create gs://BUCKET_NAME` where `BUCKET_NAME` is the user-defined name. 
If the request succeeds, the user gets a success message. The user can also add optional flags
while running the `create command ` to have greater control over the creation of the bucket.
Such flags include `--project: PROJECT_NAME`, `--default-storage-class: STORAGE_CLASS`, `--location: LOCATION`
and `--uniform-bucket-level-access` with `PROJECT_NAME` and `STORAGE_CLASS` supplied by the user.

Storage Buckets can also be created on the command line using the `gsutils mb` command.
The command to do so is `gsutil mb gs://BUCKET_NAME`, with `BUCKET_NAME` the desired bucket name.
This command also returns a success message upon completion and can also take optional flags 
`-p`, `-c`, `-l`, `-b` and their user-supplied values, corresponding to project ID or number, default storage class, 
location of the bucket and 
uniform bucket-level access respectively, just like the `create` command.

## <a name="ARCH">Google Cloud Architecture</a>

# <img src="./images/Intro/architecture.png" width="900" height="500">
The figure above shows the architecture of the learning module with Google Cloud infrastructure. First, we will create
an VertexAI workbench with R kernel. The code and instruction for each Sub-Module is presented in a separate Jupyter Notebook.
User can either upload the Notebooks to the VertexAI workbench or clone from the project repository. Then, users can execute 
the code directly in the Notebook. In our learning course, the submodule 01 will download data from the public repository (e.g. GEO database)
for preprocessing and save the processed data to a local file in VertexAI workbench and to the user's Google Cloud Storage Bucket. The output
of the submodule 01 will be used as inputs for all other submodules. The outputs of the submodules 02, 03, and 04 will be saved to 
local repository in VertexAI workbench and the code to copy them to the user's Cloud Bucket is also included.

# <a name="SOF">Software Requirements</a>
This learning module does not require any computational hardware and local environment setting from users as the 
programs and scripts can be run in the browser-based development environment provided by Google. However, 
users need to have Google email account, sufficient internet access, and a standard web-browser (e.g. Chrome, Edge, 
Firefox etc., Chrome browser is recommended) to create a Cloud Virtual Machine for analysis.

The Jupyter Book will run and test all codes in our notebooks and then build them into a website format. 
The website output is the `_build/html` folder in the repository. After the `_build/html` is completely built, the web 
version of the book will be uploaded from the `_build/html` folder to a Google bucket. 
The address of the cloud bucket can be found at: https://storage.googleapis.com/nosi-gcloud-course/html/intro.html. 
The link http://tinnguyen-lab.com/course/cpa-gcloud/intro.html is just a proxy to that link using Dr. Tin Nguyen's Lab
domain name. It is recommended to execute the Jupyter Note Book using R kernel version > 4.1 using a standard machine 
with minimum configuration of 4 vCPUs, 15 GB RAM, and 10GB of HDD.

A complete workflow from setting up the environment, building the book, to uploading the website to 
Google cloud bucket can be found here: https://github.com/tinnlab/NOSI-Google-Cloud-Training/blob/main/.github/workflows/main.yml. 
The logs for each time it builds the book are here: https://github.com/tinnlab/NOSI-Google-Cloud-Training/actions.

## <a name="DATA">Data</a>
All data from the modules were originally downloaded from the Gene Expression Omnibus (GEO) repository using the accession
number GSE48350 file. The data was originally generated by **Berchtold and Cotman, 2013**. We preprocessed this data and
normalized it, after which we used it in the subsequent analyses.

## <a name="TR">Troubleshooting</a>

Some common errors include having the Jupyter Notebook kernel defaulting to Python and libraries not loading properly. To fix the kernel, check that the upper right hand corner of the edit ribbon says "R". If it doesn't, you can click the words next to the circle (O) to change the kernel.  When there are problems loading a library, check that the package has been properly installed. Packages can usually be downloaded by the instructions in the documentation. Other errors that may happen are usually due to grammatical errors such as capitialization or spelling errors. 

## <a name="FUND">Funding</a>

This work was fully supported by NIH NIGMS under grant number GM103440. Any opinions, findings, and conclusions, 
or recommendations expressed in this material are those of the authors and do not necessarily reflect the views 
of any of the funding agencies.

## <a name="LIC">License for Data</a>

Text and materials are licensed under a Creative Commons CC-BY-NC-SA license. The license allows you to copy, remix 
and redistribute any of our publicly available materials, under the condition that you attribute the work (details in the license)
and do not make profits from it. More information is available [here](https://tilburgsciencehub.com/about/#license).

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" 
style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />

This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative 
Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.






