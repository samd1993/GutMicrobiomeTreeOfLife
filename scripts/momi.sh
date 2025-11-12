srun --time=6:00:00 --partition=short --mem=64G -n 4 --pty bash -l 
zsh
conda activate qiime2-2023.7

srun --time=2:00:00 --partition=short --mem=64G -n 1  --cpus-per-task=4 --pty bash -l
zsh
conda activate qiime2-2023.7

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

  #also try importing as single end

qiime tools import \
  --type EMPSingleEndSequences \
  --input-path single \
  --output-path US_single_end.qza 

  #mv US_single_end.qza to momi/US folder
mv US_single_end.qza ~/momi/US/


#and now try to demux it  and set golay error to false
qiime demux emp-single \
  --m-barcodes-file 129920_mapping_file.txt \
  --m-barcodes-column barcode \
  --i-seqs US_single_end.qza \
  --o-per-sample-sequences US_single_end_demux.qza \
  --p-no-golay-error-correction \
  --o-error-correction-details US_single_end_demux_stats.qza

  #summarize demux
qiime demux summarize \
  --i-data US_single_end_demux.qza \
  --o-visualization US_single_end_demux.qzv

  #now run dada2 with 4 cores at 150 bp single end
qiime dada2 denoise-single \
  --i-demultiplexed-seqs US_single_end_demux.qza \
  --p-trunc-len 150 \
  --p-trim-left 0 \
  --p-n-threads 4 \
  --o-table US_dada2_table.qza \
  --o-representative-sequences US_dada2_rep_seqs.qza \
  --o-denoising-stats US_dada2_stats.qza





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
  --p-front "AGRGTTYGATYMTGGCTCAG" \
  --p-adapter "RGYTACCTTGTTACGACTT" \
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

#trying normal dada2 on the aus single end

qiime dada2 denoise-single \
  --i-demultiplexed-seqs ~/momi/aus/aus_single_end.qza \
  --p-trunc-len 900 \
  --p-trim-left 0 \
  --p-n-threads 16 \
  --o-table ~/momi/aus/aus_dada2_table900.qza \
  --o-representative-sequences ~/momi/aus/aus_dada2_rep_seqs900.qza \
  --o-denoising-stats ~/momi/aus/aus_dada2_stats900.qza

#now merge spain aus and US tables and output it to momi
qiime feature-table merge \
  --i-tables ~/momi/aus/aus_dada2_table900.qza \
  --i-tables ~/momi/US/US_dada2_table.qza \
  --i-tables ~/momi/spain/spain_table.qza \
  --o-merged-table ~/momi/merged_dada2_table.qza

  #and make a qzv of the merged table

qiime feature-table summarize \
  --i-table ~/momi/merged_dada2_table.qza \
  --o-visualization ~/momi/merged_dada2_table.qzv

#now import spain_seqs.fa to qza
qiime tools import \
  --type 'FeatureData[Sequence]' \
  --input-path ~/momi/spain/spain_seqs.fa \
  --output-path ~/momi/spain/spain_seqs.qza

#now merge spain seqs with aus and US rep seqs
qiime feature-table merge-seqs \
  --i-data ~/momi/aus/aus_dada2_rep_seqs900.qza \
  --i-data ~/momi/US/US_dada2_rep_seqs.qza \
  --i-data ~/momi/spain/spain_seqs.qza \
  --o-merged-data ~/momi/merged_dada2_rep_seqs.qza

  #and then filter table to match seqs
qiime feature-table filter-features \
  --i-table ~/momi/merged_dada2_table.qza \
  --m-metadata-file ~/momi/merged_dada2_rep_seqs.qza \
  --o-filtered-table ~/momi/merged_dada2_tablef.qza
#now do greengenes2 non V4 insertion using daniels tree #doing it locally btw

 qiime greengenes2 non-v4-16s \
   --i-table merged_dada2_tablef.qza \
    --i-sequences merged_dada2_rep_seqs.qza \
    --i-backbone 2024.09.backbone.full-length.fna.qza \
    --o-mapped-table tablegg2.qza \
    --o-representatives seqs_gg2.qza \
    --verbose

#not working so i am running this code: 
import os
os.environ['R_HOME'] = '/Users/samde/miniconda3/envs/qiime2-amplicon-2025.10/lib/R'

#on ~/momi I want to export the seqs and table and then reimport

qiime tools export \
  --input-path ~/momi/merged_dada2_rep_seqs.qza \
  --output-path ~/momi/exported_seqs

qiime tools export \
  --input-path ~/momi/merged_dada2_tablef.qza \
  --output-path ~/momi/exported_table

#now reimport the exported seqs and table
qiime tools import \
  --type 'FeatureData[Sequence]' \
  --input-path ~/momi/exported_seqs/dna-sequences.fasta \
  --output-path ~/momi/seqs2.qza

qiime tools import \
  --type 'FeatureTable[Frequency]' \
  --input-path ~/momi/exported_table/feature-table.biom \
  --output-path ~/momi/table2.qza

