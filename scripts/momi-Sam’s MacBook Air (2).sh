srun --time=24:00:00 --partition=short --mem=100G -n 4 --pty bash -l 
zsh
conda activate qiime2-amplicon-2025.7

#download 16S data from qiita study ID: 11366 using qiita documentation for pulling studies
wget "https://qiita.ucsd.edu/public_download/?data=raw&study_id=11366&data_type=16S" -O "11366_16S_raw_data.zip"
unzip 11366_16S_raw_data.zip -q -d 11366_16S_raw_data

wget "https://qiita.ucsd.edu/public_download/?data=raw&study_id=15545&data_type=16S" -O "115545_16S_raw_data2.zip"

#now I want to import the 11366 study into qiime2 using EMP method so I need to rename Chambers1_416s_AlisonMV_7_8_16s_S1_L001_R2_001.fastq.gz to reverse.fastq.gz and Chambers1_416s_AlisonMV_7_8_16s_S1_L001_R1_001.fastq.gz to forward.fastq.gz and Chambers_Milk_Seed_5-8_S1_L001_I1_001.fastq to barcodes.fastq.gz 

mv Chambers1_416s_AlisonMV_7_8_16s_S1_L001_R2_001.fastq reverse.fastq.gz
mv Chambers_Milk_Seed_5-8_S1_L001_R2_001.fastq forward.fastq.gz
mv Chambers_Milk_Seed_5-8_S1_L001_I1_001.fastq barcodes.fastq.gz

#now run EMP import on folder 48202 
qiime tools import \
  --type EMPPairedEndSequences \
  --input-path 48202/ \
  --output-path US_emp_paired_end.qza

#now summarize table with USmomi_metadata.txt
qiime demux summarize \
  --i-data US_emp_paired_end.qza \
  --o-visualization US_emp_paired_end.qzv

  #download all raw data from study 11366
wget "https://qiita.ucsd.edu/public_download/?data=raw&study_id=11366" -O "11366_raw_data.zip"

#now import aus files using manifest method for single phred 33 fastq files
qiime tools import \
  --type 'SampleData[SequencesWithQuality]' \
  --input-path aus_manifest.txt \
  --output-path aus_single_end.qza \
  --input-format SingleEndFastqManifestPhred33V2

#now summarize aus data
qiime demux summarize \
  --i-data aus_single_end.qza \
  --o-visualization aus_single_end.qzv

#run denoise cc on aus single end qza do it for pacbio version

 --p-front "gcagtcgaacatgtagctgactcaggtcacAGRGTTY GATYMTGGCTCAG" \
  --p-adapter "tggatcacttgtgcaagcat cacatcgtagRGYTACCTTGTTACGACTT"

qiime dada2 denoise-ccs \
  --i-demultiplexed-seqs aus_single_end.qza \
  --p-front "gcagtcgaacatgtagctgactcaggtcacAGRGTTY" \
  --p-adapter "GATYMTGGCTCAG" \
  --p-n-threads 4 \
  --o-table aus_dada2_table.qza \
  --o-representative-sequences aus_dada2_rep_seqs.qza \
  --o-denoising-stats aus_dada2_stats.qza

#not working.. trying US import with 42033_mapping_file.txt and US_emp_paired_end.qza

qiime demux emp-paired \
  --m-barcodes-file 129920_mapping_file.txt \
  --m-barcodes-column barcode \
  --i-seqs US_emp_paired_end.qza \
  --o-per-sample-sequences US_emp_paired_end_demux.qza \
  --o-error-correction-details US_emp_paired_end_demux_stats.qza

qiime cutadapt demux-paired \
  --i-seqs US_emp_paired_end.qza \
  --m-forward-barcodes-file 129920_mapping_file.txt \
  --m-forward-barcodes-column barcode \
  --p-cores 4 \
  --o-per-sample-sequences US_emp_paired_end_demux.qza \
  --o-untrimmed-sequences US_emp_paired_end_demux_stats.qza



