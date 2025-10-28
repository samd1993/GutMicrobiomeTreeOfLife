srun --time=2:00:00 --partition=short --mem=24G -n 4 --pty bash -l 
zsh
conda activate qiime2-amplicon-2024.10

#download 16S data from qiita study ID: 11366 using qiita documentation for pulling studies
wget "https://qiita.ucsd.edu/public_download/?data=raw&study_id=11366&data_type=16S" -O "11366_16S_raw_data.zip"
unzip 11366_16S_raw_data.zip -q -d 11366_16S_raw_data

wget "https://qiita.ucsd.edu/public_download/?data=raw&study_id=15545&data_type=16S" -O "115545_16S_raw_data.zip"

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