#filter the seqs to match table with filter seqs
qiime feature-table filter-seqs \
  --i-data ~/momi/seqs2.qza \
  --m-metadata-file ~/momi/table2.qza \
  --o-filtered-data ~/momi/seqs2_f.qza

#not working trying table2.qza against seqs2.qza
qiime feature-table filter-features \
  --i-table ~/momi/table2.qza \
  --m-metadata-file ~/momi/seqs2.qza \
  --o-filtered-table ~/momi/table2_f.qza

  #summarize table2_f.qza
qiime feature-table summarize \
  --i-table ~/momi/table2_f.qza \
  --o-visualization ~/momi/table2_f.qzv

  #now try filtering seqs again
qiime feature-table filter-seqs \
  --i-data ~/momi/seqs2.qza \
  --m-metadata-file ~/momi/table2_f.qza \
  --o-filtered-data ~/momi/seqs2_f.qza

  #now run greengenes2 non v4 insertion again
  qiime greengenes2 non-v4-16s \
    --i-table ~/momi/table2.qza \
      --i-sequences ~/momi/seqs2_f.qza \
      --i-backbone 2024.09.backbone.full-length.fna.qza \
      --o-mapped-table ~/momi/tablegg2.qza \
      --o-representatives ~/momi/seqs_gg2.qza \
      --verbose

      #doesnt work above
#inspect the fasta file from the exported seqs folder
head -20 ~/momi/exported_seqs/dna-sequences.fasta

