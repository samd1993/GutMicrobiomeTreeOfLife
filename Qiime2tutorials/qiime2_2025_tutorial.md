## activate linux (for Windows Users)

`wsl`

## make sure miniconda is installed

## update conda (if installing qiime2 for first time--if installed skip to activate qiime2 step)

`conda update conda`

## install qiime2 version 2023.2 (skip if qiime2 installed)

## activate qiime2

`conda activate qiime2-2023.2`

  

## make new directory

`mkdir <FirstAuthorSecondAuthorCountry>`

The name should be the First Author's last name and the Second Author's last name appended to the Country. Notice how I use captial letters instead of spaces to separate words. This is a good tip for coding in general. Spaces usually lead to messy errors.

  

## change directory

`cd <FirstAuthorSecondAuthorCountry>`

  

## paste bash script for downloading fastq files (from SRA Explorer) -- pick 30 samples if there are more than 30

  

## Step 1: generate file names for manifest

```ls -d -x "$PWD/"*```

The above code should print out your paths as one line in your terminal for only your fastqfiles. Make sure there aren't any other fastqs in there

The copy and paste the full paths into an excel sheet like so:

| sampleid | absolute-filepath |
| ------------------------------- | --------------------------------------------------------- |
| FirstAuthorSecondAuthorCountry  |	/Users/samd/gutmicrobiome/teststudy/SRR1589726_1.fastq.gz |
| FirstAuthorSecondAuthorCountry	| /Users/samd/gutmicrobiome/teststudy/SRR7528861_1.fastq.gz |
| FirstAuthorSecondAuthorCountry	| /Users/samd/gutmicrobiome/teststudy/SRR7528862_1.fastq.gz |

where the sampleid's are <FirstAuthorSecondAuthorCountry1> and <FirstAuthorSecondAuthorCountry2> and so on. Naming correctly will be CRITICAL for downstream analyses and trying to reverse engineer any mistakes will be very hard. So make sure to keep this file and always slack me first if you have any questions about this step! As long as you have this file we will be able to fix any issues later on.

Lastly you want to save the file as a tab delimited file. Make sure to name it as **FirstAuthorSecondAuthorCountryManifest**. This is very important as it will save this as a text file where each column is separated by tabs under the hood and it will add a .txt to the end of the fielname for you. TripleCheck that the name is correct! 
Do not save as an excel file. You should see **FirstAuthorSecondAuthorCountryManifest.txt** wherever you saved it to.

Now we want to move this manifest to your Study folder where all your fastqs are. (It's ok that this is not a fastq file since we already have the paths identified).
  
Now we are ready to import!

## Step 2: convert gz files to qza
```
    qiime tools import \
    --type 'SampleData[SequencesWithQuality]' \
    --input-path <FirstAuthorSecondAuthorCountry>_manifest.txt \
    --output-path <FirstAuthorSecondAuthorCountry>_demux.qza \
    --input-format SingleEndFastqManifestPhred33V2
  ````
## Step 3: filter by quality scores

```
qiime quality-filter q-score \
 --i-demux <FirstAuthorSecondAuthorCountry>_demux.qza \
 --o-filtered-sequences <FirstAuthorSecondAuthorCountry>_demux_filtered.qza \
 --o-filter-stats demux-filter-stats.qza
 ```


## Step 4: run deblur (denoising step that runs quality control on all the sequences and trims them to same length)

```
qiime deblur denoise-16S \
  --i-demultiplexed-seqs <FirstAuthorSecondAuthorCountry>_demux_filtered.qza \
  --p-trim-length 150 \
  --o-representative-sequences rep-seqs_<FirstAuthorSecondAuthorCountry>.qza \
  --o-table table_<FirstAuthorSecondAuthorCountry>.qza \
  --p-sample-stats \
  --o-stats deblur-stats<FirstAuthorSecondAuthorCountry>.qza
```

Now we are ready to check that everything you did was write.
So now we want to make a Metadata file. This will be simialr to the manifest except it contains actual sample info.
So basically you want the first column to be sampleID and you can copy over what you had from the manifest (sampleIDs have to be identical)
Then copy over the columns from our study list google sheet and you want to drag these down to fill out your metadata so we know these samples are from X country with Y disease and so on.

Save this file as a tab delimited text file named **<FirstAuthourSecondAuthorCountryMetadata>.txt** -- Remember excel will automatically add the .txt part
Move this metadata file to your study folder

## Step 5: generate visualizations using your metadata file

    qiime feature-table summarize \
    --i-table table_<FirstAuthorSecondAuthorCountry>.qza \
    --o-visualization <FirstAuthorSecondAuthorCountry>_table.qzv \
    --m-sample-metadata-file <FirstAuthorSecondAuthorCountry>Metadata.txt
