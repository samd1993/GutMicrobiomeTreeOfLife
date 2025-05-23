## activate linux (for Windows Users)

`wsl`

  

## update conda (if installing qiime2 for first time)

`conda update conda`

##install qiime2 version 2023.7

## activate qiime

`conda activate qiime2-2023.2`

  

## make new directory

`mkdir [author name]`

  

## change directory

`cd gut-microbiome/[author name]`

  

## paste bash script for downloading fastq files (from SRA Explorer)

  

## generate file names for manifest

`ls -d "$PWD/"*`

  


## convert gz files to qza

    qiime tools import \
    --type 'SampleData[SequencesWithQuality]' \
    --input-path [author name]-manifest.txt \
    --output-path [author name]-single-end-demux.qza \
    --input-format SingleEndFastqManifestPhred33V2

  

## generate demux visualization

    qiime demux summarize \
    --i-data [author name]-single-end-demux.qza \
    --o-visualization [author name]-single-end-demux.qzv
  

## upload demux visualization to qiime2 view

  

## check quality plot to ensure that quality does not drop off before 150 bases

  

## generate dada2 files

    qiime dada2 denoise-single \
    --i-demultiplexed-seqs [author name]-single-end-demux.qza \
    --p-trunc-len 150 \
    --p-trim-left 0 \
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