#write me code to run an ls command but give the full paths of files that end in R1.fastq.gz and give the full PWD paths
ls $(pwd)/*R1.fastq.gz -1

#import spain fastqs with manifest single end
qiime tools import \
  --type 'SampleData[SequencesWithQuality]' \
  --input-path ~/momi/spain/spain_manisfest.txt \
  --output-path ~/momi/spain/spain_single_end.qza \
  --input-format SingleEndFastqManifestPhred33V2

  #ok now run dada2 at 150bp 
qiime dada2 denoise-single \
  --i-demultiplexed-seqs ~/momi/spain/spain_single_end.qza \
  --p-trunc-len 150 \
  --p-trim-left 0 \
  --p-n-threads 4 \
  --o-table ~/momi/spain/spain_table_dada2.qza \
  --o-representative-sequences ~/momi/spain/spain_seqs_dada2.qza \
  --o-denoising-stats ~/momi/spain/spain_stats_dada2.qza

#ok now merge this spain seqs and table with the other ones
qiime feature-table merge \
  --i-tables ~/momi/aus/aus_dada2_table900.qza \
  --i-tables ~/momi/US/US_dada2_table.qza \
  --i-tables ~/momi/spain/spain_table_dada2.qza \
  --o-merged-table ~/momi/merged_table_dada.qza

  #merge seqs too
qiime feature-table merge-seqs \
  --i-data ~/momi/aus/aus_dada2_rep_seqs900.qza \
  --i-data ~/momi/US/US_dada2_rep_seqs.qza \
  --i-data ~/momi/spain/spain_seqs_dada2.qza \
  --o-merged-data ~/momi/merged_seqs_dada.qza

  #now export these
qiime tools export \
  --input-path ~/momi/merged_seqs_dada.qza \
  --output-path ~/momi/exported_seqs_dada
qiime tools export \
  --input-path ~/momi/merged_table_dada.qza \
  --output-path ~/momi/exported_table_dada

#now import these back

qiime tools import \
  --type 'FeatureData[Sequence]' \
  --input-path ~/momi/exported_seqs_dada/dna-sequences.fasta \
  --output-path ~/momi/seqs2_dada2.qza

qiime tools import \
  --type 'FeatureTable[Frequency]' \
  --input-path ~/momi/exported_table_dada/feature-table.biom \
  --output-path ~/momi/table2_dada2.qza

  #now try greenegenes2 non v4 insertion again
  qiime greengenes2 non-v4-16s \
    --i-table ~/momi/table2_dada2.qza \
      --i-sequences ~/momi/seqs2_dada2.qza \
      --i-backbone 2024.09.backbone.full-length.fna.qza \
      --o-mapped-table ~/momi/tablegg2_dada2.qza \
      --o-representatives ~/momi/seqs_gg2_dada2.qza \
      --verbose

  #now run core metrics using merged_metadata2.txt and tablegg2_dada2.qza and daniel's tree

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny /home/mcdonadt/greengenes2/release/2024.09/2024.09.phylogeny.id.nwk.qza \
  --i-table ~/momi/tablegg2_dada2.qza \
  --p-sampling-depth 1000 \
  --p-n-jobs-or-threads 4 \
  --m-metadata-file ~/momi/merged_metadata2.txt \
  --output-dir ~/momi/core_metrics_results_dada2

#conda install bioconda::sepp
conda install bioconda::sepp
#ok now sepp insert the momi dataset into gg2 to get a sepp tree
qiime sepp insert-reads \
  --i-representative-sequences ~/momi/seqs_gg2_dada2.qza \
  --i-reference-database /home/mcdonadt/greengenes2/release/2024.09/2024.09.sepp.db.qza \
  --i-reference-tree /home/mcdonadt/greengenes2/release/2024.09/2024.09.sepp.tree.qza \
  --o-inserted-tree ~/momi/sepp_inserted_tree.qza \
  --o-placement-metadata ~/momi/sepp_placement_metadata.qza

#sepp script is in /home/sdegregori/miniconda3/envs/qiime2-2023.7/bin/run_sepp.py
#set the directory to a variable
SEPP_DIR="/home/sdegregori/miniconda3/envs/qiime2-2023.7/bin"
#see command options
python $SEPP_DIR/run_sepp.py --help

run_sepp.py -t mock/pyrg/sate.tre -r mock/pyrg/sate.tre.RAxML_info -a mock/pyrg/sate.fasta -f mock/pyrg/pyrg.even.fas

#transform above line for my data
python $SEPP_DIR/run_sepp.py -t /home/mcdonadt/greengenes2/release/2024.09/2024.09.phylogeny.id.nwk -a gg2_backbone_fasta/dna-sequences.fasta  -f ~/momi/exported_seqs_dada/dna-sequences.fasta

#export 2024.09.backbone.full-length.fna.qza to fasta
qiime tools export \
  --input-path 2024.09.backbone.full-length.fna.qza \
  --output-path ~/momi/gg2_backbone_fasta

#ok instead do qiime fragment-insertion sepp
qiime fragment-insertion sepp \
  --i-representative-sequences ~/momi/seqs2_dada2.qza \
  --i-reference-database ~/momi/sepp-refs-gg-13-8.qza \
  --o-placements ~/momi/sepp_placed_seqs.qza \
  --p-threads 16 \
  --o-tree ~/momi/sepp_tree.qza

  #cp dada2pac.sh to momi_sepp.sh
  cp ~/scripts/dada2pac.sh ~/scripts/momi_sepp.sh
  vim ~/scripts/momi_sepp.sh

  #now do coremetrics with sepp tree
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ~/momi/sepp_tree.qza \
  --i-table ~/momi/tablegg2_dada2.qza \
  --p-sampling-depth 1000 \
  --p-n-jobs-or-threads auto \
  --m-metadata-file ~/momi/merged_metadata2.txt \
  --output-dir ~/momi/core_metrics_results_sepp

#filter table to match sepp tree
qiime phylogeny filter-table \
  --i-table ~/momi/table2_dada2.qza \
  --i-tree ~/momi/sepp_tree.qza \
  --o-filtered-table ~/momi/table2_dada2.qza_sepp_f.qza

#now try core metrics with sepp filtered table
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ~/momi/sepp_tree.qza \
  --i-table ~/momi/table2_dada2.qza_sepp_f.qza \
  --p-sampling-depth 1000 \
  --p-n-jobs-or-threads auto \
  --m-metadata-file ~/momi/merged_metadata2.txt \
  --output-dir ~/momi/core_metrics_results_sepp_f

  #run qiime2 dada2 denoise ccs
qiime dada2 denoise-ccs \
  --i-demultiplexed-seqs ~/momi/aus/aus_single_end.qza \
  --p-front "AGRGTTYGATYMTGGCTCAG" \
  --p-adapter "RGYTACCTTGTTACGACTT" \
  --p-n-threads 1 \
  --o-table ~/momi/aus/aus_dada2_table_ccs.qza \
  --o-representative-sequences ~/momi/aus/aus_dada2_rep_seqs_ccs.qza \
  --o-denoising-stats ~/momi/aus/aus_dada2_stats_ccs.qza

#export aus_dada2_rep_seqs900.qza to fasta
qiime tools export \
  --input-path ~/momi/aus/aus_dada2_rep_seqs900.qza \
  --output-path ~/momi/aus/exported_aus_seqs900

  #I want to try an extract command on aus seq data

  qiime feature-classifier extract-reads  \
  --i-sequences aus_dada2_rep_seqs900.qza  \
  --p-f-primer GTGCCAGCMGCCGCGGTAA \
  --p-r-primer GGACTACHVGGGTWTCTAAT \
  --p-trunc-len 150 \
  --p-min-length 100 \
  --p-n-jobs 4 \
  --o-reads seq_aus_V4.qza

  #now merge these seqs with others and call it v4 merged
  qiime feature-table merge-seqs \
    --i-data ~/momi/aus/seq_aus_V4.qza \
    --i-data ~/momi/US/US_dada2_rep_seqs.qza \
    --i-data ~/momi/spain/spain_seqs_dada2.qza \
    --o-merged-data ~/momi/merged_seqs_dada_v4.qza

    #then sepp insert into gg2
    qiime fragment-insertion sepp \
      --i-representative-sequences ~/momi/merged_seqs_dada_v4.qza \
      --i-reference-database ~/momi/sepp-refs-gg-13-8.qza \
      --o-placements ~/momi/sepp_placed_seqs_v4.qza \
      --p-threads 4 \
      --o-tree ~/momi/sepp_tree_v4.qza


