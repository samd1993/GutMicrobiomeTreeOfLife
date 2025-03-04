## activate linux (for Windows Users)

`wsl`

## make sure miniconda is installed

## update conda (if installing qiime2 for first time--if installed skip to activate qiime2 step)

`conda update conda`

## install qiime2 version 2023.2 (skip if qiime2 installed)

## activate qiime2

`conda activate qiime2-2023.2`

  

## make new directory

`mkdir <authorLastnames>`

  

## change directory

`cd <authorLastnames>`

  

## paste bash script for downloading fastq files (from SRA Explorer) -- pick 30 samples if there are more than 30

  

## Step 1: generate file names for manifest

```ls -d "$PWD/"*```

  


## Step 2: convert gz files to qza
```
    qiime tools import \
    --type 'SampleData[SequencesWithQuality]' \
    --input-path <authorLastnames>_manifest.txt \
    --output-path <authorLastnames>_demux.qza \
    --input-format SingleEndFastqManifestPhred33V2
  ````
## Step 3: filter by quality scores

```
qiime quality-filter q-score \
 --i-demux <authorLastnames>_demux.qza \
 --o-filtered-sequences <authorLastnames>_demux_filtered.qza \
 --o-filter-stats demux-filter-stats.qza
 ```


## Step 4: run deblur (denoising step that runs quality control on all the sequences and trims them to same length)

```
qiime deblur denoise-16S \
  --i-demultiplexed-seqs <authorLastnames>_demux_filtered.qza \
  --p-trim-length 150 \
  --o-representative-sequences rep-seqs_<authorLastnames>.qza \
  --o-table table_<authorLastnames>.qza \
  --p-sample-stats \
  --o-stats deblur-stats<authorLastnames>.qza
```
  

## Step 5: generate visualizations

    qiime feature-table summarize \
    --i-table table_<authorLastnames>.qza \
    --o-visualization <authorLastnames>_table.qzv \
    --m-sample-metadata-file <authorLastnames>_manifest.txt
