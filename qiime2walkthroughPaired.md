## activate linux

`wsl`

  

## update conda

`conda update conda`

  

## activate qiime

`conda activate qiime2-2023.2`

  

## make new directory

`mkdir [author name]`

  

## change directory

`cd gut-microbiome/[author name]`

  

## paste bash script for downloading fastq files (from SRA Explorer)

  

## generate file names for manifest

`ls -d "$PWD/"*`

Here you will need to find what differentiates the forward and reverses. If it is `1's` and `2's` then you you'll want to run `ls -d "$PWD/"*_1.fastq.gz` or something along those lines that combines the forwards and then `ls -d "$PWD/"*_2.fastq.gz` that combines the reverses.

  


## convert gz files to qza

    qiime tools import \
    --type 'SampleData[SequencesWithQuality]' \
    --input-path [author name]-manifest.txt \
    --output-path [author name]-paired-end-demux.qza \
    --input-format PairedEndFastqManifestPhred33V2

  

## generate demux visualization

    qiime demux summarize \
    --i-data [author name]-paired-end-demux.qza \
    --o-visualization [author name]-paired-end-demux.qzv
  

## upload demux visualization to qiime2 view

  

## check quality plot to ensure that quality does not drop off before 150 bases

  

## generate dada2 files

    qiime dada2 denoise-paired \
    --i-demultiplexed-seqs [author name]-paired-end-demux.qza \
    --p-trunc-len-f 150 \
    --p-trunc-len-r 150
    --p-trim-left-f 0 \
    --p-trim-left-r 0
    --o-representative-sequences rep-seqs.qza \
    --o-table table.qza \
    --o-denoising-stats stats.qza

  

## generate stats

`qiime metadata tabulate --m-input-file stats.qza --o-visualization [author name]-stats.qzv`

  

## generate visualizations

    qiime feature-table summarize \
    --i-table table.qza \
    --o-visualization [author name]-table.qzv \
    --m-sample-metadata-file [author name]-manifest.txt
    qiime feature-table tabulate-seqs \
    --i-data rep-seqs.qza \
    --o-visualization [author name]-rep-seqs.qzv