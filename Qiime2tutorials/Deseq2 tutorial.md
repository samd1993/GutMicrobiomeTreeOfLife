```{r}
setwd("/Users/samd/OneDrive\ -\ Northwestern\ University/Primate/Scripts")
```

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

#Doing deseq2 on primate skin data ..first on subset of data with only antibiotics and lipid synthesis

```{r}
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("DESeq2")
```

#loading packages (I constantly set my working directory becuase my Rstudio is bugged)

```{r}
setwd("/Users/samd/OneDrive\ -\ Northwestern\ University/Primate/Scripts")
library(DESeq2)
library(ggplot2)
```

#now here is the Deseq code. Anything with 'm' or 'meta' is my metadata file and I happened to name my OTU table 'cts' but you can name it whatever you want

#I happen to subset the metadata a couple times. You can start by doing Preschool vs Adult first. So subset those out by doing metadata2=subset(metadata, Age=='Preschool' & Age=='Adult')

#obviously make sure to match how they are spelled in actual metadata

```{r}
mphy=read.table("16Smetadata2.txt",header=TRUE,row.names=1) #this is where you read in your metadata file whatever it is called
mphy

#this is my subsetting. You only need to one subset for now

metaphy <- subset(mphy, !is.na(Location))
metaphy=subset(metaphy,Location!='human')
metaG=subset(metaphy,Species=='Gorilla_gorilla_gorilla')
metaC=subset(metaphy,Species=='Pan_troglodytes')
```

#now this filters the metadata and the otu table to have the same samples (it maches OTU column names to metadata row names

```{r}
icol=colnames(cts) #in this case cts is the the name of your OTU table (which you have read in before with the adonis script I believe)
irow=rownames(metaG)  #in this case you put metadata2 here for the new metadata you made

int=intersect(irow,icol)
cts2=cts[ ,int]   #again cts is your metadata
meta2=metaG[int, ]      #and again here metaG is your metadata
```

#So now you have matching metadata and otu table

#now run deseq. For Location you would put Age or whatever the Age column is.

```{r}
library(DESeq2)
dds <- DESeqDataSetFromMatrix(countData = cts2,
                              colData = meta2,
                              design= ~ Location)
                              
dds <- DESeq(dds)
resultsNames(dds) # lists the coefficients

humanVg=results(dds, contrast=c("Location","Chin","Cheek"))  #here you put Age, Preschool, Adult or whatever they are
res2=humanVg[order(-humanVg$padj), "pvalue", drop = FALSE]

gorillaChinVCheek16S=humanVg[order(humanVg$padj),]  #you can name this PreschoolvsAdult16S or something

write.csv(as.data.frame(gorillaChinVCheek16S), file="deseq2pathgorillaChinVCheek16S.csv") #and then input that name here as well instead of what I have written to write the CVS
```

