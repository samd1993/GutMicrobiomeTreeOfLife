#!/bin/bash

qiime feature-table summarize \
--i-table TOLmerged.qza \
--m-sample-metadata-file TOLmetadata.txt \
--o-visualization TOLmerged.qzv

qiime feature-table filter-samples \
  --i-table TOLmerged.qza \
  --m-metadata-file TOLmetadata.txt \
  --o-filtered-table TOLmergedtable.qza

#so basically what I had to do was first copy and paste the metadata file to a VSC text file because of formatting BS and now I had to filter based on metadata (see below). Oh and I also had to remove duplicates in merged metadata excel sheet that Kaitlin sent. So keep note that for insects tons of duplicates were deleted and also there are a bunch of SRR samples that aren’t in metadata

qiime feature-table summarize \
--i-table TOLmergedtable.qza \
--m-sample-metadata-file TOLmetadata.txt \
--o-visualization TOLmergedtable.qzv




qiime feature-table merge-seqs \
    --i-data rep-seqs-dada-arizza.qza \
    --i-data rep-seqs-dada-colston.qza \
    --i-data rep-seqs-dada-delsuc.qza \
    --i-data rep-seqs-dada-erwin.qza \
    --i-data rep-seqs-dada-hakim.qza \
    --i-data rep-seqs-dada-kwong.qza \
    --i-data rep-seqs-dada-murphy.qza \
    --i-data rep-seqs-dada-Nasvall.qza \
    --i-data rep-seqs-dada-perofsky.qza \
    --i-data rep-seqs-dada-zoqratt.qza \
    --i-data rep-seqs-dada-parata.qza \
    --i-data rep-seqs-dada-sanders.qza \
    --i-data rep-seqs-dada-schwob.qza \
    --i-data rep-seqs-dada-suenami.qza \
    --i-data rep-seqs-dada-visnovska.qza \
    --i-data rep-seqs-dada-wang.qza \
    --o-merged-data TOLrep-seqs.qza

#studies that are found in GMTOL metadata:
# Hakim zoqratt suenami wang

    qiime feature-table filter-seqs \
        --i-data TOLrep-seqs.qza \
        --i-table TOLmergedtable.qza \
        --o-filtered-data TOLrep-seqsf.qza

qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences TOLrep-seqsf.qza \
  --o-alignment aligned-rep-seqs.qza \
  --o-masked-alignment masked-aligned-rep-seqs.qza \
  --o-tree unrooted-tree.qza \
  --o-rooted-tree TOLrooted-tree.qza


qiime diversity core-metrics-phylogenetic \
  --i-phylogeny TOLrooted-tree.qza \
  --i-table TOLmergedtable.qza \
  --p-sampling-depth 400 \
  --m-metadata-file TOLmetadata.txt \
  --output-dir TOLcore-metrics-results400pilot
  
  #table doesnt match phylogeny error

    qiime feature-table filter-features \
        --i-table TOLmergedtable.qza \
        --i-data TOLrep-seqsf.qza \
        --o-filtered-table TOLmergedtablef.qza

#above doesnt work..maybe try without filtered seqs

qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences TOLrep-seqs.qza \
  --o-alignment aligned-rep-seqs.qza \
  --o-masked-alignment masked-aligned-rep-seqs.qza \
  --o-tree unrooted-tree.qza \
  --o-rooted-tree TOLrooted-tree.qza

  qiime diversity core-metrics-phylogenetic \
  --i-phylogeny TOLrooted-tree.qza \
  --i-table TOLmergedtable.qza \
  --p-sampling-depth 400 \
  --m-metadata-file TOLmetadata2.txt \
  --output-dir TOLcore-metrics-results400pilot

  #Now trying to use this feature filter function to filter out feautres in table that arent in tree
###This one works
  qiime fragment-insertion filter-features \
  --i-table TOLmergedtable.qza \
  --i-tree TOLrooted-tree.qza \
  --o-filtered-table TOLtree-ftable.qza \
  --o-removed-table TOLremoved-table.qza

  qiime diversity core-metrics-phylogenetic \
  --i-phylogeny TOLrooted-tree.qza \
  --i-table TOLtree-ftable.qza \
  --p-sampling-depth 400 \
  --m-metadata-file TOLmetadata2.txt \
  --output-dir TOLcore-metrics-results400pilot

  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  combining new batch

qiime feature-table merge-seqs \
 --i-data dietrich-rep-seq-dada2.qza 	\
 --i-data dong-rep-seq-dada2.qza 	\
 --i-data fontaine-rep-seqs-dada2.qza 	\
 --i-data hernandez-rep-seqs-dada2.qza 	\
 --i-data jiang-rep-seqs-dada2.qza 	\
 --i-data keenan-rep-seqs-dada2.qza 	\
 --i-data price-rep-seqs-dada2.qza 	\
 --i-data sandri-rep-seqs-dada2.qza 	\
 --i-data wang-rep-seqs-dada2.qza 	\
 --i-data zhou-rep-seqs-dada2.qza 	\
 --o-merged-data TOLrepseqs-batch2.qza

#dont use fontaine jiang wang zhou

 qiime feature-table merge-seqs \
 --i-data repseq2/TOLrepseqs-batch2.qza \
 --i-data TOLrep-seqs.qza  \
 --o-merged-data TOLmerged-repseqs.qza

 qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences TOLmerged-repseqs.qza\
  --o-alignment aligned-rep-seqs2.qza \
  --o-masked-alignment masked-aligned-rep-seqs2.qza \
  --o-tree TOLmerged-unrooted-tree.qza \
  --o-rooted-tree TOLmerged-rooted-tree.qza

qiime feature-table merge \
 --i-tables dietrich-table-dada2.qza 	\
   dong-table-dada2.qza 	\
   fontaine-table-dada2.qza 	\
   hernandez-table-dada2.qza 	\
   jiang-table-dada2.qza 	\
   keenan-table-dada2.qza 	\
   price-table-dada2.qza 	\
   sandri-table-dada2.qza 	\
   wang-table-dada2.qza 	\
   zhou-table-dada2.qza 	\
  --o-merged-table TOLallmerged-table.qza

  qiime diversity core-metrics-phylogenetic \
  --i-phylogeny TOLmerged-rooted-tree.qza \
  --i-table TOLallmerged-tablef.qza \
  --p-sampling-depth 400 \
  --m-metadata-file TOLallmerged-metadata2.txt \
  --output-dir TOLallmerged-core-metrics-results400pilot

qiime feature-table filter-samples \
  --i-table TOLallmerged-table.qza \
  --m-metadata-file TOLallmerged-metadata2.txt \
  --o-filtered-table TOLallmerged-tablef.qza

  qiime feature-table summarize \
--i-table TOLallmerged-tablef.qza \
--m-sample-metadata-file TOLallmerged-metadata2.txt \
--o-visualization TOallmerged-tablef.qzv

#checking to see if above matches below pre and post filtering table to metadata


wget https://data.qiime2.org/distro/core/qiime2-2022.8-py38-linux-conda.yml
conda env create -n qiime2-2022.8 --file qiime2-2022.8-py38-linux-conda.yml

#accidentally altered the allmerged-rep-seqs.qza file from fish project so this one is other copy: 

qiime feature-table merge-seqs \
 --i-data TOLmerged-repseqs.qza	\
 --i-data allmergedrep-seqs.qza	\
 --o-merged-data allTOLmerged-repseqs.qza

qiime feature-table summarize \
  --i-table TOLallmerged-table.qza \
  --o-visualization TOLallmerged-table.qzv 



qiime feature-table summarize \
  --i-table TOLallmerged-tablef.qza \
  --o-visualization TOLallmerged-tablef.qzv 



qiime feature-table summarize \
  --i-table table-dada3-perofsky.qza \
  --o-visualization table-dada3-perofsky.qzv 

qiime feature-table merge \
 --i-tables  dietrich-table-dada2.qza \
 --i-tables  dong-table-dada2.qza \
 --i-tables  fontaine-table-dada2.qza \
 --i-tables  hernandez-table-dada2.qza \
 --i-tables  jiang-table-dada2.qza \
 --i-tables  keenan-table-dada2.qza \
 --i-tables  price-table-dada2.qza \
 --i-tables  sandri-table-dada2.qza \
 --i-tables  table-dada3-arizza.qza \
 --i-tables  table-dada3-colston.qza \
 --i-tables  table-dada3-delsuc.qza \
 --i-tables  table-dada3-erwin.qza \
 --i-tables  table-dada3-hakim.qza \
 --i-tables  table-dada3-kwong.qza \
 --i-tables  table-dada3-murphy.qza \
 --i-tables  table-dada3-Nasvall.qza \
 --i-tables  table-dada3-parata.qza \
 --i-tables  table-dada3-perofsky.qza \
 --i-tables  table-dada3-rojas.qza \
 --i-tables  table-dada3-sanders.qza \
 --i-tables  table-dada3-schwob.qza \
 --i-tables  table-dada3-suenami.qza \
 --i-tables  table-dada3-visnovska.qza \
 --i-tables  table-dada3-wang.qza \
 --i-tables  table-dada3-zoqratt.qza \
 --i-tables  wang-table-dada2.qza \
 --i-tables  zhou-table-dada2.qza \
 --o-merged-table allmerged-table2.qza

qiime feature-table summarize \
  --i-table alltables/allmerged-table2.qza \
  --o-visualization allmerged-table2.qzv 

qiime feature-table summarize \
  --i-table alltables/allmerged-table2.qza \
  --m-sample-metadata-file TOLallmerged-metadata2.txt \
  --o-visualization allmerged-table2m.qzv 

qiime feature-table filter-samples \
--i-table alltables/allmerged-table2.qza \
--m-metadata-file TOLallmerged-metadata2.txt \
--o-filtered-table alltables/allmerged-table2m.qza

qiime feature-table summarize \
  --i-table alltables/allmerged-table2m.qza \
  --m-sample-metadata-file TOLallmerged-metadata2.txt \
  --o-visualization alltables/allmerged-table2m2.qzv 

qiime fragment-insertion filter-features \
--i-table alltables/allmerged-table2m.qza \
--i-tree TOLmerged-rooted-tree.qza \
--o-filtered-table alltables/allmerged-table2mf.qza \
--o-removed-table allmergedremovedtable.qza

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny TOLmerged-rooted-tree.qza \
  --i-table alltables/allmerged-table2mf.qza \
  --p-sampling-depth 400 \
  --m-metadata-file TOLallmerged-metadata2.txt \
  --output-dir core-metrics-resultsTOLmergedf2

  qiime phylogeny align-to-tree-mafft-fasttree \
 --i-sequences allTOLmerged-repseqs.qza \
 --o-alignment allTOLaligned-rep-seqs.qza \
  --o-masked-alignment allTOLmasked-aligned-rep-seqs.qza \
  --o-tree allTOLunrooted-tree.qza \
  --o-rooted-tree allTOLrooted-tree.qza

  #Made a new metadata called allTOLmerged-metadata2.txt

qiime feature-table merge \
 --i-tables  allmergedtable.qza \
 --i-tables  alltables/allmerged-table2.qza  \
 --o-merged-table allTOLmerged-table2.qza

#doesnt work so now I am filtering out duplicate samples from the allTOLtable

qiime feature-table filter-samples \
  --i-table alltables/allmerged-table2.qza \
  --m-metadata-file samples-to-lose.txt \
  --p-exclude-ids \
  --o-filtered-table alltables/allmerged-table2-dupefiltered.qza

qiime feature-table merge \
 --i-tables  allmergedtable.qza \
 --i-tables  alltables/allmerged-table2-dupefiltered.qza  \
 --o-merged-table allTOLmerged-table2.qza  

qiime feature-table filter-samples \
--i-table allTOLmerged-table2.qza  \
--m-metadata-file allTOLmerged-metadata2f.txt \
--o-filtered-table allTOLmerged-table2m.qza 

qiime fragment-insertion filter-features \
--i-table allTOLmerged-table2m.qza \
--i-tree allTOLrooted-tree.qza \
--o-filtered-table allTOLmerged-table2mf.qza \
--o-removed-table allTOLmergedremovedtable.qza

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny allTOLrooted-tree.qza \
  --i-table allTOLmerged-table2mf.qza \
  --p-sampling-depth 400 \
  --m-metadata-file allTOLmerged-metadata2f.txt \
  --output-dir core-metrics-results-allTOL

  qiime diversity core-metrics-phylogenetic \
  --i-phylogeny allTOLrooted-tree.qza \
  --i-table allTOLmerged-table2mf.qza \
  --p-sampling-depth 400 \
  --m-metadata-file allTOLmerged-metadata2f.txt \
  --output-dir core-metrics-results-allTOL2


  qiime feature-table filter-samples \
  --i-table allTOLmerged-table2mf.qza\
  --m-metadata-file allTOLmerged-metadata2f.txt  \
  --p-where "[study] NOT IN ('Sanders_et_al', 'Hernandez_Garcia_et_al_2017','Keenan_et_al_2013')" \
  --o-filtered-table allTOLmerged-table2mf-primerf.qza

  qiime diversity core-metrics-phylogenetic \
  --i-phylogeny allTOLrooted-tree.qza \
  --i-table allTOLmerged-table2mf-primerf.qza \
  --p-sampling-depth 400 \
  --m-metadata-file allTOLmerged-metadata2f.txt \
  --output-dir core-metrics-results-allTOL2primerf

  #Now trying to instlal song et align

  wget https://qiita.ucsd.edu/public_download/?data=raw&study_id=4935&data_type=16S

 wget https://qiita.ucsd.edu/public_download/?data=biom&study_id=11166

#have to use quotes!

wget "https://qiita.ucsd.edu/public_download/?data=raw&study_id=11166" -O songetal11166_allraw.zip

##trying on undetermined files 
#(qiime2-2021.11) [sdegregori@surfingmantis 54385]$ mv Undetermined_S0_L001_R1_001.fastq.gz forward.fastq.gz
#(qiime2-2021.11) [sdegregori@surfingmantis 54385]$ mv Undetermined_S0_L001_R2_001.fastq.gz reverse.fastq.gz
#Had to add the I1 fastq file which has the barcodes..if it doesnt work its probably because I2 was missing?

qiime tools import \
  --type EMPPairedEndSequences \
  --input-path 54385 \
  --output-path 54385-paired-end-sequences.qza


  qiime demux emp-paired \
  --i-seqs 54385-paired-end-sequences.qza \
  --m-barcodes-file ../mapping_files/54385_mapping_file.txt \
  --m-barcodes-column barcode \
  --p-no-golay-error-correction \
  --o-per-sample-sequences demux54385.qza \
  --o-error-correction-details demux-details.qza

  qiime demux summarize \
  --i-data demux54385.qza \
  --o-visualization demux54385.qzv


  qiime tools export --input-path allTOLmerged-table2mf-primerf.qza --output-path ./  
  biom convert -i feature-table.biom -o allTOLmerged-table2mf-primerf.tsv --to-tsv 

  # convert tsv to biom html5

  

  7z e songetal11166-16S.zip -aos

cd SeJin

 mv *R1* forward.fastq.gz
 mv *R2* reverse.fastq.gz

 mv SeJin_Templeton_Lane1_S1_L001_I1_001.fastq.gz barcodes.fastq.gz

  qiime tools import \
  --type EMPPairedEndSequences \
  --input-path SeJin \
  --output-path SeJinS1paired-seqs.qza
  
  SeJin_Templeton_Lane1_S1_L001_R1_001.fastq.gz

#had to eddit the mapping file to only lane 1 samples and add missing header at end

qiime demux emp-paired \
  --i-seqs SeJinS1paired-seqs.qza \
  --m-barcodes-file mapping_files/55205_mapping_file_lane1.txt \
  --m-barcodes-column barcode \
  --p-no-golay-error-correction \
  --o-per-sample-sequences demux55205.qza \
  --o-error-correction-details demux-details55205.qza

qiime demux summarize \
 --i-data demux55205.qza \
 --o-visualization demux55205.qzv \
 --verbose

 qiime dada2 denoise-paired \
--i-demultiplexed-seqs demux55205.qza \
--p-trunc-len-f 230 \
--p-trunc-len-r 200 \
--p-trim-left-f 0 \
--p-trim-left-r 0 \
--p-n-threads 20 \
--o-representative-sequences rep-seqs-dada255205.qza \
--o-table table55205.qza \
--o-denoising-stats stats-dada255205.qza

qiime feature-table summarize \
 --i-table table55205.qza \
 --o-visualization table55205.qzv \
 --verbose

  qiime tools import \
  --type EMPPairedEndSequences \
  --input-path SeJinLane2 \
  --output-path SeJinS2paired-seqs.qza

  qiime demux emp-paired \
  --i-seqs SeJinS2paired-seqs.qza \
  --m-barcodes-file mapping_files/55205_mapping_file_lane2.txt \
  --m-barcodes-column barcode \
  --p-no-golay-error-correction \
  --o-per-sample-sequences demux55205_S2.qza \
  --o-error-correction-details demux-details55205_S2.qza

 mv *R1* forward.fastq.gz
 mv *R2* reverse.fastq.gz
 mv *I1* barcodes.fastq.gz

   qiime tools import \
  --type EMPPairedEndSequences \
  --input-path NZ \
  --output-path NZpaired-seqs.qza

    qiime demux emp-paired \
  --i-seqs NZpaired-seqs.qza \
  --m-barcodes-file mapping_files/55205_mapping_fileNZ.txt \
  --m-barcodes-column barcode \
  --p-no-golay-error-correction \
  --o-per-sample-sequences demux55205_NZ.qza \
  --o-error-correction-details demux-details55205_NZ.qza

qiime demux summarize \
 --i-data demux55205_NZ.qza \
 --o-visualization demux55205_NZ.qzv \
 --verbose

 qiime dada2 denoise-paired \
--i-demultiplexed-seqs demux55205_NZ.qza \
--p-trunc-len-f 175 \
--p-trunc-len-r 155 \
--p-trim-left-f 0 \
--p-trim-left-r 0 \
--p-n-threads 20 \
--o-representative-sequences rep-seqs-dada255205_NZ.qza \
--o-table table55205_NZ.qza \
--o-denoising-stats stats-dada255205_NZ.qza

qiime demux summarize \
 --i-data demux55205_S2.qza \
 --o-visualization demux55205_S2.qzv \
 --verbose

 qiime dada2 denoise-paired \
--i-demultiplexed-seqs demux55205_S2.qza \
--p-trunc-len-f 175 \
--p-trunc-len-r 155 \
--p-trim-left-f 0 \
--p-trim-left-r 0 \
--p-n-threads 20 \
--o-representative-sequences rep-seqs-dada255205_S2.qza \
--o-table table55205_S2.qza \
--o-denoising-stats stats-dada255205_S2.qza


mv *R1* forward.fastq.gz

 mv *I1* barcodes.fastq.gz

   qiime tools import \
  --type EMPSingleEndSequences \
  --input-path Gilbert001 \
  --output-path Gilbert001single-seqs.qza


   qiime tools import \
  --type EMPSingleEndSequences \
  --input-path Gilbert002 \
  --output-path Gilbert002single-seqs.qza


  qiime demux emp-single \
  --i-seqs Gilbert001single-seqs.qza \
  --m-barcodes-file mapping_files/56221_mapping_file_lane1.txt \
  --m-barcodes-column barcode \
  --p-no-golay-error-correction \
  --o-per-sample-sequences demuxGilbert001.qza \
 --o-error-correction-details demux-detailsGilbert001.qza

 mv *R1* forward.fastq.gz
 mv *R2* reverse.fastq.gz
 mv *I1* barcodes.fastq.gz

 qiime tools import \
  --type EMPPairedEndSequences \
  --input-path Undetermined_S0 \
  --output-path Undetermined_S0paired-seqs.qza


  qiime dada2 denoise-single \
--i-demultiplexed-seqs demuxGilbert001.qza \
--p-trunc-len 150 \
--p-trim-left 0 \
--p-n-threads 20 \
--o-representative-sequences rep-seqs-Gilbert001.qza \
--o-table tableGilbert001.qza \
--o-denoising-stats stats-dadaGilbert001.qza

qiime demux summarize \
 --i-data demuxGilbert001.qza \
--o-visualization demuxGilbert001.qzv \
 --verbose

qiime demux emp-paired \
  --i-seqs Undetermined_S0paired-seqs.qza \
  --m-barcodes-file mapping_files/82947_mapping_file.txt \
  --m-barcodes-column barcode \
  --p-no-golay-error-correction \
  --o-per-sample-sequences demuxUndetermined_S0.qza \
 --o-error-correction-details demux-details.qza


 qiime dada2 denoise-paired \
--i-demultiplexed-seqs demuxUndetermined_S0.qza \
--p-trunc-len-f 150 \
--p-trunc-len-r 150 \
--p-trim-left-f 0 \
--p-trim-left-r 0 \
--p-n-threads 20 \
--o-representative-sequences rep-seqs-dadaUndetermined_S0.qza \
--o-table tableUndetermined_S0.qza \
--o-denoising-stats stats-dadaUndetermined_S0.qza

mv *R1* sequences.fastq.gz
 
 mv *R3* barcodes.fastq.gz

 qiime tools import \
  --type EMPSingleEndSequences \
  --input-path Metcalf \
  --output-path Metcalfsingle-seqs.qza


qiime demux emp-single \
  --i-seqs Metcalfsingle-seqs.qza \
  --m-barcodes-file mapping_files/54434_mapping_file.txt \
  --m-barcodes-column barcode \
  --p-no-golay-error-correction \
  --o-per-sample-sequences demuxMetcalf.qza \
 --o-error-correction-details demux-detailsMetcalf.qza
  
 qiime dada2 denoise-single \
--i-demultiplexed-seqs demuxMetcalf.qza \
--p-trunc-len 100 \
--p-trim-left 0 \
--p-n-threads 20 \
--o-representative-sequences rep-seqs-Metcalf.qza \
--o-table tableMetcalf.qza \
--o-denoising-stats stats-dadaMetcalf.qza
  
  qiime demux summarize \
 --i-data demuxMetcalf.qza \
--o-visualization demuxMetcalf.qzv \
 --verbose


qiime feature-table merge \
 --i-tables  table55205_NZ.qza \
 --i-tables  table55205.qza \
 --i-tables  table55205_S2.qza \
 --i-tables  tableGilbert001.qza \
 --i-tables  tableUndetermined_S0.qza \
 --o-merged-table allmerged_songetal_table.qza


 qiime feature-table filter-samples \
--i-table allmerged_songetal_table.qza  \
--m-metadata-file songetal-metadata.txt \
--o-filtered-table allmerged_songetal_tablef.qza 

 qiime feature-table summarize \
 --i-table allmerged_songetal_tablef.qza \
 --m-sample-metadata-file songetal-metadata.txt \
--o-visualization allmerged_songetal_tablef.qzv \
 --verbose

 allTOLmerged-table2mf.qza 

 qiime feature-table merge \
 --i-tables   allTOLmerged-table2mf.qza  \
 --i-tables  songetal/16S/allmerged_songetal_tablef.qza \
 --o-merged-table allTOLsong_table.qza

 qiime feature-table merge-seqs \
 --i-data songetal/16S/rep-seqs-dada255205_NZ.qza 	\
 --i-data songetal/16S/rep-seqs-dadaUndetermined_S0.qza 	\
 --i-data songetal/16S/rep-seqs-dada255205.qza	\
 --i-data songetal/16S/rep-seqs-Gilbert001.qza 	\
 --i-data songetal/16S/rep-seqs-dada255205_S2.qza 	\
 --i-data allTOLmerged-repseqs.qza 	\
 --o-merged-data allTOLsong_repseqs.qza

 qiime phylogeny align-to-tree-mafft-fasttree \
  --p-n-threads 20 \
  --i-sequences allTOLsong_repseqs.qza \
  --o-alignment aligned-allTOLsongrep-seqs.qza \
  --o-masked-alignment masked-aligned-allTOLsongrep-seqs.qza \
  --o-tree allTOLsongunrooted-tree.qza \
  --o-rooted-tree allTOLsong_rooted_tree.qza

  #trying on barnacle as well

module load qiime2_2021.4
qiime phylogeny align-to-tree-mafft-fasttree \
  --p-n-threads 20 \
  --i-sequences TOL/allTOLsong_repseqs.qza \
  --o-alignment aligned-allTOLsongrep-seqs.qza \
  --o-masked-alignment masked-aligned-allTOLsongrep-seqs.qza \
  --o-tree allTOLsongunrooted-tree.qza \
  --o-rooted-tree allTOLsong_rooted_tree.qza

Submitted batch job 1064896 

seff 1064896


allTOLsong_rooted_tree.qza

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny allTOLsong_rooted_tree.qza \
  --i-table allTOLsong_table.qza \
  --p-sampling-depth 400 \
  --m-metadata-file allTOLmerged-metadata2fSong.txt \
  --output-dir core-metrics-results-allTOLSong400

  qiime diversity core-metrics-phylogenetic \
  --i-phylogeny allTOLsong_rooted_tree.qza \
  --i-table allTOLsong_table.qza \
  --p-sampling-depth 400 \
  --m-metadata-file allTOLmerged-metadata2fSongDiet.txt \
  --output-dir core-metrics-results-allTOLSong400Diet



  qiime feature-table merge \
 --i-tables  /studyfolder/study1table.qza \
 --i-tables  /studyfolder/study2table.qza \
 --i-tables  /studyfolder/study3table.qza \
 --i-tables  /studyfolder/study4table.qza \
 --i-tables  /studyfolder/study5table.qza \
 --o-merged-table <yourfullname>_merged_tables.qza

 qiime feature-table merge-seqs \
 --i-data /studyfolder/study1rep-seqs.qza 	\
 --i-data /studyfolder/study2rep-seqs.qza 	\
 --i-data /studyfolder/study3rep-seqs.qza	\
 --i-data /studyfolder/study4rep-seqs.qza 	\
 --i-data /studyfolder/study5rep-seqs.qza 	\
 --o-merged-data <yourfullname>_merged_repseqs.qza

 qiime feature-table group \
 --i-table study1table.qza \
 --p-axis sample \
 --m-metadata-file study1metadata.txt \
 --p-mode sum \
 --o-grouped-table study1_rename_table.qza


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#merging undergrad tables and repseqs

qiime feature-table merge \
  --i-tables AdamSahn_merged_tables.qza NoahSchulhof_merged_tables.qza dwang_merged_tables.qza AkhilKommala_merged_tables.qza NourTaqatqa_merged_tables.qza emmasmith_merged_tables.qza KotaSuzuki_merged_tables.qza SophiaJukovich_merged_tables.qza sonia_bhatia_merged_tables.qza \
  --o-merged-table UG2023_merged_tables.qza

 qiime feature-table merge-seqs \
--i-data AdamSahn_merged_repseqs.qza NoahSchulhof_merged_repseqs.qza dwang_merged_repseqs.qza AkhilKommala_merged_repseqs.qza NourTaqatqa_merged_repseqs.qza emmasmith_merged_repseqs.qza KotaSuzuki_merged_repseqs.qza SophiaJukovich_merged_repseqs.qza sonia_bhatia_merged_repseqs.qza \
--o-merged-data UG2023_merged_repseqs.qza


 qiime feature-table summarize \
 --i-table UG2023_merged_tables2.qza \
 --m-sample-metadata-file GMTOLmetadataUG6.tsv  \
--o-visualization UG2023_merged_tables2.qzv \
 --verbose

 qiime feature-table filter-samples \
  --i-table UG2023_merged_tables.qza \
  --m-metadata-file smith_delete.txt \
  --p-exclude-ids  \
  --o-filtered-table UG2023_merged_tables2.qza

 qiime feature-table merge-seqs \
--i-data UG2023_merged_repseqs.qza EmilyKelleher_merged_repseqs.qza evanolsdal_merged_repseqs.qza \
--o-merged-data UG2023_merged_repseqs3.qza

qiime feature-table merge \
--i-tables UG2023_merged_tables.qza EmilyKelleher_merged_tables.qza evanolsdal_merged_tables.qza \
--o-merged-table UG2023_merged_tables2.qza

qiime feature-table summarize \
 --i-table UG2023_merged_tables3.qza \
 --m-sample-metadata-file GMTOLmetadataUG6.tsv  \
--o-visualization UG2023_merged_tables3.qzv \
 --verbose

  qiime feature-table filter-samples \
  --i-table UG2023_merged_tables2.qza \
  --m-metadata-file wang_smith-crickets_delete.txt \
  --p-exclude-ids  \
  --o-filtered-table UG2023_merged_tables3_final.qza

  qiime feature-table summarize \
 --i-table UG2023_merged_tables3_final.qza \
 --m-sample-metadata-file GMTOLmetadata_UG2023_fixed.txt  \
--o-visualization UG2023_merged_tables3_finalfixed.qzv \
 --verbose


 qiime feature-table filter-samples \
  --i-table GMTOL_final_table.qza \
  --m-metadata-file GMTOL_final_metadata.txt \
  --p-where "[Class] IN ('Reptilia')" \
  --o-filtered-table Sophia_Reptilia_table.qza

  qiime feature-table filter-samples \
  --i-table GMTOL_final_table.qza \
  --m-metadata-file GMTOL_final_metadata.txt \
  --p-where "[Class] IN ('Actinopterygii' )" \
  --o-filtered-table Emily_Fish_table.qza

 qiime feature-table filter-samples \
  --i-table GMTOL_final_table.qza \
  --m-metadata-file GMTOL_final_metadata.txt \
  --p-where "[Class] IN ('Mammalia' )" \
  --o-filtered-table Sonia_Mammal_table.qza


 qiime feature-table filter-samples \
  --i-table GMTOL_final_table.qza \
  --m-metadata-file GMTOL_final_metadata.txt \
  --p-where "[Class] IN ('Insecta' )" \
  --o-filtered-table Noah_Insects_table.qza



for file in *.qza; do
    qiime quality-filter q-score \
    --i-demux "$file" \
    --o-filtered-sequences "filtered-Couch-paired-end-demux-filtered.qza \
    --o-filter-stats "filter-stats-Couch-paired-end-demux-filtered.qza \
    --verbose

    qiime deblur denoise-16S \
    --i-demultiplexed-seqs "filtered-Couch-paired-end-demux-filtered.qza \
    --p-trim-length 150 \
    --p-left-trim-len 0 \
    --o-representative-sequences "deblur_rep-seqs_Couch-paired-end-demux-filtered.qza \
    --o-table "deblur_table_${file%.qza}.qza" \
    --p-sample-stats \
    --verbose

    echo "Finishing deblur job"
done

srun --time=1:00:00 --partition=short --mem=64G -n 1 --pty bash -l 
srun --time=1:00:00 --partition=rocky9_test --mem=24G -n 1 --pty bash -l 


qiime feature-table summarize \
 --i-table deblur_table_lawson-paired-end-demux.qza \
--o-visualization deblur_table_lawson.qzv 

#writing script:

#!/bin/bash

# Input directory containing the QIIME 2 tables
input_directory="~/TOL/demux/filtered"

# Output table path
output_table="~/TOL/demux/filtered"

# Merge QIIME 2 tables
qiime feature-table merge \
    --i-tables $(find "$input_directory" -name "*.qza" | tr '\n' ',') \
    --o-merged-table "$output_table"



find ~/TOL/demux/filtered/ -name "*table*.qza" | tr '\n' ' '

qiime feature-table merge \
    --i-tables $(find ~/TOL/demux/filtered/ -name "deblur_table*.qza" | tr '\n' ' ') \
    --o-merged-table deblur_merged_table.qza

qiime feature-table merge \
 --i-tables deblur_table_abdelrhman-paired-end-demux.qza deblur_table_angelakis-paired-end-demux.qza deblur_table_bai-paired-end-demux.qza deblur_table_baldo-paired-end-demux.qza deblur_table_Barrionuevo-single-end-demux.qza deblur_table_berlow-paired-end-demux.qza deblur_table_budd-paired-end-demux.qza deblur_table_bunker-paired-end-demux.qza deblur_table_Burke-single-end-demux.qza deblur_table_campbell-paired-end-demux.qza deblur_table_chaerinkim-paired-end-demux.qza deblur_table_chen-demux.qza deblur_table_chen_single_demux.qza deblur_table_Chouaia-single-end-demux.qza deblur_table_cini-paired-end-demux.qza deblur_table_clever-paired-end-demux.qza deblur_table_cornejo-single-end-demux.qza deblur_table_danckert-paired-end-demux.qza deblur_table_demux-bornbusch-paired.qza deblur_table_demux-gonzalez-serrano-single.qza deblur_table_demux-wang-single.qza deblur_table_eliades-paired-end-demux.qza deblur_table_fontainebf-paired-end-demux.qza deblur_table_fontainegf-paired-end-demux.qza deblur_table_gaulke-single-end-demux.qza deblur_table_gillingham-paired-end-demux.qza deblur_table_gong-paired-end-demux.qza deblur_table_Griffin-paired-end-demux.qza deblur_table_guerrero_pairend_demux.qza deblur_table_haiyingzhong-paired-end-demux.qza deblur_table_he-paired-end-demux.qza deblur_table_herder-paired-end-demux.qza deblur_table_holt-paired-end-demux.qza deblur_table_Huyben-paired-end-demux.qza deblur_table_ibanez-single-end-demux.qza deblur_table_iwatsuki-paired-end-demux.qza deblur_table_jiang-single-end-demux.qza deblur_table_jones-single-end-demux.qza deblur_table_kaczmarczyk-paired-end-demux.qza deblur_table_keiz-paired-end-demux.qza deblur_table_kesnerova-paired-end-demux.qza deblur_table_klammsteiner-paired-end-demux.qza deblur_table_lavy-paired-end-demux.qza deblur_table_lawrence-paired-end-demux.qza deblur_table_lawson-paired-end-demux.qza deblur_table_le-paired-end-demux.qza deblur_table_lianchen-paired-end-demux.qza deblur_table_lihongzhou-single-end-demux.qza \
 --o-merged-table deblur_merged_table_up2linhong.qza

 #ok it didnt work so i cut in half and now this is part2

qiime feature-table merge \
--i-tables deblur_table_linzhang2-paired-end-demux.qza deblur_table_linzhang-paired-end-demux.qza deblur_table_li-paired-end-demux.qza deblur_table_li-single-end-demux.qza deblur_table_liu_pairend_demux.qza deblur_table_Liu-Tachypleus-tridentatus-paired-end-demux.qza deblur_table_lyu_pairend_demux.qza deblur_table_magagnoli_pairend_demux.qza deblur_table_Manor-paired-end-demux.qza deblur_table_ma-paired-end-demux.qza deblur_table_mason-paired-end-demux.qza deblur_table_mathai-paired-end-demux.qza deblur_table_mays_pairend_demux.qza deblur_table_McCauley-paired-end-demux.qza deblur_table_meriggi-paired-end-demux.qza deblur_table_miret-paired-end-demux.qza deblur_table_moeller_pairend_demux.qza deblur_table_monteiro-demux.qza deblur_table_montoya-single-end-demux.qza deblur_table_muhammad_single_demux.qza deblur_table_muturi-paired-end-demux.qza deblur_table_Nielsen-paired-end-demux.qza deblur_table_ning-paired-end-demux.qza deblur_table_nones-paired-end-demux.qza \
--o-merged-table deblur_merged_table_linz2up2nones.qza

#problem is in pan 2 suarez

qiime feature-table merge \
--i-tables deblur_table_Nyman-paired-end-demux.qza deblur_table_ojha-single-end-demux.qza deblur_table_pagan-jimenez-single-end-demux.qza deblur_table_paired-end-demux-haji.qza deblur_table_paired-end-demux-kang.qza deblur_table_paired-end-demux-phalnikar.qza deblur_table_paired-end-demux-pierce.qza deblur_table_paired-end-demux-rohrer.qza deblur_table_paired-end-demux-rubanov.qza deblur_table_paired-end-demux-tinker.qza deblur_table_paired-end-demux-wei.qza deblur_table_pan-paired-end-demux.qza \
--o-merged-table deblur_merged_table_nyman2pan.qza

#trying pardesi to suarez

qiime feature-table merge \
--i-tables deblur_table_Pardesi-paired-end-demux.qza deblur_table_parris-demux.qza deblur_table_Perry-paired-end-demux.qza deblur_table_pierce-paired-end-demux.qza deblur_table_pratte-demux.qza deblur_table_Rothenberg-paired-end-demux.qza deblur_table_santos-single-end-demux.qza deblur_table_sapkota-paired-end-demux.qza deblur_table_scalvenzi-paired-end-demux.qza deblur_table_Schaan-single-end-demux.qza deblur_table_schmidt-paired-end-demux.qza  \
--o-merged-table deblur_merged_table_pardesi2schmidt.qza

#problem is schmidt to suarez

qiime feature-table merge \
--i-tables deblur_table_segers-paired-end-demux.qza deblur_table_serrano_single_demux.qza deblur_table_sevellec-paired-end-demux.qza deblur_table_shelomi_pairend_demux.qza deblur_table_single-end-demux-campos.qza \
--o-merged-table deblur_merged_table_segers2campos.qza

qiime feature-table merge \
--i-tables deblur_table_single-end-demux-ooi.qza \
--i-tables deblur_table_single-end-demux-wasimuddin.qza \
--i-tables deblur_table_skrodenyte_single_end_demux.qza \
--i-tables deblur_table_Smith-demux.qza \
--i-tables deblur_table_smits_single_end_demux.qza \
--i-tables deblur_table_stoffel-demux.qza \
--i-tables deblur_table_suarez-moo-paired-end-demux.qza \
--o-merged-table deblur_merged_table_ooi2suarez.qza

qiime feature-table merge \
--i-tables deblur_table_single-end-demux-ooi.qza \
--i-tables deblur_table_single-end-demux-wasimuddin.qza \
--i-tables deblur_table_skrodenyte_single_end_demux.qza \
--o-merged-table deblur_merged_table_ooi2skrodenyte.qza

qiime feature-table merge \
--i-tables deblur_table_Smith-demux.qza \
--i-tables deblur_table_smits_single_end_demux.qza \
--o-merged-table deblur_merged_table_smith2smits.qza

#now trying suarez to rest 

qiime feature-table merge \
  --i-tables deblur_table_linzhang2-paired-end-demux.qza \
 --i-tables deblur_table_linzhang-paired-end-demux.qza \
 --i-tables deblur_table_li-paired-end-demux.qza \
 --i-tables deblur_table_li-single-end-demux.qza \
 --i-tables deblur_table_liu_pairend_demux.qza \
 --i-tables deblur_table_Liu-Tachypleus-tridentatus-paired-end-demux.qza \
 --i-tables deblur_table_lyu_pairend_demux.qza \
 --i-tables deblur_table_magagnoli_pairend_demux.qza \
 --i-tables deblur_table_Manor-paired-end-demux.qza \
 --i-tables deblur_table_ma-paired-end-demux.qza \
 --i-tables deblur_table_mason-paired-end-demux.qza \
 --i-tables deblur_table_mathai-paired-end-demux.qza \
 --i-tables deblur_table_mays_pairend_demux.qza \
 --i-tables deblur_table_McCauley-paired-end-demux.qza \
 --i-tables deblur_table_meriggi-paired-end-demux.qza \
 --i-tables deblur_table_miret-paired-end-demux.qza \
 --i-tables deblur_table_moeller_pairend_demux.qza \
 --i-tables deblur_table_monteiro-demux.qza \
 --i-tables deblur_table_montoya-single-end-demux.qza \
 --i-tables deblur_table_muhammad_single_demux.qza \
 --i-tables deblur_table_muturi-paired-end-demux.qza \
 --i-tables deblur_table_Nielsen-paired-end-demux.qza \
 --i-tables deblur_table_ning-paired-end-demux.qza \
 --i-tables deblur_table_nones-paired-end-demux.qza \
 --i-tables deblur_table_Nyman-paired-end-demux.qza \
 --i-tables deblur_table_ojha-single-end-demux.qza \
 --i-tables deblur_table_pagan-jimenez-single-end-demux.qza \
 --i-tables deblur_table_paired-end-demux-haji.qza \
 --i-tables deblur_table_paired-end-demux-kang.qza \
 --i-tables deblur_table_paired-end-demux-phalnikar.qza \
 --i-tables deblur_table_paired-end-demux-rohrer.qza \
 --i-tables deblur_table_paired-end-demux-rubanov.qza \
 --i-tables deblur_table_paired-end-demux-tinker.qza \
 --i-tables deblur_table_pan-paired-end-demux.qza \
 --i-tables deblur_table_Pardesi-paired-end-demux.qza \
 --i-tables deblur_table_parris-demux.qza \
 --i-tables deblur_table_Perry-paired-end-demux.qza \
 --i-tables deblur_table_pierce-paired-end-demux.qza \
 --i-tables deblur_table_pratte-demux.qza \
 --i-tables deblur_table_Rothenberg-paired-end-demux.qza \
 --i-tables deblur_table_santos-single-end-demux.qza \
 --i-tables deblur_table_sapkota-paired-end-demux.qza \
 --i-tables deblur_table_scalvenzi-paired-end-demux.qza \
 --i-tables deblur_table_Schaan-single-end-demux.qza \
 --i-tables deblur_table_schmidt-paired-end-demux.qza \
 --i-tables deblur_table_segers-paired-end-demux.qza \
 --i-tables deblur_table_serrano_single_demux.qza \
 --i-tables deblur_table_sevellec-paired-end-demux.qza \
 --i-tables deblur_table_shelomi_pairend_demux.qza \
 --i-tables deblur_table_single-end-demux-campos.qza \
 --i-tables deblur_table_single-end-demux-ooi.qza \
 --i-tables deblur_table_single-end-demux-wasimuddin.qza \
 --i-tables deblur_table_skrodenyte_single_end_demux.qza \
 --i-tables deblur_table_Smith-demux.qza \
 --i-tables deblur_table_smits_single_end_demux.qza \
 --i-tables deblur_table_stoffel-demux.qza \
 --i-tables deblur_table_suarez-moo-paired-end-demux.qza \
 --i-tables deblur_table_suenami-paired-end-demux.qza \
 --i-tables deblur_table_sylvain-single-end-demux.qza \
 --i-tables deblur_table_tang-demux.qza \
 --i-tables deblur_table_tang-paired-end-demux.qza \
 --i-tables deblur_table_Terova-paired-end-demux.qza \
 --i-tables deblur_table_tong-single-demux.qza \
 --i-tables deblur_table_trevelline-single-end-demux.qza \
 --i-tables deblur_table_vasco-single-end-demux.qza \
 --i-tables deblur_table_vasemagi-paired-end-demux.qza \
 --i-tables deblur_table_vejar_paired_end_demux.qza \
 --i-tables deblur_table_vernier-demux.qza \
 --i-tables deblur_table_videvall-single-end-demux.qza \
 --i-tables deblur_table_wagener-single-end-demux.qza \
 --i-tables deblur_table_walker-paired-end-demux.qza \
 --i-tables deblur_table_walter-paired-end-demux.qza \
 --i-tables deblur_table_Wang-Ctenopharyngodon-idella-single-end-demux.qza \
 --i-tables deblur_table_Wang-Haliotis-discus-paired-end-demux.qza \
 --i-tables deblur_table_wang-paired-end-demux.qza \
 --i-tables deblur_table_wang_pairend_demux.qza \
 --i-tables deblur_table_wei-single-end-demux.qza \
 --i-tables deblur_table_weyrich-single-end-demux.qza \
 --i-tables deblur_table_wiebler-single-end-demux.qza \
 --i-tables deblur_table_williams-paired-end-demux.qza \
 --i-tables deblur_table_wu-single-end-demux.qza \
 --i-tables deblur_table_xiao-paired-end-demux.qza \
 --i-tables deblur_table_xiaowenchen-paired-end-demux.qza \
 --i-tables deblur_table_yanez-montalvo-paired-demux.qza \
 --i-tables deblur_table_zhang-paired-end-demux.qza \
 --i-tables deblur_table_Zhang-Xu-paired-end-demux.qza \
 --i-tables deblur_table_zhirongzhang-paired-end-demux.qza \
 --i-tables deblur_table_zhong-paired-end-demux.qza \
 --i-tables deblur_table_zhu-paired-end-demux.qza \
 --i-tables deblur_table_zoqratt-paired-demux.qza \
 --i-tables deblur_table_zuo-single-end-demux.qza \
 --o-merged-table deblur_merged_table_linz2end.qza

qiime feature-table merge \
--i-tables deblur_table_stoffel-demux.qza \
--i-tables deblur_table_suarez-moo-paired-end-demux.qza \
 --o-merged-table deblur_merged_table_stoffel2suarez.qza

#list of bad studies

suarez
maltseva
li2021
humann2_ref_dataharer
gobet
fontaine

#pierce and wei are duplicates?

#here is final merged draft still missing couple stuidies


qiime feature-table merge \
--i-tables deblur_merged_table_linz2end.qza \
--i-tables deblur_merged_table_up2linhong.qza \
 --o-merged-table deblurFinal_merged_table.qza

  qiime feature-table summarize \
 --i-table deblurFinal_merged_table.qza \
--o-visualization deblurFinal_merged_table.qzv \
 --verbose



mv \
chevalier-paired-end-demux.qza \
Couch-paired-end-demux.qza \
demux-kim-paired.qza \
dewar-demux.qza \
escalas-paired-end-demux.qza \
fontaine-paired-end-demux.qza \
gobet-paired-end-demux.qza \
harer-single-end-demux.qza \
hu_b-single-end-demux.qza \
li2021_pairend_demux.qza \
maltseva-paired-end-demux.qza \
zhu_leafminers_a-paired-end-demux.qza \
zhu_leafminers_b-paired-end-demux.qza \
round2

for file in *.qza; do
    
    qiime quality-filter q-score \
    --i-demux chevalier-paired-end-demux.qza \
    --o-filtered-sequences filtered-Couch-paired-end-demux-filtered.qza \
    --o-filter-stats filter-stats-Couch-paired-end-demux-filtered.qza \
    --verbose

    qiime deblur denoise-16S \
    --i-demultiplexed-seqs "filtered-Couch-paired-end-demux-filtered.qza \
    --p-trim-length 150 \
    --p-left-trim-len 0 \
    --o-representative-sequences "deblur_rep-seqs_Couch-paired-end-demux-filtered.qza \
    --o-table "deblur_table_${file%.qza}.qza" \
    --p-sample-stats \
    --verbose

#now trying to see which sampleIDs are problematic

 qiime feature-table summarize \
 --i-table deblurFinal_merged_table.qza \
 --m-sample-metadata-file newmetadata_GMTOL_test.txt \
 --o-visualization deblurFinal_merged_table.qzv \
 --verbose



#losing deblur_table_angelakis

qiime feature-table filter-samples \
  --i-table deblurFinal_merged_table.qza \
  --m-metadata-file samples2lose.txt \
  --p-exclude-ids \
  --o-filtered-table deblurFinal_merged_table2.qza

qiime feature-table filter-samples \
  --i-table deblurFinal_merged_table.qza \
  --m-metadata-file smits.txt \
  --p-exclude-ids \
  --o-filtered-table deblurFinal_merged_table_2nosmits.qza

#importing hu_b
#the  below script runs as > bash import.sh sampleid=<sampleid prefix>
basically you will type

`vim import.sh`







    qiime tools import \
    --type 'SampleData[SequencesWithQuality]' \
    --input-path Hu-bmanifest.txt \
    --output-path Hu-b-paired-end-demux.qza \
    --input-format SingleEndFastqManifestPhred33V2

    qiime quality-filter q-score \
    --i-demux Hu-b-single-end-demux.
qza \
    --o-filtered-sequences filtered-Couch-paired-end-demux-filtered.qza \
    --o-filter-stats filter-stats-Couch-paired-end-demux-filtered.qza \
    --verbose

    qiime deblur denoise-16S \
    --i-demultiplexed-seqs "filtered-Couch-paired-end-demux-filtered.qza \
    --p-trim-length 150 \
    --p-left-trim-len 0 \
    --o-representative-sequences "deblur_rep-seqs_Couch-paired-end-demux-filtered.qza \
    --o-table "deblur_table_${file%.qza}.qza" \
    --p-sample-stats \
    --verbose

    #merging smits and fontaine

qiime feature-table merge \
--i-tables deblurFinal_merged_table_2nosmits.qza \
--i-tables ~/TOL/demux2/tables/smits-table.qza \
--i-tables ~/TOL/demux2/tables/fontaine-table-deblurred.qza \
 --o-merged-table deblurFinal_merged_table3.qza

 
 
  qiime feature-table summarize \
 --i-table deblurFinal_merged_table3.qza \
 --m-sample-metadata-file newmetadata_GMTOL_test.txt \
--o-visualization deblurFinal_merged_table3.qzv \
 --verbose

qiime feature-table filter-samples \
  --i-table deblurFinal_merged_table3.qza  \
  --m-metadata-file samples2lose.txt \
  --p-exclude-ids \
  --o-filtered-table deblurFinal_merged_table4.qza

qiime feature-table summarize \
 --i-table deblurFinal_merged_table4.qza \
 --m-sample-metadata-file newmetadata_GMTOL_test.txt \
--o-visualization deblurFinal_merged_table4.qzv \
 --verbose


     qiime tools import \
    --type 'SampleData[SequencesWithQuality]' \
    --input-path zhu-leafminers-amanifest.txt \
    --output-path zhu-leafminers-single-end-demux.qza \
    --input-format SingleEndFastqManifestPhred33V2

         qiime tools import \
    --type 'SampleData[SequencesWithQuality]' \
    --input-path tinker-mantismanifest.txt \
    --output-path tinker-mantis-single-end-demux.qza \
    --input-format SingleEndFastqManifestPhred33V2

    qiime tools import \
    --type 'SampleData[SequencesWithQuality]' \
    --input-path li-scallopmanifest.txt \
    --output-path li-scallop-single-end-demux.qza \
    --input-format SingleEndFastqManifestPhred33V2

      qiime tools import \
    --type 'SampleData[SequencesWithQuality]' \
    --input-path maltsevamanifest.txt  \
    --output-path maltseva-gastopoda-single-end-demux.qza \
    --input-format SingleEndFastqManifestPhred33V2


qiime feature-table merge \
--i-tables demux/filtered/deblur_table_dewar.qza \
--i-tables deblurFinal_merged_table4.qza \
 --o-merged-table deblurFinal_merged_table5.qza

 
  qiime feature-table summarize \
 --i-table deblurFinal_merged_table5.qza \
 --m-sample-metadata-file newmetadata_GMTOL_test.txt \
--o-visualization deblurFinal_merged_table5.qzv \
 --verbose

#dewar works

qiime quality-filter q-score \
    --i-demux tinker-mantis-single-end-demux.qza \
    --o-filtered-sequences filtered/filtered-tinker-mantis.qza \
    --o-filter-stats filtered/filter-stats-tinker-mantis.qza

qiime deblur denoise-16S \
    --i-demultiplexed-seqs filtered/filtered-tinker-mantis.qza \
    --p-trim-length 150 \
    --p-left-trim-len 0 \
    --o-representative-sequences filtered/deblur_rep_seqs_tinker-mantis.qza \
    --o-table filtered/deblur_table_tinker-mantis.qza \
    --o-stats filtered/deblur-stats-tinker-mantis.qza


      qiime tools import \
    --type 'SampleData[SequencesWithQuality]' \
    --input-path Fontainemanifest.txt  \
    --output-path Fontaine-single-end-demux.qza \
    --input-format SingleEndFastqManifestPhred33V2

#fixing deblur.sh had to fix a slash that wasnt highlighted yellow

qiime quality-filter q-score \
 --i-demux "$filename" \
 --o-filtered-sequences filtered/filtered-"$filename" \
 --o-filter-stats filtered/filter-stats-"$filename"
# Run Qiime2 Deblur with 150bp sequence length
qiime deblur denoise-16S \
 --i-demultiplexed-seqs filtered/filtered-"$filename" \
 --p-trim-length 150 \
 --p-left-trim-len 0 \
 --o-representative-sequences filtered/deblur_rep_seqs"$filename" \
 --o-table filtered/deblur_table_"$filename" \
 --o-stats filtered/deblur-stats"$filename"

echo "Qiime2 Deblur analysis completed successfully."

qiime feature-table merge \
--i-tables demux/round2/filtered/escalas-table-deblur.qza \
--i-tables deblurFinal_merged_table5.qza \
 --o-merged-table deblurFinal_merged_table6.qza

 
  qiime feature-table summarize \
 --i-table deblurFinal_merged_table6.qza \
 --m-sample-metadata-file newmetadata_GMTOL_test.txt \
--o-visualization deblurFinal_merged_table6.qzv \
 --verbose

 qiime deblur denoise-16S \
 --i-demultiplexed-seqs filtered/filtered-maltseva-gastopoda-single-end-demux.qza \
 --p-trim-length 150 \
 --p-left-trim-len 0 \
 --p-jobs-to-start 4 \
 --o-representative-sequences filtered/deblur_rep_seqsmaltseva-gastopoda.qza \
 --o-table filtered/deblur_table_maltseva-gastopoda.qza \
 --o-stats filtered/deblur-statsmaltseva-gastopoda.qza

#get rid of old Fonatine1-30
qiime feature-table filter-samples \
  --i-table deblurFinal_merged_table6.qza \
  --m-metadata-file Fontaine-filter.txt \
  --p-exclude-ids \
  --o-filtered-table deblurFinal_merged_table7.qza

qiime feature-table merge \
--i-tables demux/round2/filtered/deblur_table_Fontaine-single-end-demux.qza \
--i-tables demux/round2/filtered/deblur_table_Hu-b-single-end-demux.qza \
--i-tables demux/round2/filtered/deblur_table_li-scallop-single-end-demux.qza \
--i-tables demux/round2/filtered/deblur_table_tinker-mantis.qza \
--i-tables deblurFinal_merged_table7.qza \
 --o-merged-table deblurFinal_merged_table8.qza

 
  qiime feature-table summarize \
 --i-table deblurFinal_merged_table8.qza \
 --m-sample-metadata-file newmetadata_GMTOL_test.txt \
--o-visualization deblurFinal_merged_table8.qzv \
 --verbose

qiime feature-table merge \
--i-tables demux/round2/filtered/deblur_table_maltseva-gastopoda.qza \
--i-tables deblurFinal_merged_table8.qza \
 --o-merged-table deblurFinal_merged_table9.qza

 
  qiime feature-table summarize \
 --i-table deblurFinal_merged_table9.qza \
 --m-sample-metadata-file newmetadata_GMTOL_test.txt \
--o-visualization deblurFinal_merged_table9.qzv \
 --verbose


    qiime tools import \
    --type 'SampleData[SequencesWithQuality]' \
    --input-path Harermanifest.txt \
    --output-path Harer-single-demux.qza \
    --input-format SingleEndFastqManifestPhred33V2

#writing script for next batch of demuxes. 

#!/bin/bash

#BATCH -J TOL
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samdegregori@gmail.com
#SBATCH -N 1
#SBATCH -n 64
#SBATCH --mem=1000G
#SBATCH -t 3-00
#SBATCH -p highmem
#SBATCH --output=output.log
#SBATCH --array=0-26%64

source ~/.zshrc
module purge all
conda activate qiime2-2023.2

cd ~/TOL/demux/human

files=(*.qza)    
file=${files[$SLURM_ARRAY_TASK_ID]}

for file in *.qza; do
    qiime quality-filter q-score \
    --i-demux "{$file}" \
    --o-filtered-sequences "filtered/filtered-${file}" \
    --o-filter-stats "filtered/filter-stats-${file}" 

    qiime deblur denoise-16S \
    --i-demultiplexed-seqs "filtered/filtered-${file}" \
    --p-trim-length 150 \
    --p-left-trim-len 0 \
    --o-representative-sequences "filtered/deblur_rep-seqs_${file}" \
    --o-table "filtered/deblur_table_${file}" \
    --o-stats "filtered/deblur_stats_${file}" \
    --p-sample-stats \
    --p-jobs-to-start 64

    mv {$file} ../humandump

done
echo "finishing job"

demux/humandump/deblur_table_Chakraborty-poligraphus2
qiime feature-table merge \
--i-tables demux/human/filtered/deblur_table_Chakraborty-acuminatus-paired-end-demux.qza \
--i-tables demux/human/filtered/deblur_table_Chakraborty-cembrae-paired-end-demux.qza \
--i-tables deblurFinal_merged_table9.qza \
--o-merged-table deblurFinal_merged_table10.qza

--i-tables demux/human/filtered/deblur_table_Chakraborty-duplicatus-paired-end-demux.qza \
--i-tables demux/human/filtered/deblur_table_Chakraborty-sexdentatus-paired-end-demux.qza \
--i-tables demux/human/filtered/deblur_table_Chakraborty-typographus-paired-end-demux.qza \

--i-tables demux/human/filtered/deblur_table_Tang-Crocodilurus-paired-end-demux.qza \
--i-tables demux/human/filtered/deblur_table_Wasimuddin-paired-end-demux.qza \
--i-tables demux/human/filtered/deblur_table_Wei-trituberculatus-single-end-demux.qza \
--i-tables demux/human/filtered/deblur_table_Weng-single-end-demux.qza \
--i-tables demux/human/filtered/deblur_table_Cock-paired-end-demux.qza \
--i-tables demux/human/filtered/deblur_table_Hakim-purpuratus-paired-end-demux.qza \
--i-tables demux/human/filtered/deblur_table_Harer-single-demux.qza \

--i-tables demux/human/filtered/deblur_table_Hoang-paired-end-demux.qza \
--i-tables demux/human/filtered/deblur_table_Lim-paired-end-demux.qza \
--i-tables demux/human/filtered/deblur_table_Li-noctilio-paired-end-demux.qza \
--i-tables demux/human/filtered/deblur_table_Liu-dorsalis-paired-end-demux.qza \


--i-tables demux/human/filtered/deblur_table_Zhou-single-end-demux.qza \


--i-tables demux/human/filtered/deblur_table_Chakraborty-poligraphus-paired-end-demux.qza \
--i-tables demux/human/filtered/deblur_table_Jeon-paired-end-demux.qza \

#these worked once?
--i-tables demux/human/filtered/deblur_table_Pires-paired-end-demux.qza \
--i-tables demux/human/filtered/deblur_table_Plummer-paired-end-demux.qza \
--i-tables demux/human/filtered/deblur_table_Sapkota-flavipes-paired-end-demux.qza \
--i-tables demux/human/filtered/deblur_table_Sehli-paired-end-demux.qza \
--i-tables demux/human/filtered/deblur_table_Shi1-paired-end-demux.qza \
--i-tables demux/human/filtered/deblur_table_Shi2-paired-end-demux.qza \
--i-tables demux/human/filtered/deblur_table_Silva-paired-end-demux.qza \

#this works after redo:
demux/humandump/deblur_table_Chakraborty-poligraphus2.qza

qiime quality-filter q-score \
    --i-demux demux/humandump/Chakraborty-poligraphus-paired-end-demux.qza \
    --o-filtered-sequences demux/humandump/filtered-Chakraborty-poligraphus2.qza \
    --o-filter-stats demux/humandump/filter-stats-Chakraborty-poligraphus2.qza

qiime deblur denoise-16S \
    --i-demultiplexed-seqs demux/humandump/filtered-Chakraborty-poligraphus2.qza \
    --p-trim-length 150 \
    --p-left-trim-len 0 \
    --o-representative-sequences demux/humandump/deblur_rep_seqs_Chakraborty-poligraphus2.qza \
    --o-table demux/humandump/deblur_table_Chakraborty-poligraphus2.qza \
    --o-stats demux/humandump/deblur-stats-Chakraborty-poligraphus2.qza \
    --p-jobs-to-start 64

qiime feature-table merge \
--i-tables demux/humandump/filtered/deblur_table_Chakraborty-acuminatus-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Chakraborty-cembrae-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Chakraborty-duplicatus-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Chakraborty-poligraphus-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Chakraborty-sexdentatus-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Chakraborty-typographus-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Cock-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Hakim-purpuratus-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Harer-single-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Hoang-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Jeon-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Lim-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Li-noctilio-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Liu-dorsalis-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Pires-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Plummer-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Sapkota-flavipes-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Sehli-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Shi1-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Shi2-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Silva-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Wasimuddin-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Wei-trituberculatus-single-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Weng-single-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Zhou-single-end-demux.qza \
--i-tables deblurFinal_merged_table9.qza \
--o-merged-table deblurFinal_merged_table10.qza 

--i-tables demux/humandump/filtered/deblur_table_Tang-Crocodilurus-paired-end-demux.qza \
--i-tables demux/humandump/filtered/deblur_table_Chakraborty-poligraphus2.qza \

  qiime feature-table summarize \
 --i-table deblurFinal_merged_table10.qza \
 --m-sample-metadata-file newmetadata_GMTOL_test.txt \
--o-visualization deblurFinal_merged_table10.qzv \
 --verbose

 #combining seqs

qiime feature-table merge-seqs \
--i-data deblur_rep-seqs_abdelrhman-paired-end-demux.qza \ 
--i-data deblur_rep-seqs_angelakis-paired-end-demux.qza \
--i-data deblur_rep-seqs_bai-paired-end-demux.qza \
--i-data deblur_rep-seqs_baldo-paired-end-demux.qza \
--i-data deblur_rep-seqs_Barrionuevo-single-end-demux.qza \
--i-data deblur_rep-seqs_berlow-paired-end-demux.qza \
--i-data deblur_rep-seqs_budd-paired-end-demux.qza \
--i-data deblur_rep-seqs_bunker-paired-end-demux.qza \

qiime feature-table merge-seqs \
--i-data deblur_rep-seqs_Burke-single-end-demux.qza \
--i-data deblur_rep-seqs_campbell-paired-end-demux.qza \
--i-data deblur_rep-seqs_chaerinkim-paired-end-demux.qza \
--i-data deblur_rep-seqs_Chakraborty-acuminatus-paired-end-demux.qza \
--i-data deblur_rep-seqs_Chakraborty-cembrae-paired-end-demux.qza \
--i-data deblur_rep-seqs_Chakraborty-duplicatus-paired-end-demux.qza \
--i-data deblur_rep-seqs_Chakraborty-poligraphus-paired-end-demux.qza \
--i-data deblur_rep-seqs_Chakraborty-sexdentatus-paired-end-demux.qza \
--i-data deblur_rep-seqs_Chakraborty-typographus-paired-end-demux.qza \
--i-data deblur_rep-seqs_chen-demux.qza \
--i-data deblur_rep-seqs_chen_single_demux.qza \
--i-data deblur_rep-seqs_Chouaia-single-end-demux.qza \
--i-data deblur_rep-seqs_cini-paired-end-demux.qza \
--i-data deblur_rep-seqs_clever-paired-end-demux.qza \
--i-data deblur_rep-seqs_Cock-paired-end-demux.qza \
--i-data deblur_rep-seqs_cornejo-single-end-demux.qza \
--i-data deblur_rep-seqs_danckert-paired-end-demux.qza \
--i-data deblur_rep-seqs_demux-bornbusch-paired.qza \
--i-data deblur_rep-seqs_demux-gonzález-serrano-single.qza \
--i-data deblur_rep-seqs_demux-wang-single.qza \
--i-data deblur_rep_seqs_dewar-rep-seqs.qza \
--i-data deblur_repseqs_dewar-rep-seqs.qza \
--i-data deblur_rep-seqs_eliades-paired-end-demux.qza \
--i-data deblur_rep-seqs_fontainebf-paired-end-demux.qza \
--i-data deblur_rep-seqs_fontainegf-paired-end-demux.qza \
--i-data deblur_rep_seqsFontaine-single-end-demux.qza \
--i-data deblur_rep-seqs_gaulke-single-end-demux.qza \
--i-data deblur_rep-seqs_gillingham-paired-end-demux.qza \
--i-data deblur_repseqs_gobet.qza \
--i-data deblur_rep-seqs_gong-paired-end-demux.qza \
--i-data deblur_rep-seqs_Griffin-paired-end-demux.qza \
--i-data deblur_rep-seqs_guerrero_pairend_demux.qza \
--i-data deblur_rep-seqs_haiyingzhong-paired-end-demux.qza \
--i-data deblur_rep-seqs_Hakim-purpuratus-paired-end-demux.qza \
--i-data deblur_rep-seqs_Harer-single-demux.qza \
--i-data deblur_rep-seqs_he-paired-end-demux.qza \
--i-data deblur_rep-seqs_herder-paired-end-demux.qza \
--i-data deblur_rep-seqs_Hoang-paired-end-demux.qza \
--i-data deblur_rep-seqs_holt-paired-end-demux.qza \
--i-data deblur_rep_seqsHu-b-single-end-demux.qza \
--i-data deblur_rep-seqs_Huyben-paired-end-demux.qza \
--i-data deblur_rep-seqs_ibanez-single-end-demux.qza \
--i-data deblur_rep-seqs_iwatsuki-paired-end-demux.qza \
--i-data deblur_rep-seqs_Jeon-paired-end-demux.qza \
--i-data deblur_rep-seqs_jiang-single-end-demux.qza \
--i-data deblur_rep-seqs_jones-single-end-demux.qza \
--i-data deblur_rep-seqs_kaczmarczyk-paired-end-demux.qza \
--i-data deblur_rep-seqs_keiz-paired-end-demux.qza \
--i-data deblur_rep-seqs_kesnerova-paired-end-demux.qza \
--i-data deblur_rep-seqs_klammsteiner-paired-end-demux.qza \
--o-merged-data repseqs_1_burke2klamm.qza

qiime feature-table merge-seqs \
--i-data deblur_rep-seqs_lavy-paired-end-demux.qza \
--i-data deblur_rep-seqs_lawrence-paired-end-demux.qza \
--i-data deblur_rep-seqs_lawson-paired-end-demux.qza \
--i-data deblur_rep-seqs_le-paired-end-demux.qza \
--i-data deblur_rep-seqs_lianchen-paired-end-demux.qza \
--i-data deblur_rep-seqs_lihongzhou-single-end-demux.qza \
--i-data deblur_rep-seqs_Lim-paired-end-demux.qza \
--i-data deblur_rep-seqs_Li-noctilio-paired-end-demux.qza \
--i-data deblur_rep-seqs_linzhangII-paired-end-demux.qza \
--i-data deblur_rep-seqs_linzhang-paired-end-demux.qza \
--i-data deblur_rep-seqs_li-paired-end-demux.qza \
--i-data deblur_rep_seqsli-scallop-single-end-demux.qza \
--i-data deblur_rep-seqs_li-single-end-demux.qza \
--i-data deblur_rep-seqs_Liu-dorsalis-paired-end-demux.qza \
--i-data deblur_rep-seqs_liu_pairend_demux.qza \
--i-data deblur_rep-seqs_lyu_pairend_demux.qza \
--i-data deblur_rep-seqs_Liu-Tachypleus-tridentatus-paired-end-demux.qza \
--i-data deblur_rep-seqs_magagnoli_pairend_demux.qza \
--i-data deblur_rep_seqsmaltseva-gastopoda.qza \
--i-data deblur_rep-seqs_Manor-paired-end-demux.qza \
--i-data deblur_rep-seqs_ma-paired-end-demux.qza \
--i-data deblur_rep-seqs_mason-paired-end-demux.qza \
--i-data deblur_rep-seqs_mathai-paired-end-demux.qza \
--i-data deblur_rep-seqs_mays_pairend_demux.qza \
--i-data deblur_rep-seqs_McCauley-paired-end-demux.qza \
--i-data deblur_rep-seqs_meriggi-paired-end-demux.qza \
--i-data deblur_rep-seqs_miret-paired-end-demux.qza \
--i-data deblur_rep-seqs_moeller_pairend_demux.qza \
--i-data deblur_rep-seqs_monteiro-demux.qza \
--i-data deblur_rep-seqs_montoya-single-end-demux.qza \
--i-data deblur_rep-seqs_muhammad_single_demux.qza \
--i-data deblur_rep-seqs_muturi-paired-end-demux.qza \
--i-data deblur_rep-seqs_Nielsen-paired-end-demux.qza \
--i-data deblur_rep-seqs_ning-paired-end-demux.qza \
--i-data deblur_rep-seqs_nones-paired-end-demux.qza \
--i-data deblur_rep-seqs_Nyman-paired-end-demux.qza \
--i-data deblur_rep-seqs_ojha-single-end-demux.qza \
--i-data deblur_rep-seqs_pagan-jimenez-single-end-demux.qza \
--i-data deblur_rep-seqs_paired-end-demux-haji.qza \
--i-data deblur_rep-seqs_paired-end-demux-kang.qza \
--i-data deblur_rep-seqs_paired-end-demux-phalnikar.qza \
--i-data deblur_rep-seqs_paired-end-demux-pierce.qza \
--i-data deblur_rep-seqs_paired-end-demux-rohrer.qza \
--i-data deblur_rep-seqs_paired-end-demux-rubanov.qza \
--i-data deblur_rep-seqs_paired-end-demux-wei.qza \
--i-data deblur_rep-seqs_pan-paired-end-demux.qza \
--i-data deblur_rep-seqs_Pardesi-paired-end-demux.qza \
--i-data deblur_rep-seqs_parris-demux.qza \
--i-data deblur_rep-seqs_Perry-paired-end-demux.qza \
--i-data deblur_rep-seqs_pierce-paired-end-demux.qza \
--i-data deblur_rep-seqs_Pires-paired-end-demux.qza \
--i-data deblur_rep-seqs_Plummer-paired-end-demux.qza \
--i-data deblur_rep-seqs_pratte-demux.qza \
--i-data deblur_rep-seqs_Rothenberg-paired-end-demux.qza \
--i-data deblur_rep-seqs_santos-single-end-demux.qza \
--i-data deblur_rep-seqs_Sapkota-flavipes-paired-end-demux.qza \
--i-data deblur_rep-seqs_sapkota-paired-end-demux.qza \
--i-data deblur_rep-seqs_scalvenzi-paired-end-demux.qza \
--i-data deblur_rep-seqs_Schaan-single-end-demux.qza \
--i-data deblur_rep-seqs_schmidt-paired-end-demux.qza \
--i-data deblur_rep-seqs_segers-paired-end-demux.qza \
--i-data deblur_rep-seqs_Sehli-paired-end-demux.qza \
--i-data deblur_rep-seqs_serrano_single_demux.qza \
--i-data deblur_rep-seqs_sevellec-paired-end-demux.qza \
--i-data deblur_rep-seqs_shelomi_pairend_demux.qza \
--i-data deblur_rep-seqs_Shi1-paired-end-demux.qza \
--i-data deblur_rep-seqs_Shi2-paired-end-demux.qza \
--i-data deblur_rep-seqs_Silva-paired-end-demux.qza \
--i-data deblur_rep-seqs_single-end-demux-campos.qza \
--i-data deblur_rep-seqs_single-end-demux-ooi.qza \
--i-data deblur_rep-seqs_single-end-demux-wasimuddin.qza \
--i-data deblur_rep-seqs_skrodenyte_single_end_demux.qza \
--i-data deblur_rep-seqs_Smith-demux.qza \
--i-data deblur_rep-seqs_smits_single_end_demux.qza \
--i-data deblur_rep-seqs_stoffel-demux.qza \
--i-data deblur_rep-seqs_suarez-moo-paired-end-demux.qza \
--i-data deblur_rep-seqs_suenami-paired-end-demux.qza \
--i-data deblur_rep-seqs_sylvain-single-end-demux.qza \
--i-data deblur_rep-seqs_Tang-Crocodilurus-paired-end-demux.qza \
--i-data deblur_rep-seqs_tang-demux.qza \
--i-data deblur_rep-seqs_tang-paired-end-demux.qza \
--i-data deblur_rep-seqs_Terova-paired-end-demux.qza \
--i-data deblur_rep_seqs_tinker-mantis.qza \
--i-data deblur_rep-seqs_tong-single-demux.qza \
--i-data deblur_rep-seqs_trevelline-single-end-demux.qza \
--i-data deblur_rep-seqs_vasco-single-end-demux.qza \
--i-data deblur_rep-seqs_vasemagi-paired-end-demux.qza \
--i-data deblur_rep-seqs_vejar_paired_end_demux.qza \
--i-data deblur_rep-seqs_vernier-demux.qza \
--i-data deblur_rep-seqs_videvall-single-end-demux.qza \
--i-data deblur_rep-seqs_wagener-single-end-demux.qza \
--i-data deblur_rep-seqs_walker-paired-end-demux.qza \
--i-data deblur_rep-seqs_walter-paired-end-demux.qza \
--i-data deblur_rep-seqs_Wang-Ctenopharyngodon-idella-single-end-demux.qza \
--i-data deblur_rep-seqs_Wang-Haliotis-discus-paired-end-demux.qza \
--i-data deblur_rep-seqs_wang-paired-end-demux.qza \
--i-data deblur_rep-seqs_wang_pairend_demux.qza \
--i-data deblur_rep-seqs_Wasimuddin-paired-end-demux.qza \
--i-data deblur_rep-seqs_wei-single-end-demux.qza \
--i-data deblur_rep-seqs_Wei-trituberculatus-single-end-demux.qza \
--i-data deblur_rep-seqs_Weng-single-end-demux.qza \
--i-data deblur_rep-seqs_weyrich-single-end-demux.qza \
--i-data deblur_rep-seqs_wiebler-single-end-demux.qza \
--i-data deblur_rep-seqs_williams-paired-end-demux.qza \
--i-data deblur_rep-seqs_wu-single-end-demux.qza \
--i-data deblur_rep-seqs_xiao-paired-end-demux.qza \
--i-data deblur_rep-seqs_xiaowenchen-paired-end-demux.qza \
--i-data deblur_rep-seqs_yanez-montalvo-paired-demux.qza \
--i-data deblur_rep-seqs_zhang-paired-end-demux.qza \
--i-data deblur_rep-seqs_Zhang-Xu-paired-end-demux.qza \
--i-data deblur_rep-seqs_zhirongzhang-paired-end-demux.qza \
--i-data deblur_rep-seqs_Zhou-single-end-demux.qza \
--i-data deblur_rep-seqs_zhu-paired-end-demux.qza \
--i-data deblur_rep-seqs_zoqratt-paired-demux.qza \
--i-data deblur_rep-seqs_zuo-single-end-demux.qza \
--o-merged-data repseqs_2.qza

--o-merged-data GMTOL_merged_repseqs_may27.qza

qiime quality-filter q-score \
    --i-demux budd-paired-end-demux.qza \
    --o-filtered-sequences filtered/filtered-budd.qza \
    --o-filter-stats filtered/filter-stats-budd.qza

qiime deblur denoise-16S \
    --i-demultiplexed-seqs filtered/filtered-budd.qza \
    --p-trim-length 150 \
    --p-left-trim-len 0 \
    --o-representative-sequences filtered/deblur_rep_seqs_budd.qza \
    --o-table filtered/deblur_table_budd.qza \
    --o-stats filtered/deblur-stats-budd.qza

qiime feature-table merge-seqs \
--i-data deblur_rep-seqs_abdelrhman-paired-end-demux.qza \
--i-data deblur_rep-seqs_angelakis-paired-end-demux.qza \
--i-data deblur_rep-seqs_bai-paired-end-demux.qza \
--i-data deblur_rep-seqs_baldo-paired-end-demux.qza \
--i-data deblur_rep-seqs_Barrionuevo-single-end-demux.qza \
--i-data deblur_rep-seqs_berlow-paired-end-demux.qza \
--i-data deblur_rep_seqs_budd.qza \
--i-data deblur_rep-seqs_bunker-paired-end-demux.qza \
--i-data deblur_rep-seqs_Burke-single-end-demux.qza \
--i-data deblur_rep-seqs_campbell-paired-end-demux.qza \
--i-data deblur_rep-seqs_chaerinkim-paired-end-demux.qza \
--i-data deblur_rep-seqs_Chakraborty-acuminatus-paired-end-demux.qza \
--i-data deblur_rep-seqs_Chakraborty-cembrae-paired-end-demux.qza \
--i-data deblur_rep-seqs_Chakraborty-duplicatus-paired-end-demux.qza \
--i-data deblur_rep-seqs_Chakraborty-poligraphus-paired-end-demux.qza \
--i-data deblur_rep-seqs_Chakraborty-sexdentatus-paired-end-demux.qza \
--i-data deblur_rep-seqs_Chakraborty-typographus-paired-end-demux.qza \
--i-data deblur_rep-seqs_chen-demux.qza \
--i-data deblur_rep-seqs_chen_single_demux.qza \
--i-data deblur_rep-seqs_Chouaia-single-end-demux.qza \
--i-data deblur_rep-seqs_cini-paired-end-demux.qza \
--i-data deblur_rep-seqs_clever-paired-end-demux.qza \
--i-data deblur_rep-seqs_Cock-paired-end-demux.qza \
--i-data deblur_rep-seqs_cornejo-single-end-demux.qza \
--i-data deblur_rep-seqs_danckert-paired-end-demux.qza \
--i-data deblur_rep-seqs_demux-bornbusch-paired.qza \
--i-data deblur_rep-seqs_demux-gonzález-serrano-single.qza \
--i-data deblur_rep-seqs_demux-wang-single.qza \
--i-data deblur_rep_seqs_dewar-rep-seqs.qza \
--i-data deblur_repseqs_dewar-rep-seqs.qza \
--i-data deblur_rep-seqs_eliades-paired-end-demux.qza \
--i-data deblur_rep-seqs_fontainebf-paired-end-demux.qza \
--i-data deblur_rep-seqs_fontainegf-paired-end-demux.qza \
--i-data deblur_rep_seqsFontaine-single-end-demux.qza \
--i-data deblur_rep-seqs_gaulke-single-end-demux.qza \
--i-data deblur_rep-seqs_gillingham-paired-end-demux.qza \
--i-data deblur_repseqs_gobet.qza \
--i-data deblur_rep-seqs_gong-paired-end-demux.qza \
--i-data deblur_rep-seqs_Griffin-paired-end-demux.qza \
--i-data deblur_rep-seqs_guerrero_pairend_demux.qza \
--i-data deblur_rep-seqs_haiyingzhong-paired-end-demux.qza \
--i-data deblur_rep-seqs_Hakim-purpuratus-paired-end-demux.qza \
--i-data deblur_rep-seqs_Harer-single-demux.qza \
--i-data deblur_rep-seqs_he-paired-end-demux.qza \
--i-data deblur_rep-seqs_herder-paired-end-demux.qza \
--i-data deblur_rep-seqs_Hoang-paired-end-demux.qza \
--i-data deblur_rep-seqs_holt-paired-end-demux.qza \
--i-data deblur_rep_seqsHu-b-single-end-demux.qza \
--i-data deblur_rep-seqs_Huyben-paired-end-demux.qza \
--i-data deblur_rep-seqs_ibanez-single-end-demux.qza \
--i-data deblur_rep-seqs_iwatsuki-paired-end-demux.qza \
--i-data deblur_rep-seqs_Jeon-paired-end-demux.qza \
--i-data deblur_rep-seqs_jiang-single-end-demux.qza \
--i-data deblur_rep-seqs_jones-single-end-demux.qza \
--i-data deblur_rep-seqs_kaczmarczyk-paired-end-demux.qza \
--i-data deblur_rep-seqs_keiz-paired-end-demux.qza \
--i-data deblur_rep-seqs_kesnerova-paired-end-demux.qza \
--i-data deblur_rep-seqs_klammsteiner-paired-end-demux.qza \
--i-data deblur_rep-seqs_lavy-paired-end-demux.qza \
--i-data deblur_rep-seqs_lawrence-paired-end-demux.qza \
--i-data deblur_rep-seqs_lawson-paired-end-demux.qza \
--i-data deblur_rep-seqs_le-paired-end-demux.qza \
--i-data deblur_rep-seqs_lianchen-paired-end-demux.qza \
--i-data deblur_rep-seqs_lihongzhou-single-end-demux.qza \
--i-data deblur_rep-seqs_Lim-paired-end-demux.qza \
--i-data deblur_rep-seqs_Li-noctilio-paired-end-demux.qza \
--i-data deblur_rep-seqs_linzhangII-paired-end-demux.qza \
--i-data deblur_rep-seqs_linzhang-paired-end-demux.qza \
--i-data deblur_rep-seqs_li-paired-end-demux.qza \
--i-data deblur_rep_seqsli-scallop-single-end-demux.qza \
--i-data deblur_rep-seqs_li-single-end-demux.qza \
--i-data deblur_rep-seqs_Liu-dorsalis-paired-end-demux.qza \
--i-data deblur_rep-seqs_liu_pairend_demux.qza \
--i-data deblur_rep-seqs_Liu-Tachypleus-tridentatus-paired-end-demux.qza \
--i-data deblur_rep-seqs_lyu_pairend_demux.qza \
--i-data deblur_rep-seqs_magagnoli_pairend_demux.qza \
--i-data deblur_rep_seqsmaltseva-gastopoda.qza \
--i-data deblur_rep-seqs_Manor-paired-end-demux.qza \
--i-data deblur_rep-seqs_ma-paired-end-demux.qza \
--i-data deblur_rep-seqs_mason-paired-end-demux.qza \
--i-data deblur_rep-seqs_mathai-paired-end-demux.qza \
--i-data deblur_rep-seqs_mays_pairend_demux.qza \
--i-data deblur_rep-seqs_McCauley-paired-end-demux.qza \
--i-data deblur_rep-seqs_meriggi-paired-end-demux.qza \
--i-data deblur_rep-seqs_miret-paired-end-demux.qza \
--i-data deblur_rep-seqs_moeller_pairend_demux.qza \
--i-data deblur_rep-seqs_monteiro-demux.qza \
--i-data deblur_rep-seqs_montoya-single-end-demux.qza \
--i-data deblur_rep-seqs_muhammad_single_demux.qza \
--i-data deblur_rep-seqs_muturi-paired-end-demux.qza \
--i-data deblur_rep-seqs_Nielsen-paired-end-demux.qza \
--i-data deblur_rep-seqs_ning-paired-end-demux.qza \
--i-data deblur_rep-seqs_nones-paired-end-demux.qza \
--i-data deblur_rep-seqs_Nyman-paired-end-demux.qza \
--i-data deblur_rep-seqs_ojha-single-end-demux.qza \
--i-data deblur_rep-seqs_pagan-jimenez-single-end-demux.qza \
--i-data deblur_rep-seqs_paired-end-demux-haji.qza \
--i-data deblur_rep-seqs_paired-end-demux-kang.qza \
--i-data deblur_rep-seqs_paired-end-demux-phalnikar.qza \
--i-data deblur_rep-seqs_paired-end-demux-pierce.qza \
--i-data deblur_rep-seqs_paired-end-demux-rohrer.qza \
--i-data deblur_rep-seqs_paired-end-demux-rubanov.qza \
--i-data deblur_rep-seqs_paired-end-demux-wei.qza \
--i-data deblur_rep-seqs_pan-paired-end-demux.qza \
--i-data deblur_rep-seqs_Pardesi-paired-end-demux.qza \
--i-data deblur_rep-seqs_parris-demux.qza \
--i-data deblur_rep-seqs_Perry-paired-end-demux.qza \
--i-data deblur_rep-seqs_pierce-paired-end-demux.qza \
--i-data deblur_rep-seqs_Pires-paired-end-demux.qza \
--i-data deblur_rep-seqs_Plummer-paired-end-demux.qza \
--i-data deblur_rep-seqs_pratte-demux.qza \
--i-data deblur_rep-seqs_Rothenberg-paired-end-demux.qza \
--i-data deblur_rep-seqs_santos-single-end-demux.qza \
--i-data deblur_rep-seqs_Sapkota-flavipes-paired-end-demux.qza \
--i-data deblur_rep-seqs_sapkota-paired-end-demux.qza \
--i-data deblur_rep-seqs_scalvenzi-paired-end-demux.qza \
--i-data deblur_rep-seqs_Schaan-single-end-demux.qza \
--i-data deblur_rep-seqs_schmidt-paired-end-demux.qza \
--i-data deblur_rep-seqs_segers-paired-end-demux.qza \
--i-data deblur_rep-seqs_Sehli-paired-end-demux.qza \
--i-data deblur_rep-seqs_serrano_single_demux.qza \
--i-data deblur_rep-seqs_sevellec-paired-end-demux.qza \
--i-data deblur_rep-seqs_shelomi_pairend_demux.qza \
--i-data deblur_rep-seqs_Shi1-paired-end-demux.qza \
--i-data deblur_rep-seqs_Shi2-paired-end-demux.qza \
--i-data deblur_rep-seqs_Silva-paired-end-demux.qza \
--i-data deblur_rep-seqs_single-end-demux-campos.qza \
--i-data deblur_rep-seqs_single-end-demux-ooi.qza \
--i-data deblur_rep-seqs_single-end-demux-wasimuddin.qza \
--i-data deblur_rep-seqs_skrodenyte_single_end_demux.qza \
--i-data deblur_rep-seqs_Smith-demux.qza \
--i-data deblur_rep-seqs_smits_single_end_demux.qza \
--i-data deblur_rep-seqs_stoffel-demux.qza \
--i-data deblur_rep-seqs_suarez-moo-paired-end-demux.qza \
--i-data deblur_rep-seqs_suenami-paired-end-demux.qza \
--i-data deblur_rep-seqs_sylvain-single-end-demux.qza \
--i-data deblur_rep-seqs_Tang-Crocodilurus-paired-end-demux.qza \
--i-data deblur_rep-seqs_tang-demux.qza \
--i-data deblur_rep-seqs_tang-paired-end-demux.qza \
--i-data deblur_rep-seqs_Terova-paired-end-demux.qza \
--i-data deblur_rep_seqs_tinker-mantis.qza \
--i-data deblur_rep-seqs_tong-single-demux.qza \
--i-data deblur_rep-seqs_trevelline-single-end-demux.qza \
--i-data deblur_rep-seqs_vasco-single-end-demux.qza \
--i-data deblur_rep-seqs_vasemagi-paired-end-demux.qza \
--i-data deblur_rep-seqs_vejar_paired_end_demux.qza \
--i-data deblur_rep-seqs_vernier-demux.qza \
--i-data deblur_rep-seqs_videvall-single-end-demux.qza \
--i-data deblur_rep-seqs_wagener-single-end-demux.qza \
--i-data deblur_rep-seqs_walker-paired-end-demux.qza \
--i-data deblur_rep-seqs_walter-paired-end-demux.qza \
--i-data deblur_rep-seqs_Wang-Ctenopharyngodon-idella-single-end-demux.qza \
--i-data deblur_rep-seqs_Wang-Haliotis-discus-paired-end-demux.qza \
--i-data deblur_rep-seqs_wang-paired-end-demux.qza \
--i-data deblur_rep-seqs_wang_pairend_demux.qza \
--i-data deblur_rep-seqs_Wasimuddin-paired-end-demux.qza \
--i-data deblur_rep-seqs_wei-single-end-demux.qza \
--i-data deblur_rep-seqs_Wei-trituberculatus-single-end-demux.qza \
--i-data deblur_rep-seqs_Weng-single-end-demux.qza \
--i-data deblur_rep-seqs_weyrich-single-end-demux.qza \
--i-data deblur_rep-seqs_wiebler-single-end-demux.qza \
--i-data deblur_rep-seqs_williams-paired-end-demux.qza \
--i-data deblur_rep-seqs_wu-single-end-demux.qza \
--i-data deblur_rep-seqs_xiao-paired-end-demux.qza \
--i-data deblur_rep-seqs_xiaowenchen-paired-end-demux.qza \
--i-data deblur_rep-seqs_yanez-montalvo-paired-demux.qza \
--i-data deblur_rep-seqs_zhang-paired-end-demux.qza \
--i-data deblur_rep-seqs_Zhang-Xu-paired-end-demux.qza \
--i-data deblur_rep-seqs_zhirongzhang-paired-end-demux.qza \
--i-data deblur_rep-seqs_Zhou-single-end-demux.qza \
--i-data deblur_rep-seqs_zhu-paired-end-demux.qza \
--i-data deblur_rep-seqs_zoqratt-paired-demux.qza \
--i-data deblur_rep-seqs_zuo-single-end-demux.qza \
--i-data ../../../deblur_rep-seqs_zhong-paired-end-demux.qza \
--o-merged-data GMTOL_merged_repseqs_May28.qza


qiime diversity core-metrics-phylogenetic \
  --i-phylogeny GMTOL_rooted_treeMay28.qza \
  --i-table deblurFinal_merged_table10.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file newmetadata_GMTOL_test.txt \
  --output-dir core-metrics-results-GMTOL_deblur

     qiime feature-table filter-seqs \
        --i-data GMTOL_merged_repseqs_May28.qza \
        --i-table deblurFinal_merged_table10.qza  \
        --o-filtered-data GMTOL_merged_repseqs_May28f.qza

 qiime diversity core-metrics-phylogenetic \
  --i-phylogeny GMTOL_rooted_treeMay28f.qza \
  --i-table deblurFinal_merged_table10.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file newmetadata_GMTOL_test.txt \
  --output-dir core-metrics-results-GMTOL_deblur

 qiime feature-table filter-samples \
  --i-table deblurFinal_merged_table10.qza   \
  --m-metadata-file newmetadata_GMTOL_test.txt \
  --p-where "[Class] IN ('Reptilia')" \
  --o-filtered-table Sophia_Reptilia_tableMay30.qza

  qiime feature-table filter-samples \
  --i-table deblurFinal_merged_table10.qza   \
  --m-metadata-file newmetadata_GMTOL_test.txt \
  --p-where "[Class] IN ('Actinopterygii')" \
  --o-filtered-table Emma_Fish_tableMay30.qza

 qiime feature-table filter-samples \
  --i-table deblurFinal_merged_table10.qza   \
  --m-metadata-file newmetadata_GMTOL_test.txt \
  --p-where "[Class] IN ('Aves')" \
  --o-filtered-table Emma_Aves_tableMay30.qza 


 qiime feature-table filter-samples \
  --i-table deblurFinal_merged_table10.qza   \
  --m-metadata-file newmetadata_GMTOL_test.txt \
  --p-where "[Genus] IN ('Homo')" \
  --o-filtered-table Noor_Humans_tableMay30.qza 

   qiime feature-table filter-samples \
  --i-table deblurFinal_merged_table10.qza   \
  --m-metadata-file newmetadata_GMTOL_test.txt \
  --p-where "[Class] IN ('Insecta')" \
  --o-filtered-table Noah_Insecta_tableMay30.qza


GMTOL_merged_repseqs_May28.qza

qiime feature-classifier classify-sklearn \
  --i-classifier ~/Downloads/gg_2022_10_backbone.v4.nb.qza \
  --i-reads GMTOL_merged_repseqs_May28.qza\
  --p-n-jobs -1 \
  --o-classification taxonomy.qza

qiime feature-table merge \
    --i-tables $(find -name "deblur_table*.qza" | tr '\n'\\ ' ') \
    --o-merged-table merged_table_Jun2_GMTOL.qza

    qiime tools import \
    --type 'SampleData[SequencesWithQuality]' \
    --input-path Pierce-Crassostrea-Virginicamanifest.txt \
    --output-path Pierce-Crassostrea-single-demux.qza \
    --input-format SingleEndFastqManifestPhred33V2

qiime quality-filter q-score \
    --i-demux Pierce-Crassostrea-single-demux.qza \
    --o-filtered-sequences filtered-Pierce-Crassostrea.qza \
    --o-filter-stats filter-stats-Pierce-Crassostrea.qza

qiime deblur denoise-16S \
    --i-demultiplexed-seqs filtered-Pierce-Crassostrea.qza \
    --p-trim-length 150 \
    --p-left-trim-len 0 \
    --o-representative-sequences deblur_rep_seqs_Pierce-Crassostrea.qza \
    --o-table deblur_table_Pierce-Crassostrea.qza \
    --o-stats deblur-stats-Pierce-Crassostrea.qza \
    --p-jobs-to-start 16

    qiime tools import \
    --type 'SampleData[SequencesWithQuality]' \
    --input-path TangLizNTmanifest.txt \
    --output-path TangLizNT-single-demux.qza \
    --input-format SingleEndFastqManifestPhred33V2

qiime quality-filter q-score \
    --i-demux TangLizNT-single-demux.qza \
    --o-filtered-sequences filtered-TangLizNT.qza \
    --o-filter-stats filter-stats-TangLizNT.qza

qiime deblur denoise-16S \
    --i-demultiplexed-seqs filtered-TangLizNT.qza \
    --p-trim-length 150 \
    --p-left-trim-len 0 \
    --o-representative-sequences deblur_rep_seqs_TangLizNT.qza \
    --o-table deblur_table_TangLizNT.qza \
    --o-stats deblur-stats-TangLizNT.qza \
    --p-jobs-to-start 16

find -name "deblur_table*.qza" | tr '\n'\\ '\n'
find -name "deblur_rep*.qza" | tr '\n'\\ '\n'

qiime feature-table merge \
    --i-tables $(find -name "deblur_table*.qza" | tr '\n'\\ ' ') \
    --o-merged-table merged_table_Jun2_GMTOL.qza

qiime feature-table merge-seqs \
    --i-data $(find -name "deblur_rep*.qza" | tr '\n'\\ ' ') \
    --o-merged-data merged_repseqs_Jun2_GMTOL.qza

qiime feature-table summarize \
--i-table merged_table_Jun2_GMTOL.qza \
--m-sample-metadata-file newmetadata_GMTOL_test.txt \
--o-visualization merged_table_Jun2_GMTOL.qzv 


qiime feature-classifier classify-sklearn \
  --i-classifier 2022.10.backbone.full-length.nb.qza \
  --i-reads merged_repseqs_Jun2_GMTOL.qza \
  --o-classification merged_GMTOL_taxonomy.qza \
  --p-n-jobs 16

qiime metadata tabulate \
  --m-input-file merged_GMTOL_taxonomy.qza \
  --o-visualization merged_GMTOL_taxonomy.qzv

qiime feature-table group \
--i-table merged_table_Jun2_GMTOL.qza \
--p-axis sample \
--m-metadata-file June2metadata_GMTOL_test.txt \
--m-metadata-column Class \
--p-mode sum \
--o-grouped-table merged_table_Jun2_GMTOL_groupedClass.qza

qiime taxa barplot \
  --i-table merged_table_Jun2_GMTOL_groupedClass.qza \
  --i-taxonomy merged_GMTOL_taxonomy.qza \
  --o-visualization taxabarplot_Jun2_GMTOL_groupedClass.qzv

###Making merged tables for students


qiime feature-table filter-samples \
  --i-table merged_table_Jun2_GMTOL.qza \
  --m-metadata-file June2metadata_GMTOL_test.txt \
  --p-where "[Class] IN ('Reptilia')" \
  --o-filtered-table Sophia_Reptilia_table2.qza

  qiime feature-table filter-samples \
  --i-table merged_table_Jun2_GMTOL.qza \
  --m-metadata-file June2metadata_GMTOL_test.txt \
  --p-where "[Class] IN ('Actinopterygii' )" \
  --o-filtered-table Emily_Fish_table2.qza

 qiime feature-table filter-samples \
  --i-table merged_table_Jun2_GMTOL.qza \
  --m-metadata-file June2metadata_GMTOL_test.txt \
  --p-where "[Class] IN ('Mammalia' )" \
  --o-filtered-table Mammal_table2.qza

   qiime feature-table filter-samples \
  --i-table merged_table_Jun2_GMTOL.qza \
  --m-metadata-file June2metadata_GMTOL_test.txt \
  --p-where "[Class] IN ('Aves' )" \
  --o-filtered-table Emma_Aves_table2.qza


 qiime feature-table filter-samples \
  --i-table merged_table_Jun2_GMTOL.qza \
  --m-metadata-file June2metadata_GMTOL_test.txt \
  --p-where "[Class] IN ('Insecta' )" \
  --o-filtered-table Noah_Insects_table2.qza


#Now trying to merge everything together from allsong and GMTOL
#heres one repseq merge
qiime feature-table merge-seqs \
 --i-data dietrich-rep-seq-dada2.qza 	\
 --i-data dong-rep-seq-dada2.qza 	\
 --i-data fontaine-rep-seqs-dada2.qza 	\
 --i-data hernandez-rep-seqs-dada2.qza 	\
 --i-data jiang-rep-seqs-dada2.qza 	\
 --i-data keenan-rep-seqs-dada2.qza 	\
 --i-data price-rep-seqs-dada2.qza 	\
 --i-data sandri-rep-seqs-dada2.qza 	\
 --i-data wang-rep-seqs-dada2.qza 	\
 --i-data zhou-rep-seqs-dada2.qza 	\
 --o-merged-data TOLrepseqs-batch2.qza

#dont use fontaine jiang wang zhou

#and another:

qiime feature-table merge-seqs \
    --i-data rep-seqs-dada-arizza.qza \
    --i-data rep-seqs-dada-colston.qza \
    --i-data rep-seqs-dada-delsuc.qza \
    --i-data rep-seqs-dada-erwin.qza \
    --i-data rep-seqs-dada-hakim.qza \
    --i-data rep-seqs-dada-kwong.qza \
    --i-data rep-seqs-dada-murphy.qza \
    --i-data rep-seqs-dada-Nasvall.qza \
    --i-data rep-seqs-dada-perofsky.qza \
    --i-data rep-seqs-dada-zoqratt.qza \
    --i-data rep-seqs-dada-parata.qza \
    --i-data rep-seqs-dada-sanders.qza \
    --i-data rep-seqs-dada-schwob.qza \
    --i-data rep-seqs-dada-suenami.qza \
    --i-data rep-seqs-dada-visnovska.qza \
    --i-data rep-seqs-dada-wang.qza \
    --o-merged-data TOLrep-seqs.qza

#studies that are found in GMTOL metadata:
# Hakim zoqratt suenami wang


#heres the table merge:

qiime feature-table merge \
 --i-tables  dietrich-table-dada2.qza \
 --i-tables  dong-table-dada2.qza \
 --i-tables  fontaine-table-dada2.qza \
 --i-tables  hernandez-table-dada2.qza \
 --i-tables  jiang-table-dada2.qza \
 --i-tables  keenan-table-dada2.qza \
 --i-tables  price-table-dada2.qza \
 --i-tables  sandri-table-dada2.qza \
 --i-tables  table-dada3-arizza.qza \
 --i-tables  table-dada3-colston.qza \
 --i-tables  table-dada3-delsuc.qza \
 --i-tables  table-dada3-erwin.qza \
 --i-tables  table-dada3-hakim.qza \
 --i-tables  table-dada3-kwong.qza \
 --i-tables  table-dada3-murphy.qza \
 --i-tables  table-dada3-Nasvall.qza \
 --i-tables  table-dada3-parata.qza \
 --i-tables  table-dada3-perofsky.qza \
 --i-tables  table-dada3-rojas.qza \
 --i-tables  table-dada3-sanders.qza \
 --i-tables  table-dada3-schwob.qza \
 --i-tables  table-dada3-suenami.qza \
 --i-tables  table-dada3-visnovska.qza \
 --i-tables  table-dada3-wang.qza \
 --i-tables  table-dada3-zoqratt.qza \
 --i-tables  wang-table-dada2.qza \
 --i-tables  zhou-table-dada2.qza \
 --o-merged-table allmerged-table2.qza

qiime feature-table merge \
 --i-tables  table55205_NZ.qza \
 --i-tables  table55205.qza \
 --i-tables  table55205_S2.qza \
 --i-tables  tableGilbert001.qza \
 --i-tables  tableUndetermined_S0.qza \
 --o-merged-table allmerged_songetal_table.qza

 qiime feature-table merge \
 --i-tables   allTOLmerged-table2mf.qza  \
 --i-tables  songetal/16S/allmerged_songetal_tablef.qza \
 --o-merged-table allTOLsong_table.qza

 qiime feature-table merge-seqs \
 --i-data songetal/16S/rep-seqs-dada255205_NZ.qza 	\
 --i-data songetal/16S/rep-seqs-dadaUndetermined_S0.qza 	\
 --i-data songetal/16S/rep-seqs-dada255205.qza	\
 --i-data songetal/16S/rep-seqs-Gilbert001.qza 	\
 --i-data songetal/16S/rep-seqs-dada255205_S2.qza 	\
 --i-data allTOLmerged-repseqs.qza 	\
 --o-merged-data allTOLsong_repseqs.qza

 #GOING to just merge the final repseq and table frong the song stuff first with the GMTOL before trying to do a whole new deblur run

    qiime feature-table merge \
    --i-tables  allTOLsong_table.qza \
    --i-tables  merged_table_Jun2_GMTOL.qza \
    --o-merged-table GMTOLsong_table.qza

qiime feature-table merge-seqs \
--i-data  allTOLsong_repseqs.qza \
--i-data  merged_repseqs_Jun2_GMTOL.qza \
--o-merged-data GMTOLsong_repseqs.qza

#making tree now
#not enough RAM..need to filter table out

qiime feature-table summarize \
  --i-table merged_table_Jun2_GMTOL.qza \
  --m-sample-metadata-file Jul17metadataMerged.txt \
  --o-visualization merged_table_Jun2_GMTOL.qzv

qiime feature-table filter-seqs \
    --i-data GMTOLsong_repseqs.qza \
    --i-table GMTOLsong_table.qza \
    --o-filtered-data GMTOLrepseqf.qza

qiime feature-table filter-samples \
  --i-table GMTOLsong_table.qza \
  --m-metadata-file samples2loseJul17.txt \
  --p-exclude-ids \
  --o-filtered-table GMTOLsong_tablef.qza

  qiime feature-table filter-seqs \
    --i-data GMTOLsong_repseqs.qza \
    --i-table GMTOLsong_tablef.qza \
    --o-filtered-data GMTOLrepseqf.qza



#trying subsample alone first

qiime feature-table subsample \
        --i-table "GMTOLsong_table.qza" \
        --m-metadata-file "Jul17metadataMerged.txt" \
        --p-metadata-column "Species" \
        --p-min-frequency 1 \
        --p-max-frequency "20" \
        --p-with-replacement \
        --p-exact \
        --p-n-jobs 4 \
        --o-sampled-table "GMTOL_song_table20.qza"

#not working at all so I did it in R

qiime feature-table filter-samples \
  --i-table GMTOLsong_table.qza \
  --m-metadata-file subsample/N1samples2keep.tsv \
  --o-filtered-table GMTOLsong_tableN1.qza

qiime feature-table filter-samples \
  --i-table GMTOLsong_table.qza \
  --m-metadata-file subsample/N5samples2keep.tsv \
  --o-filtered-table GMTOLsong_tableN5.qza

qiime feature-table filter-samples \
  --i-table GMTOLsong_table.qza \
  --m-metadata-file subsample/N20samples2keep.tsv \
  --o-filtered-table GMTOLsong_tableN20.qza

qiime feature-table filter-samples \
  --i-table GMTOLsong_table.qza \
  --m-metadata-file subsample/N30samples2keep.tsv \
  --o-filtered-table GMTOLsong_tableN30.qza

  qiime feature-table filter-seqs \
    --i-data GMTOLsong_repseqs.qza \
    --i-table subsample/GMTOLsong_tableN1.qza \
    --o-filtered-data subsample/GMTOL_repseqsN1.qza

  qiime feature-table filter-seqs \
    --i-data GMTOLsong_repseqs.qza \
    --i-table subsample/GMTOLsong_tableN5.qza \
    --o-filtered-data subsample/GMTOL_repseqsN5.qza

  qiime feature-table filter-seqs \
    --i-data GMTOLsong_repseqs.qza \
    --i-table subsample/GMTOLsong_tableN20.qza \
    --o-filtered-data subsample/GMTOL_repseqsN20.qza

GMTOL_repseqsN1.qza      N20metadataGMTOLsong.tsv
GMTOL_repseqsN20.qza     N20samples2keep.tsv
GMTOL_repseqsN5.qza      N30metadataGMTOLsong.tsv
GMTOLsong_tableN1.qza    N30samples2keep.tsv
GMTOLsong_tableN20.qza   N5metadataGMTOLsong.tsv
GMTOLsong_tableN30.qza   N5samples2keep.tsv
GMTOLsong_tableN5.qza    treeN1.sh
N1metadataGMTOLsong.tsv  tree.sh

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny GMTOLsong_rooted_treeN1.qza \
  --i-table GMTOLsong_tableN1.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file N1metadataGMTOLsong.tsv \
  --output-dir core-metrics-results-GMTOLsongN1


   qiime tools export --input-path GMTOLsong_tableN30.qza --output-path ./  
  biom convert -i feature-table.biom -o GMTOLsong_tableN30.tsv --to-tsv 


qiime diversity core-metrics-phylogenetic \
  --i-phylogeny GMTOLsong_rooted_treef.qza \
  --i-table GMTOLsong_tablef.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file Jul17metadataMerged.txt \
  --output-dir core-metrics-results-GMTOLsongfJul17

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny GMTOLsong_rooted_treeN5.qza \
  --i-table GMTOLsong_tableN5.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file N5metadataGMTOLsong.tsv \
  --output-dir core-metrics-results-GMTOLsongN5


qiime diversity alpha-rarefaction \
--i-table GMTOLsong_tableN1.qza \
--i-phylogeny GMTOLsong_rooted_treeN1.qza \
--p-max-depth 10000 \
--m-metadata-file N1metadataGMTOLsong.tsv \
--o-visualization alpha-rarefactionN1_10k.qzv


qiime diversity alpha-rarefaction \
--i-table GMTOLsong_tableN5.qza \
--i-phylogeny GMTOLsong_rooted_treeN5.qza \
--p-max-depth 10000 \
--m-metadata-file N5metadataGMTOLsong.tsv \
--o-visualization alpha-rarefactionN5_10k.qzv



qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ../GMTOLsong_rooted_treef.qza \
  --i-table GMTOLsong_tableN20.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file N20metadataGMTOLsong.tsv \
  --output-dir core-metrics-results-GMTOLsongN20

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ../GMTOLsong_rooted_treef.qza \
  --i-table GMTOLsong_tableN30.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file N30metadataGMTOLsong.tsv \
  --output-dir core-metrics-results-GMTOLsongN30


#trying just GMTOl solo now
qiime feature-table filter-samples \
  --i-table merged_table_Jun2_GMTOL.qza \
  --m-metadata-file ../GMTOLsubsample/N1samples2keepGsolo.tsv \
  --o-filtered-table ../GMTOLsubsample/GMTOLsolo_tableN1.qza

qiime feature-table filter-samples \
  --i-table merged_table_Jun2_GMTOL.qza \
  --m-metadata-file ../GMTOLsubsample/N5samples2keepGsolo.tsv \
  --o-filtered-table ../GMTOLsubsample/GMTOLsolo_tableN5.qza

qiime feature-table filter-samples \
  --i-table merged_table_Jun2_GMTOL.qza \
  --m-metadata-file ../GMTOLsubsample/N20samples2keepGsolo.tsv \
  --o-filtered-table ../GMTOLsubsample/GMTOLsolo_tableN20.qza

qiime feature-table filter-samples \
  --i-table merged_table_Jun2_GMTOL.qza \
  --m-metadata-file subsample/N30samples2keep.tsv \
  --o-filtered-table ../GMTOLsubsample/GMTOLsolo_tableN30.qza

qiime feature-table filter-samples \
  --i-table ../Merged/merged_table_Jun2_GMTOL.qza \
  --m-metadata-file N15samples2keepGsolo.txt \
  --o-filtered-table GMTOLsolo_tableN15.qza

  qiime feature-table filter-samples \
  --i-table ../Merged/merged_table_Jun2_GMTOL.qza \
  --m-metadata-file N10samples2keepGsolov2.txt \
  --o-filtered-table GMTOLsolo_tableN10.qza

#filter above table to only V4 samples

qiime feature-table filter-samples \
  --i-table GMTOLsolo_tableN10.qza \
  --m-metadata-file ../Jul2GMTOLsong_metadata2024.txt \
  --p-where "Primer='V4'" \
  --o-filtered-table GMTOLsolo_tableN10_V4.qza

  qiime feature-table filter-samples \
  --i-table GMTOLsolo_tableN15.qza \
  --m-metadata-file ../Jul2GMTOLsong_metadata2024.txt \
  --p-where "Primer='V4'" \
  --o-filtered-table GMTOLsolo_tableN15_V4.qza





qiime diversity alpha-rarefaction \
--i-table GMTOLsubsample/GMTOLsolo_tableN1.qza \
--i-phylogeny Jun2_GMTOL_rooted_tree.qza \
--p-max-depth 6000 \
--m-metadata-file GMTOLsubsample/N1metadataGMTOLsolo.tsv \
--o-visualization GMTOLsubsample/alpha-rarefactionN1solo_6k.qzv

  qiime diversity alpha-rarefaction \
--i-table GMTOLsubsample/GMTOLsolo_tableN5.qza \
--i-phylogeny Jun2_GMTOL_rooted_tree.qza \
--p-max-depth 6000 \
--m-metadata-file GMTOLsubsample/N5metadataGMTOLsolo.tsv \
--o-visualization GMTOLsubsample/alpha-rarefactionN5solo_6k.qzv

  qiime diversity alpha-rarefaction \
--i-table GMTOLsubsample/GMTOLsolo_tableN20.qza \
--i-phylogeny Jun2_GMTOL_rooted_tree.qza \
--p-max-depth 6000 \
--m-metadata-file GMTOLsubsample/N20metadataGMTOLsolo.tsv \
--o-visualization GMTOLsubsample/alpha-rarefactionN20solo_6k.qzv

  qiime diversity alpha-rarefaction \
--i-table GMTOLsubsample/GMTOLsolo_tableN30.qza \
--i-phylogeny Jun2_GMTOL_rooted_tree.qza \
--p-max-depth 6000 \
--m-metadata-file GMTOLsubsample/N30metadataGMTOLsolo.tsv \
--o-visualization GMTOLsubsample/alpha-rarefactionN30solo_6k.qzv

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny Jun2_GMTOL_rooted_tree.qza \
  --i-table GMTOLsubsample/GMTOLsolo_tableN1.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file GMTOLsubsample/N1metadataGMTOLsolo.tsv \
  --output-dir core-metrics-results-GMTOLsoloN1

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny Jun2_GMTOL_rooted_tree.qza \
  --i-table GMTOLsubsample/GMTOLsolo_tableN5.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file GMTOLsubsample/N5metadataGMTOLsolo.tsv \
  --output-dir core-metrics-results-GMTOLsoloN5

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny Jun2_GMTOL_rooted_tree.qza \
  --i-table GMTOLsubsample/GMTOLsolo_tableN20.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file GMTOLsubsample/N20metadataGMTOLsolo.tsv \
  --output-dir core-metrics-results-GMTOLsoloN20


qiime diversity core-metrics-phylogenetic \
  --i-phylogeny Jun2_GMTOL_rooted_tree.qza \
  --i-table GMTOLsubsample/GMTOLsolo_tableN30.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file GMTOLsubsample/N30metadataGMTOLsolo.tsv \
  --output-dir GMTOLsubsample/core-metrics-results-GMTOLsoloN30


qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ../Jun2_GMTOL_rooted_tree.qza \
  --i-table GMTOLsolo_tableN10.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file Jul17metadataMerged.txt \
  --output-dir core-metrics-results-GMTOLsoloN10

  qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ../Jun2_GMTOL_rooted_tree.qza \
  --i-table GMTOLsolo_tableN15.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file Jul17metadataMerged.txt \
  --output-dir core-metrics-results-GMTOLsoloN15

#and just V4

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ../Jun2_GMTOL_rooted_tree.qza \
  --i-table GMTOLsolo_tableN10_V4.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file ../Jul2GMTOLsong_metadata2024.txt \
  --output-dir core-metrics-results-GMTOLsoloN10_V4

  qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ../Jun2_GMTOL_rooted_tree.qza \
  --i-table GMTOLsolo_tableN15_V4.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file ../Jul2GMTOLsong_metadata2024.txt \
  --output-dir core-metrics-results-GMTOLsoloN15_V4

qiime feature-table filter-samples \
  --i-table GMTOLsong_tablef.qza \
 --m-metadata-file Jul17metadataMerged.txt \
  --p-where "Genus='Homo'" \
  --o-filtered-table GMTOLsongHuman_tablef.qza

qiime feature-table summarize \
    --i-table GMTOLsongHuman_tablef.qza \
    --m-sample-metadata-file Jul26metadataGMTOLsong.txt \
    --o-visualization GMTOLsongHuman_tablef.qzv

qiime feature-classifier classify-sklearn \
  --i-classifier 2022.10.backbone.full-length.nb.qza \
  --p-n-jobs 64 \
  --i-reads GMTOLsong_repseqs.qza \
  --o-classification GMTOLsong_taxonomy.qza

qiime feature-table filter-samples \
  --i-table GMTOLsong_tablef.qza \
 --m-metadata-file Jul17metadataMerged.txt \
  --p-where "Class='Aves'" \
  --o-filtered-table GMTOLsongBirdf.qza

#filtering by primer

qiime feature-table filter-samples \
  --i-table GMTOLsolo_tableN1.qza \
 --m-metadata-file Jul26metadataGMTOLsong.txt \
  --p-where "Primer='V3-V4'" \
  --o-filtered-table GMTOLsolo_tableN1_V3V4.qza

qiime feature-table filter-samples \
  --i-table GMTOLsolo_tableN1.qza \
 --m-metadata-file Jul26metadataGMTOLsong.txt \
  --p-where "Primer='V4'" \
  --o-filtered-table GMTOLsolo_tableN1_V4.qza


qiime feature-table filter-samples \
  --i-table GMTOLsolo_tableN5.qza \
 --m-metadata-file Jul26metadataGMTOLsong.txt \
  --p-where "Primer='V3-V4'" \
  --o-filtered-table GMTOLsolo_tableN5_V3V4.qza

qiime feature-table filter-samples \
  --i-table GMTOLsolo_tableN5.qza \
 --m-metadata-file Jul26metadataGMTOLsong.txt \
  --p-where "Primer='V4'" \
  --o-filtered-table GMTOLsolo_tableN5_V4.qza


qiime feature-table filter-samples \
  --i-table GMTOLsolo_tableN20.qza \
 --m-metadata-file Jul26metadataGMTOLsong.txt \
  --p-where "Primer='V3-V4'" \
  --o-filtered-table GMTOLsolo_tableN20_V3V4.qza

qiime feature-table filter-samples \
  --i-table GMTOLsolo_tableN20.qza \
 --m-metadata-file Jul26metadataGMTOLsong.txt \
  --p-where "Primer='V4'" \
  --o-filtered-table GMTOLsolo_tableN20_V4.qza

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ../Merged/GMTOLsong_rooted_treef.qza \
  --i-table GMTOLsolo_tableN1_V3V4.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file Jul26metadataGMTOLsong.txt \
  --output-dir core-metrics-results-GMTOLsoloN1_V3V4

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ../Merged/GMTOLsong_rooted_treef.qza \
  --i-table GMTOLsolo_tableN1_V4.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file Jul26metadataGMTOLsong.txt \
  --output-dir core-metrics-results-GMTOLsoloN1_V4

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ../Merged/GMTOLsong_rooted_treef.qza \
  --i-table GMTOLsolo_tableN5_V3V4.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file Jul26metadataGMTOLsong.txt \
  --output-dir core-metrics-results-GMTOLsoloN5_V3V4

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ../Merged/GMTOLsong_rooted_treef.qza \
  --i-table GMTOLsolo_tableN5_V4.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file Jul26metadataGMTOLsong.txt \
  --output-dir core-metrics-results-GMTOLsoloN5_V4

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ../Merged/GMTOLsong_rooted_treef.qza \
  --i-table GMTOLsolo_tableN20_V3V4.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file Jul26metadataGMTOLsong.txt \
  --output-dir core-metrics-results-GMTOLsoloN20_V3V4

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ../Merged/GMTOLsong_rooted_treef.qza \
  --i-table GMTOLsolo_tableN20_V4.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file Jul26metadataGMTOLsong.txt \
  --output-dir core-metrics-results-GMTOLsoloN20_V4

#random code I need to put somewhere

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny GMTOL_rooted_tree2.qza \
  --i-table Mammal_table2.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file GMTOL_metadata2.txt  \
  --output-dir core-metrics-resultsMammals2

  qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-resultsMammals2/faith_pd_vector.qza \
  --m-metadata-file GMTOL_metadata2.txt \
  --o-visualization core-metrics-resultsMammals2/faith-pd-group-significance.qzv

  qiime diversity alpha-rarefaction \
  --i-table Mammal_table2.qza \
  --i-phylogeny GMTOL_rooted_tree2.qza \
  --p-max-depth 6000 \
  --m-metadata-file GMTOL_metadata2.txt \
  --o-visualization core-metrics-resultsMammals2/Mammal-alpha-rarefaction.qzv  

  qiime taxa barplot \
  --i-table Mammal_table2.qza \
  --i-taxonomy GMTOL_taxonomy2.qza \
  --m-metadata-file GMTOL_metadata2.txt \
  --o-visualization taxa-bar-plotsMammals2.qzv

  qiime feature-table group \
  --i-table Mammal_table2.qza \
  --p-axis sample \
  --m-metadata-file GMTOL_metadata2.txt \
  --m-metadata-column Order \
  --p-mode sum \
  --o-grouped-table Mammal_table2_grouped.qza

qiime taxa barplot \
  --i-table Mammal_table2_grouped.qza \
  --i-taxonomy GMTOL_taxonomy2.qza \
  --o-visualization taxa-bar-plotsMammalsGrouped.qzv
####

#now trying to separate out the V3V4 and V4 samples of GMTOLsong

qiime feature-table filter-samples \
  --i-table GMTOLsong_tablef.qza \
 --m-metadata-file Jul26metadataGMTOLsong.txt \
  --p-where "Primer='V4'" \
  --o-filtered-table GMTOLsong_tablef_V4.qza

qiime feature-table filter-samples \
  --i-table GMTOLsong_tablef.qza \
 --m-metadata-file Jul26metadataGMTOLsong.txt \
  --p-where "Primer='V3-V4'" \
  --o-filtered-table GMTOLsong_tablef_V3-V4.qza

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny GMTOLsong_rooted_treef.qza \
  --i-table GMTOLsong_tablef_V3-V4.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file Jul26metadataGMTOLsong.txt \
  --output-dir core-metrics-results-GMTOLsongV3V4

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny GMTOLsong_rooted_treef.qza \
  --i-table GMTOLsong_tablef_V4.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file Jul26metadataGMTOLsong.txt \
  --output-dir core-metrics-results-GMTOLsongV4

take out annelids..
pull randomly from class level to compare R2
test R2 across different sample sizes and compare how much the R2 changes

Email Celeste about the metagenomics data
Email Daniel about EMP non-host associated data
Email Rob about Microbiome Conservancy

#doing adonis across different sample sizes

qiime diversity adonis \
  --i-distance-matrix core-metrics-results-GMTOLsoloN1_V3V4/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ../Merged/Jul26metadataGMTOLsong.txt \
  --o-visualization adonis/GMTOLsoloN1_V3V4_ClassDiet_adonis.qzv \
  --p-n-jobs 4 \
  --p-formula Class+Family+DietSimp

qiime diversity adonis \
  --i-distance-matrix core-metrics-results-GMTOLsoloN5_V3V4/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ../Merged/Jul26metadataGMTOLsong.txt \
  --o-visualization adonis/GMTOLsoloN5_V3V4_ClassDiet_adonis.qzv \
  --p-n-jobs 4 \
  --p-formula Class+Family+DietSimp

qiime diversity adonis \
  --i-distance-matrix core-metrics-results-GMTOLsoloN20_V3V4/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ../Merged/Jul26metadataGMTOLsong.txt \
  --o-visualization adonis/GMTOLsoloN20_V3V4_ClassDiet_adonis.qzv \
  --p-n-jobs 4 \
  --p-formula Class+Family+DietSimp

qiime diversity adonis \
  --i-distance-matrix core-metrics-results-GMTOLsoloN1_V4/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ../Merged/Jul26metadataGMTOLsong.txt \
  --o-visualization adonis/GMTOLsoloN1_V4_ClassDiet_adonis.qzv \
  --p-n-jobs 4 \
  --p-formula Class+Family+DietSimp

qiime diversity adonis \
  --i-distance-matrix core-metrics-results-GMTOLsoloN5_V4/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ../Merged/Jul26metadataGMTOLsong.txt \
  --o-visualization adonis/GMTOLsoloN5_V4_ClassDiet_adonis.qzv \
  --p-n-jobs 4 \
  --p-formula Class+Family+DietSimp

qiime diversity adonis \
  --i-distance-matrix core-metrics-results-GMTOLsoloN20_V4/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ../Merged/Jul26metadataGMTOLsong.txt \
  --o-visualization adonis/GMTOLsoloN5_V20_ClassDiet_adonis.qzv \
  --p-n-jobs 4 \
  --p-formula Class+Family+DietSimp

 qiime tools export --input-path GMTOLsong_tablef_V4.qza --output-path ./  
biom convert -i feature-table.biom -o GMTOLsong_tablef_V4.tsv --to-tsv 

 qiime tools export --input-path GMTOLsong_tablef_V3-V4.qza --output-path ./  
biom convert -i feature-table.biom -o GMTOLsong_tablef_V3-V4.tsv --to-tsv 

# installing qiime conda env on jupyter hub had to install ipykernel first

python -m ipykernel install --user --name=qiime2-2023.2

#REMEMBER to run this inside the qiime2-2023.2 env in the temrinal and then open up jupyterhub where you can immediately import qiime2!

#running 2nd round of sample size comparisons to see if they are similar


#now trying to separate out the V3V4 and V4 samples of GMTOLsong
#trying just GMTOl solo now
qiime feature-table filter-samples \
  --i-table merged_table_Jun2_GMTOL.qza \
  --m-metadata-file ../GMTOLsubsample/N1samples2keepGsolo2.tsv \
  --o-filtered-table ../GMTOLsubsample/GMTOLsolo_table2N1.qza

qiime feature-table filter-samples \
  --i-table merged_table_Jun2_GMTOL.qza \
  --m-metadata-file ../GMTOLsubsample/N5samples2keepGsolo2.tsv \
  --o-filtered-table ../GMTOLsubsample/GMTOLsolo_table2N5.qza

qiime feature-table filter-samples \
  --i-table merged_table_Jun2_GMTOL.qza \
  --m-metadata-file ../GMTOLsubsample/N20samples2keepGsolo2.tsv \
  --o-filtered-table ../GMTOLsubsample/GMTOLsolo_table2N20.qza




qiime feature-table filter-samples \
  --i-table GMTOLsolo_table2N1.qza \
 --m-metadata-file Jul26metadataGMTOLsong.txt \
  --p-where "Primer='V3-V4'" \
  --o-filtered-table GMTOLsolo_table2N1_V3V4.qza

qiime feature-table filter-samples \
  --i-table GMTOLsolo_table2N1.qza \
 --m-metadata-file Jul26metadataGMTOLsong.txt \
  --p-where "Primer='V4'" \
  --o-filtered-table GMTOLsolo_table2N1_V4.qza


qiime feature-table filter-samples \
  --i-table GMTOLsolo_table2N5.qza \
 --m-metadata-file Jul26metadataGMTOLsong.txt \
  --p-where "Primer='V3-V4'" \
  --o-filtered-table GMTOLsolo_table2N5_V3V4.qza

qiime feature-table filter-samples \
  --i-table GMTOLsolo_table2N5.qza \
 --m-metadata-file Jul26metadataGMTOLsong.txt \
  --p-where "Primer='V4'" \
  --o-filtered-table GMTOLsolo_table2N5_V4.qza


qiime feature-table filter-samples \
  --i-table GMTOLsolo_table2N20.qza \
 --m-metadata-file Jul26metadataGMTOLsong.txt \
  --p-where "Primer='V3-V4'" \
  --o-filtered-table GMTOLsolo_table2N20_V3V4.qza

qiime feature-table filter-samples \
  --i-table GMTOLsolo_table2N20.qza \
 --m-metadata-file Jul26metadataGMTOLsong.txt \
  --p-where "Primer='V4'" \
  --o-filtered-table GMTOLsolo_table2N20_V4.qza

#NOW CORE METRICS 
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ../Merged/GMTOLsong_rooted_treef.qza \
  --i-table GMTOLsolo_table2N1_V3V4.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file Jul26metadataGMTOLsong.txt \
  --output-dir core-metrics-results-GMTOLsolo2N1_V3V4

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ../Merged/GMTOLsong_rooted_treef.qza \
  --i-table GMTOLsolo_table2N1_V4.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file Jul26metadataGMTOLsong.txt \
  --output-dir core-metrics-results-GMTOLsolo2N1_V4

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ../Merged/GMTOLsong_rooted_treef.qza \
  --i-table GMTOLsolo_table2N5_V3V4.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file Jul26metadataGMTOLsong.txt \
  --output-dir core-metrics-results-GMTOLsolo2N5_V3V4

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ../Merged/GMTOLsong_rooted_treef.qza \
  --i-table GMTOLsolo_table2N5_V4.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file Jul26metadataGMTOLsong.txt \
  --output-dir core-metrics-results-GMTOLsolo2N5_V4

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ../Merged/GMTOLsong_rooted_treef.qza \
  --i-table GMTOLsolo_table2N20_V3V4.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file Jul26metadataGMTOLsong.txt \
  --output-dir core-metrics-results-GMTOLsolo2N20_V3V4

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ../Merged/GMTOLsong_rooted_treef.qza \
  --i-table GMTOLsolo_table2N20_V4.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file Jul26metadataGMTOLsong.txt \
  --output-dir core-metrics-results-GMTOLsolo2N20_V4


qiime diversity adonis \
  --i-distance-matrix core-metrics-results-GMTOLsolo2N1_V3V4/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ../Merged/Jul26metadataGMTOLsong.txt \
  --o-visualization adonis/GMTOLsolo2N1_V3V4_ClassDiet_adonis.qzv \
  --p-n-jobs 4 \
  --p-formula Class+Family+DietSimp

qiime diversity adonis \
  --i-distance-matrix core-metrics-results-GMTOLsolo2N5_V3V4/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ../Merged/Jul26metadataGMTOLsong.txt \
  --o-visualization adonis/GMTOLsolo2N5_V3V4_ClassDiet_adonis.qzv \
  --p-n-jobs 4 \
  --p-formula Class+Family+DietSimp

qiime diversity adonis \
  --i-distance-matrix core-metrics-results-GMTOLsolo2N20_V3V4/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ../Merged/Jul26metadataGMTOLsong.txt \
  --o-visualization adonis/GMTOLsolo2N20_V3V4_ClassDiet_adonis.qzv \
  --p-n-jobs 4 \
  --p-formula Class+Family+DietSimp

qiime diversity adonis \
  --i-distance-matrix core-metrics-results-GMTOLsolo2N1_V4/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ../Merged/Jul26metadataGMTOLsong.txt \
  --o-visualization adonis/GMTOLsolo2N1_V4_ClassDiet_adonis.qzv \
  --p-n-jobs 4 \
  --p-formula Class+Family+DietSimp

qiime diversity adonis \
  --i-distance-matrix core-metrics-results-GMTOLsolo2N5_V4/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ../Merged/Jul26metadataGMTOLsong.txt \
  --o-visualization adonis/GMTOLsolo2N5_V4_ClassDiet_adonis.qzv \
  --p-n-jobs 4 \
  --p-formula Class+Family+DietSimp

qiime diversity adonis \
  --i-distance-matrix core-metrics-results-GMTOLsolo2N20_V4/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ../Merged/Jul26metadataGMTOLsong.txt \
  --o-visualization adonis/GMTOLsolo2N20_V4_ClassDiet_adonis.qzv \
  --p-n-jobs 4 \
  --p-formula Class+Family+DietSimp

  #Now trying adonis on V4 N20 with Study

  qiime diversity adonis \
  --i-distance-matrix core-metrics-results-GMTOLsolo2N20_V4/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ../Merged/Jul26metadataGMTOLsong.txt \
  --o-visualization adonis/GMTOLsolo2N20_V4_AllandStudy_adonis.qzv \
  --p-n-jobs 2 \
  --p-formula "Study+Phylum+Class+Order+Family+Genus" \
  --verbose

  #only returns study and Family..switching order to test effect

  qiime diversity adonis \
  --i-distance-matrix core-metrics-results-GMTOLsolo2N20_V4/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ../Merged/Jul26metadataGMTOLsong.txt \
  --o-visualization adonis/GMTOLsolo2N20_V4_AllandStudylast_adonis.qzv \
  --p-n-jobs 2 \
  --p-formula "Phylum+Class+Order+Family+Genus+Study" \
  --verbose

  qiime diversity adonis \
  --i-distance-matrix core-metrics-results-GMTOLsolo2N20_V4/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ../Merged/Jul26metadataGMTOLsong.txt \
  --o-visualization adonis/GMTOLsolo2N20_V4_AllandStudylast_adonis.qzv \
  --p-n-jobs 2 \
  --p-formula "Phylum+Class+Order+Family+Genus+Study" \
  --verbose

    qiime diversity adonis \
  --i-distance-matrix core-metrics-results-GMTOLsoloN15_V4/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ../Jul2GMTOLsong_metadata2024.txt \
  --o-visualization adonis/GMTOLsoloN15_V4_AllandStudylast_adonis.qzv \
  --p-n-jobs 4 \
  --p-formula "Phylum+Class+Order+Family+Genus+Study" \
  --verbose

    qiime diversity adonis \
  --i-distance-matrix core-metrics-results-GMTOLsoloN10_V4/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ../Jul2GMTOLsong_metadata2024.txt \
  --o-visualization adonis/GMTOLsoloN10_V4_AllandStudylast_adonis.qzv \
  --p-n-jobs 4 \
  --p-formula "Phylum+Class+Order+Family+Genus+Study" \
  --verbose

    qiime diversity adonis \
  --i-distance-matrix core-metrics-results-GMTOLsolo2N5_V4/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ../Jul2GMTOLsong_metadata2024.txt \
  --o-visualization adonis/GMTOLsoloN5_V4_AllandStudylast_adonis.qzv \
  --p-n-jobs 4 \
  --p-formula "Phylum+Class+Order+Family+Genus+Study" \
  --verbose

      qiime diversity adonis \
  --i-distance-matrix core-metrics-results-GMTOLsolo2N1_V4/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ../Jul2GMTOLsong_metadata2024.txt \
  --o-visualization adonis/GMTOLsoloN1_V4_AllandStudylast_adonis.qzv \
  --p-n-jobs 4 \
  --p-formula "Phylum+Class+Order+Family+Genus+Study" \
  --verbose




#Now trying to filter Akkermansia and see what happens

qiime taxa filter-table \
  --i-table ../GMTOLsubsample/GMTOLsolo_tableN30.qza \
  --i-taxonomy GMTOLsong_taxonomy.qza  \
  --p-include Akkermansia,Faecalibacterium \
  --o-filtered-table Akkermansia/GMTOLtable30N_Akk_Feac.qza

qiime tools export --input-path Akkermansia/GMTOLtable30N_Akk_Feac.qza --output-path Akkermansia/

biom convert -i Akkermansia/feature-table.biom -o Akkermansia/GMTOLtable30N_Akk_Feac.tsv --to-tsv

qiime feature-table group \
--i-table Akkermansia/GMTOLtable30N_Akk_Feac.qza \
--p-axis sample \
--m-metadata-file Jul26metadataGMTOLsong.txt \
--m-metadata-column Family \
--p-mode sum \
--o-grouped-table Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMerged.qza

qiime tools export --input-path Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMerged.qza --output-path Akkermansia/
biom convert -i Akkermansia/feature-table.biom -o Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMerged.tsv --to-tsv

qiime tools export --input-path GMTOLsong_taxonomy.qza --output-path ./

qiime taxa filter-table \
  --i-table Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMerged.qza \
  --i-taxonomy GMTOLsong_taxonomy.qza  \
  --p-include 'Akkermansia muciniphila','Faecalibacterium prausnitzii' \
  --o-filtered-table Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMerged_Filtered.qza

qiime taxa collapse \
  --i-table Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMerged_Filtered.qza \
  --i-taxonomy GMTOLsong_taxonomy.qza  \
  --p-level 7 \
  --o-collapsed-table Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMerged_Rank7.qza

qiime tools export --input-path Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMerged_Rank7.qza --output-path Akkermansia/
biom convert -i Akkermansia/feature-table.biom -o Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMerged_Rank7.tsv --to-tsv

#~~~~~ Now trying average

qiime feature-table group \
--i-table Akkermansia/GMTOLtable30N_Akk_Feac.qza \
--p-axis sample \
--m-metadata-file Jul26metadataGMTOLsong.txt \
--m-metadata-column Family \
--p-mode mean-ceiling \
--o-grouped-table Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMergedMean.qza

qiime taxa filter-table \
  --i-table Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMergedMean.qza \
  --i-taxonomy GMTOLsong_taxonomy.qza  \
  --p-include 'Akkermansia muciniphila','Faecalibacterium prausnitzii' \
  --o-filtered-table Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMerged_FilteredMean.qza

qiime taxa collapse \
  --i-table Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMerged_FilteredMean.qza \
  --i-taxonomy GMTOLsong_taxonomy.qza  \
  --p-level 7 \
  --o-collapsed-table Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMerged_Rank7Mean.qza

qiime tools export --input-path Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMerged_Rank7Mean.qza --output-path Akkermansia/
biom convert -i Akkermansia/feature-table.biom -o Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMerged_Rank7Mean.tsv --to-tsv

#now doing merged mean but including all Akk and Feac
qiime taxa filter-table \
  --i-table Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMergedMean.qza \
  --i-taxonomy GMTOLsong_taxonomy.qza  \
  --p-include 'g__Akkermansia','g__Faecalibacterium' \
  --o-filtered-table Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMerged_FilteredMeanGenus.qza

qiime taxa collapse \
  --i-table Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMerged_FilteredMeanGenus.qza \
  --i-taxonomy GMTOLsong_taxonomy.qza  \
  --p-level 7 \
  --o-collapsed-table Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMerged_Rank7MeanGenus.qza

qiime tools export --input-path Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMerged_Rank7MeanGenus.qza --output-path Akkermansia/
biom convert -i Akkermansia/feature-table.biom -o Akkermansia/GMTOLtable30N_Akk_Feac_FamilyMerged_Rank7MeanGenus.tsv --to-tsv

#ok now going to filter the GMTOLsoloF table to see if I can get size down to do this in R

qiime feature-table filter-samples \
  --i-table GMTOLsolo_tableN30.qza \
 --m-metadata-file Jul26metadataGMTOLsong.txt \
  --p-where "Primer='V3-V4'" \
  --o-filtered-table GMTOLsolo_tableN30_V3V4.qza

qiime feature-table filter-samples \
  --i-table GMTOLsolo_tableN30.qza \
 --m-metadata-file Jul26metadataGMTOLsong.txt \
  --p-where "Primer='V4'" \
  --o-filtered-table GMTOLsolo_tableN30_V4.qza

qiime feature-table filter-features \
  --i-table GMTOLsolo_tableN30_V4.qza \
  --p-min-samples 2 \
  --o-filtered-table GMTOLsolo_tableN30_V4_2s.qza

qiime feature-table filter-features \
  --i-table GMTOLsolo_tableN30_V4_2s.qza \
  --p-min-frequency 10 \
  --o-filtered-table GMTOLsolo_tableN30_V4_taxa_2s10r.qza

qiime feature-table filter-features \
  --i-table GMTOLsolo_tableN30_V4.qza \
  --p-min-samples 5 \
  --o-filtered-table GMTOLsolo_tableN30_V4_5s.qza

qiime feature-table filter-features \
  --i-table GMTOLsolo_tableN30_V4_5s.qza \
  --p-min-frequency 20 \
  --o-filtered-table GMTOLsolo_tableN30_V4_taxa_5s20r.qza

qiime feature-table filter-features \
  --i-table GMTOLsolo_tableN30_V4_5s.qza \
  --p-min-frequency 100 \
  --o-filtered-table GMTOLsolo_tableN30_V4_taxa_5s100r.qza

qiime tools export --input-path GMTOLsolo_tableN30_V4_taxa_5s100r.qza --output-path .
biom convert -i feature-table.biom -o GMTOLsolo_tableN30_V4_taxa_5s100r.tsv --to-tsv

#trying new jupyter conda env

python -m ipykernel install --user --name=qiime2-2023.7


qiime feature-table group \
--i-table subsample/GMTOLsong_tableN20.qza \
--p-axis sample \
--m-metadata-file Jul26metadataGMTOLsong.txt \
--m-metadata-column Family \
--p-mode mean-ceiling \
--o-grouped-table Akkermansia/GMTOLsongtableN20FamilyMergedMean.qza

qiime taxa filter-table \
  --i-table Akkermansia/GMTOLsongtableN20FamilyMergedMean.qza \
  --i-taxonomy GMTOLsong_taxonomy.qza  \
  --p-include 'Akkermansia muciniphila','Faecalibacterium prausnitzii' \
  --o-filtered-table Akkermansia/GMTOLsongtableN20FamilyMergedMeanAkkFeac.qza

qiime taxa collapse \
  --i-table Akkermansia/GMTOLsongtableN20FamilyMergedMeanAkkFeac.qza \
  --i-taxonomy GMTOLsong_taxonomy.qza  \
  --p-level 7 \
  --o-collapsed-table Akkermansia/GMTOLsongtableN20FamilyMergedMeanAkkFeacRank7.qza

qiime tools export --input-path Akkermansia/GMTOLsongtableN20FamilyMergedMeanAkkFeacRank7.qza --output-path Akkermansia/
biom convert -i Akkermansia/feature-table.biom -o Akkermansia/GMTOLsongtableN20FamilyMergedMeanAkkFeacRank7.tsv --to-tsv

qiime feature-table relative-frequency \
--i-table Akkermansia/GMTOLsongtableN30FamilyMergedMean.qza \
--o-relative-frequency-table Akkermansia/GMTOLsongtableN30FamilyMergedMeanRel.qza

#collapsing then re-transofmring to rel abundances
qiime taxa collapse \
  --i-table Akkermansia/GMTOLsongtableN30FamilyMergedMean.qza \
  --i-taxonomy GMTOLsong_taxonomy.qza  \
  --p-level 7 \
  --o-collapsed-table Akkermansia/GMTOLsongtableN30FamilyMergedMeanRank7.qza

qiime feature-table relative-frequency \
--i-table Akkermansia/GMTOLsongtableN30FamilyMergedMeanRank7.qza \
--o-relative-frequency-table Akkermansia/GMTOLsongtableN30FamilyMergedMeanRank7Rel.qza

qiime tools export --input-path Akkermansia/GMTOLsongtableN30FamilyMergedMeanRank7Rel.qza --output-path Akkermansia/

biom convert -i Akkermansia/feature-table.biom -o Akkermansia/GMTOLsongtableN30FamilyMergedMeanRank7Rel.tsv --to-tsv

###testing alpha diversity differences across sample size

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results-GMTOLsolo2N1_V4/faith_pd_vector.qza \
  --m-metadata-file ../Merged/Jul26metadataGMTOLsong.txt \
  --o-visualization core-metrics-results-GMTOLsolo2N1_V4/faith-pd-group-significanceN1V4.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results-GMTOLsolo2N5_V4/faith_pd_vector.qza \
  --m-metadata-file ../Merged/Jul26metadataGMTOLsong.txt \
  --o-visualization core-metrics-results-GMTOLsolo2N5_V4/faith-pd-group-significanceN5V4.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results-GMTOLsolo2N20_V4/faith_pd_vector.qza \
  --m-metadata-file ../Merged/Jul26metadataGMTOLsong.txt \
  --o-visualization core-metrics-results-GMTOLsolo2N20_V4/faith-pd-group-significanceN20V4.qzv


qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results-GMTOLsolo2N1_V3V4/faith_pd_vector.qza \
  --m-metadata-file ../Merged/Jul26metadataGMTOLsong.txt \
  --o-visualization core-metrics-results-GMTOLsolo2N1_V3V4/faith-pd-group-significanceN1V4.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results-GMTOLsolo2N5_V3V4/faith_pd_vector.qza \
  --m-metadata-file ../Merged/Jul26metadataGMTOLsong.txt \
  --o-visualization core-metrics-results-GMTOLsolo2N5_V3V4/faith-pd-group-significanceN5V4.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity core-metrics-results-GMTOLsolo2N20_V3V4/faith_pd_vector.qza \
  --m-metadata-file ../Merged/Jul26metadataGMTOLsong.txt \
  --o-visualization core-metrics-results-GMTOLsolo2N20_V3V4/faith-pd-group-significanceN20V3V4.qzv

#do a singifcant test alpha diversity across Phylum level

#now I have to make a tree. Trying in python first

# installing qiime conda env on jupyter hub had to install ipykernel first

python -m ipykernel install --user --name=qiime2-2023.7

#REMEMBER to run this inside the qiime2-2023.2 env in the temrinal and then open up jupyterhub where you can immediately import qiime2!  Go to jupyter2.ucsd.edu and use sdegregori with ucsd pw 

#trying python3 since on jupyter python is running python2

python3 -m ipykernel install --user --name=qiime2-2023.7_GMTOLtree

#need to add Minich fish data
#get all raw data from qiita study id 13414 with wget

wget "https://qiita.ucsd.edu/public_download/?data=raw&study_id=13414" -O MinichFish_allraw.zip

jar xvf MinichFish_allraw.zip

#not working

  wget "https://qiita.ucsd.edu/public_download/?data=raw&study_id=13414&data_type=16S" -O MinichFish_all16S.zip

  #import the fa file into qiime

  qiime tools import \
  --type 'FeatureData[Sequence]' \
  --input-path minich_deblur_seqs_2021_150bp.fa \
  --output-path minich_seqs.qza

  #summarize the table

  qiime feature-table summarize \
  --i-table minich_deblur_150_2021_table.qza \
  --m-sample-metadata-file minich_metadata.txt \
  --o-visualization minich_table.qzv 

  
#filter the table to only include samples where env0 = hindgut

qiime feature-table filter-samples \
  --i-table minich_deblur_150_2021_table.qza \
  --m-metadata-file minich_metadata.txt \
  --p-where "env0='hindgut'" \
  --o-filtered-table minich_table_hindgut.qza

 #filter the seqs to match the hindgut table
qiime feature-table filter-seqs \
  --i-data minich_seqs.qza \
  --i-table minich_table_hindgut.qza \
  --o-filtered-data minich_seqs_hindgut.qza

#merge minich hindgut table with GMTOLsong_tableN30.qza

qiime feature-table merge \
  --i-tables ~/TOL/minich/minich_table_hindgut.qza \
  --i-tables GMTOLsong_tableN30.qza \
  --o-merged-table ~/TOL/minich/GMTOLsong_table2024.qza

#filter GMTOLsong seqs to match merged table

qiime feature-table filter-seqs \
  --i-data GMTOLsong_repseqs.qza \
  --i-table ~/TOL/minich/GMTOLsong_table2024.qza \
  --o-filtered-data ~/TOL/minich/GMTOLsong_seqs2024.qza

#filter the table features to match the repseqs file

qiime feature-table filter-features \
  --i-table ~/TOL/minich/GMTOLsong_table2024.qza \
  --m-metadata-file ~/TOL/minich/GMTOLsong_seqs2024.qza \
  --o-filtered-table ~/TOL/minich/GMTOLsong_table2024f.qza

#make a taxa bar plot of GMTOLsong_table2024.qza with Jun20GMTOLsong_metadata2024.txt and merged_GMTOL_taxonomy2024.qza

#merge table by class

qiime feature-table group \
  --i-table ~/TOL/minich/GMTOLsong_table2024f.qza \
  --p-axis sample \
  --m-metadata-file ~/TOL/minich/Jun20GMTOLsong_metadata2024.txt \
  --m-metadata-column Class \
  --p-mode mean-ceiling \
  --o-grouped-table ~/TOL/minich/GMTOLsong_table2024f_groupedClass.qza

#make a taxa bar plot with the groupedCLass

qiime taxa barplot \
  --i-table ~/TOL/minich/GMTOLsong_table2024f_groupedClass.qza \
  --i-taxonomy ~/TOL/minich/merged_GMTOL_taxonomy2024.qza \
  --o-visualization ~/TOL/minich/taxa-bar-plotsGMTOLsong2024.qzv

#import EMP500.seqs.fa into qiime

qiime tools import \
  --type 'FeatureData[Sequence]' \
  --input-path EMP500.seqs.fa \
  --output-path EMP500_seqs.qza

#filter table to only free-living samples

qiime feature-table filter-samples \
  --i-table EMP500_table.qza \
  --m-metadata-file EMP500_metadata.tsv \
  --p-where "empo_1='Free-living'" \
  --o-filtered-table EMP500_table_f.qza

#and then filter that table to include empo_2 = to Saline and Non-saline and Plant

qiime feature-table filter-samples \
  --i-table EMP500_table_f.qza \
  --m-metadata-file EMP500_metadata.tsv \
  --p-where "empo_2='Saline' OR empo_2='Non-saline' OR empo_2='Plant'" \
  --o-filtered-table EMP500_table_f.qza

 #combine emp500f table with gmtol filtered table

  qiime feature-table merge \
    --i-tables ~/TOL/minich/GMTOLsong_table2024f.qza \
    --i-tables EMP500_table_f.qza \
    --o-merged-table ~/TOL/minich/GMTOLsong_table2024f2.qza

#merge seqs

qiime feature-table merge-seqs \
  --i-data ~/TOL/minich/GMTOLsong_seqs2024.qza \
  --i-data EMP500_seqs.qza \
  --o-merged-data ~/TOL/minich/GMTOLsong_seqs2024f2.qza

#filter seqs to match table

qiime feature-table filter-seqs \
  --i-data ~/TOL/minich/GMTOLsong_seqs2024f2.qza \
  --i-table ~/TOL/minich/GMTOLsong_table2024f2.qza \
  --o-filtered-data ~/TOL/minich/GMTOLsong_seqs2024f2.qza

#do a non-phylpgenetic beta diversity core metrics

qiime diversity core-metrics \
  --i-table ~/TOL/minich/GMTOLsong_table2024f2.qza \
  --p-sampling-depth 600 \
  --m-metadata-file ~/TOL/minich/Jul2GMTOLsong_metadata2024.txt \
  --output-dir ~/TOL/minich/core-metrics-nonphylo-results-GMTOLsong2024f2_600_2

#testing filtering on file size

#filter EMP500_seqs.qza to match EMP500_table_f.qza

qiime feature-table filter-seqs \
  --i-data EMP500_seqs.qza \
  --i-table EMP500_table_f.qza \
  --o-filtered-data EMP500_seqs_f.qza

qiime feature-table merge-seqs \
  --i-data ~/TOL/minich/GMTOLsong_seqs2024.qza \
  --i-data EMP500_seqs_f.qza \
  --o-merged-data ~/TOL/minich/GMTOLsong_seqs2024f2test.qza

#seems to work now I can make tree with tree.sh

#now trying with 20

qiime feature-table merge \
  --i-tables ~/TOL/minich/minich_table_hindgut.qza \
  --i-tables /home/sdegregori/TOL/Merged/subsample/GMTOLsong_tableN20.qza \
  --i-tables ~/TOL/minich/EMP500_table_f.qza \
  --o-merged-table ~/TOL/minich/GMTOLsong_table2024_N20.qza

#merge seqs again with GMTOLsong_repseqs.qza

qiime feature-table merge-seqs \
  --i-data ~/TOL/minich/GMTOLsong_seqs2024.qza \
  --i-data ~/TOL/minich/EMP500_seqs.qza \
  --i-data ~/TOL/minich/minich_seqs.qza \
  --o-merged-data ~/TOL/minich/GMTOLsong_seqs2024_ALL.qza

and then filter seqs to match N20 table

qiime feature-table filter-seqs \
  --i-data ~/TOL/minich/GMTOLsong_seqs2024_ALL.qza \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20.qza \
  --o-filtered-data ~/TOL/minich/GMTOLsong_seqs2024_N20all.qza

  #trying emp seq

  qiime feature-table merge-seqs \
  --i-data ~/TOL/minich/GMTOLsong_seqs2024.qza \
  --i-data ~/TOL/minich/EMP500_seqs_f.qza \
  --i-data ~/TOL/minich/minich_seqs.qza \
  --o-merged-data ~/TOL/minich/GMTOLsong_seqs2024_ALL_f.qza

qiime feature-table filter-seqs \
  --i-data ~/TOL/minich/GMTOLsong_seqs2024_ALL_f.qza \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20.qza \
  --o-filtered-data ~/TOL/minich/GMTOLsong_seqs2024_N20all_f.qza

#filtering EMP samples with new metadata tsv

qiime feature-table filter-samples \
  --i-table EMP500_table_f.qza \
  --m-metadata-file EMP500_metadata2_filtered.txt \
  --o-filtered-table EMP500_table_f2.qza

  #filter EMP500_seqs.qza to match EMP500_table_f2.qza

qiime feature-table filter-seqs \
  --i-data EMP500_seqs.qza \
  --i-table EMP500_table_f2.qza \
  --o-filtered-data EMP500_seqs_f2.qza

  #merge seqs again with GMTOLsong_repseqs.qza

  qiime feature-table merge-seqs \
  --i-data ~/TOL/minich/GMTOLsong_seqs2024.qza \
  --i-data ~/TOL/minich/EMP500_seqs_f2.qza \
  --i-data ~/TOL/minich/minich_seqs.qza \
  --o-merged-data ~/TOL/minich/GMTOLsong_seqs2024_ALL_f2.qza

qiime feature-table merge \
  --i-tables ~/TOL/minich/minich_table_hindgut.qza \
  --i-tables /home/sdegregori/TOL/Merged/subsample/GMTOLsong_tableN20.qza \
  --i-tables ~/TOL/minich/EMP500_table_f2.qza \
  --o-merged-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all.qza

  #match seqs to latest table

  qiime feature-table filter-seqs \
  --i-data ~/TOL/minich/GMTOLsong_seqs2024_ALL_f2.qza \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all.qza \
  --o-filtered-data ~/TOL/minich/GMTOLsong_seqs2024_N20all_f2.qza

#group table by pref name 

qiime feature-table group \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all.qza \
  --p-axis sample \
  --m-metadata-file ~/TOL/minich/Aug8GMTOLsong_metadata_all.txt \
  --m-metadata-column 'pref name' \
  --p-mode sum \
  --o-grouped-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_groupedSpeciesSum.qza

#filter seqs to match the grouped table

qiime feature-table filter-seqs \
  --i-data ~/TOL/minich/GMTOLsong_seqs2024_ALL_f2.qza \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_groupedSpecies.qza \
  --o-filtered-data ~/TOL/minich/GMTOLsong_seqs2024_N20all_f2_groupedSpecies.qza

#run a core metrics non-phylo on the grouped table

qiime diversity core-metrics \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_groupedSpecies.qza \
  --p-sampling-depth 600 \
  --m-metadata-file ~/TOL/minich/GrpSpeciesMetadataAug8.txt \
  --output-dir ~/TOL/minich/core-metrics-nonphylo-results-GMTOLsong2024_N20_f2all_groupedSpecies_600

#export GMTOLsong_seqs2024_ALL_f2.qza

qiime tools export --input-path ~/TOL/minich/GMTOLsong_seqs2024_ALL_f2.qza --output-path ~/TOL/minich/

#run mafft on the fasta with --parttree option

mafft --parttree --thread 64 ~/TOL/minich/GMTOLall_sequences.fasta > ~/TOL/minich/GMTOLall_seqs_aligned.fasta

qiime alignment mafft \
  --p-n-threads 16 \
  --i-sequences GMTOLsong_seqs2024_N20all_f2.qza \
  --p-parttree TRUE \
  --o-alignment aligned-GMTOLsong2024f2seqs.qza \
  --verbose

  #trying to filter both datasets into V4 and V3-4 and then running tree job

  #filter GMTOLsong table to V4 with Primer2 column

  qiime feature-table filter-samples \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all.qza \
  --m-metadata-file ~/TOL/minich/Aug8GMTOLsong_metadata_all.txt \
  --p-where "Primer2='V4'" \
  --o-filtered-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4.qza

  #now filter GMTOLsong_seqs2024_N20all_f2.qza to match V4 table

  qiime feature-table filter-seqs \
  --i-data ~/TOL/minich/GMTOLsong_seqs2024_N20all_f2.qza \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4.qza \
  --o-filtered-data ~/TOL/minich/GMTOLsong_seqs2024_N20all_f2_V4.qza

#filter old GMTOL table to be V4 only with new metadata

qiime feature-table filter-samples \
--i-table ~/TOL/Merged/GMTOLsong_tablef.qza \
--m-metadata-file ~/TOL/minich/Aug8GMTOLsong_metadata_all.txt \
--p-where "Primer2='V4'" \
--o-filtered-table ~/TOL/phylo/GMTOLsong_table_old_f_V4.qza


  #filter GMTOLsong_tablef.qza to group by pref name (remember to activate qiime2023.2 instead of 7)

  qiime feature-table group \
  --i-table ~/TOL/phylo/GMTOLsong_table_old_f_V4.qza \
  --p-axis sample \
  --m-metadata-file ~/TOL/minich/Aug8GMTOLsong_metadata_all.txt \
  --m-metadata-column 'pref name' \
  --p-mode sum \
  --o-grouped-table ~/TOL/phylo/GMTOLsong_table_old_f_V4groupedSpeciesSum.qza

  #filter table to only include reads above 100 and present in 2 samples

  qiime feature-table filter-features \
  --i-table ~/TOL/phylo/GMTOLsong_table_old_f_V4groupedSpeciesSum.qza \
  --p-min-samples 2 \
  --p-min-frequency 100 \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r.qza

  conda env create -n q24.5 --file https://data.qiime2.org/distro/amplicon/qiime2-amplicon-2024.5-py39-linux-conda.yml

#do taxonomy assignment of ~/TOL/minich/GMTOLsong_seqs2024_N20all_f2_V4.qza using full length green genes

qiime feature-classifier classify-sklearn \
  --i-classifier ~/TOL/minich/2022.10.backbone.full-length.nb.qza \
  --i-reads ~/TOL/minich/GMTOLsong_seqs2024_N20all_f2_V4.qza \
  --o-classification ~/TOL/minich/GMTOLsong_taxonomy2024f2_V4.qza

#filter table to get rid of eukaryota, mitochondria, and chloroplast

qiime taxa filter-table \
  --i-table ~/TOL/phylo/GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r.qza \
  --i-taxonomy ~/TOL/minich/merged_GMTOL_taxonomy2024_N20_f2_V4.qza \
  --p-exclude 'k__Eukaryota','k__Mitochondria','k__Chloroplast' \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_f.qza

  #rarefy to 1000 reads as well now

  qiime feature-table rarefy \
  --i-table ~/TOL/phylo/GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r.qza \
  --p-sampling-depth 1000 \
  --o-rarefied-table ~/TOL/phylo/GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar.qza

  #export the table 

  qiime tools export --input-path ~/TOL/phylo/GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar.qza --output-path ~/TOL/phylo/

  #and then convert it to txt

  biom convert -i GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar.biom -o GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar.tsv --to-tsv

#filter GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar.qza by GrpSpeciesMetadataAug8.txt

  qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar.qza \
  --m-metadata-file ~/TOL/minich/GrpSpeciesMetadataAug8.txt \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar_f.qza

#do core metrics of table at 1k reads on GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar.qza

    qiime diversity core-metrics \
  --i-table ~/TOL/phylo/GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar_f.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file ~/TOL/minich/GrpSpeciesMetadataAug8.txt \
  --output-dir ~/TOL/phylo/core-metrics-nonphylo-results-GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar_f.qza

  #then export the bray_curtis_distance_matrix.qza and the bray_curtis_pcoa_results.qza

  qiime tools export --input-path ~/TOL/phylo/core-metrics-nonphylo-results-GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar_f.qza/bray_curtis_distance_matrix.qza --output-path ~/TOL/phylo/

  qiime tools export --input-path ~/TOL/phylo/core-metrics-nonphylo-results-GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar_f.qza/bray_curtis_pcoa_results.qza --output-path ~/TOL/phylo/

#trying things in jupyter to filter host tree and table to match

python -m ipykernel install --user --name=q24.5

#convert the filtered metadata I did in jupyter into a text file so I can bring it in terminal and do it so there is no index column

host_md2.to_csv('GrpSpeciesMetadataAug21_hostf.txt', sep='\t') #send to jupyter

#filter qiime Grp table to match filtered host metadata

qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar_f.qza \
  --m-metadata-file ~/TOL/phylo/GrpSpeciesMetadataAug21_hostf.txt \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar_f_hostf.qza


#write python code to filter samples using qiime2 python API using metadata

import pandas as pd
import qiime2
from qiime2 import Metadata

#load in the metadata
host_md = pd.read_csv('GrpSpeciesMetadataAug21_hostf.txt', sep='\t', index_col=0)

#load in the table
table = qiime2.Artifact.load('GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar_f.qza')

#load in the metadata
metadata = Metadata.load('GrpSpeciesMetadataAug21_hostf.txt')

#filter the table

table_hostf = table.filter_samples(metadata.ids(axis='sample'), inplace=False)

#not sure if this is right

#export GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar_f_hostf.qza as txt file

qiime tools export --input-path ~/TOL/phylo/GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar_f_hostf.qza --output-path ~/TOL/phylo/

#convert to tsv

biom convert -i feature-table.biom -o GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar_f_hostf.tsv --to-tsv


#now trying to collapse this version to phyla and see if it is small enough to run. Collapse GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar_f_hostf.qza to phylum level with merged_GMTOL_taxonomy2024_N20_f2_V4.qza

#doesnt work. not all ASVs are in taxa so try filtering table with GMTOLsong_seqs2024_N20all_f2.qza

  qiime feature-table filter-features \
  --i-table ~/TOL/phylo/GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar_f_hostf.qza \
  --m-metadata-file ~/TOL/minich/GMTOLsong_seqs2024_N20all_f2_V4.qza \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar_f_hostf_f.qza

#now works but cuts the file in half? seems too much
qiime taxa collapse \
  --i-table ~/TOL/phylo/GMTOLsong_table_old_f_V4groupedSpeciesSum_2s100r_1krar_f_hostf_f.qza \
  --i-taxonomy ~/TOL/minich/merged_GMTOL_taxonomy2024f2.qza \
  --p-level 2 \
  --o-collapsed-table ~/TOL/phylo/GrpTablePhylum.qza

  #export and convert to tsv

  qiime tools export --input-path ~/TOL/phylo/GrpTablePhylum.qza --output-path ~/TOL/phylo/

  biom convert -i feature-table.biom -o GrpTablePhylum.tsv --to-tsv

  ~~~##lost data REMEMBER TO SAVE


  qiime gemelli phylogenetic-rpca-without-taxonomy \
    --i-table ~/TOL/FINAL_FILES/GMTOL_table2.qza \
    --i-phylogeny ~/TOL/FINAL_FILES/GMTOL_rooted_tree2.qza \
    --p-min-feature-count 10 \
    --p-min-sample-count 500 \
    --o-biplot ~/TOL/FINAL_FILES/GMTOLoldJun12_23_rpca_biplot.qza \
    --o-distance-matrix ~/TOL/FINAL_FILES/GMTOLoldJun12_23_rpca_distance_matrix.qza \
    --o-counts-by-node-tree ~/TOL/FINAL_FILES/GMTOLoldJun12_23_rpca_counts_by_node_tree.qza \
    --o-counts-by-node ~/TOL/FINAL_FILES/GMTOLoldJun12_23_rpca_counts_by_node_phylotable.qza \
    --p-min-depth 1 \
    --verbose

echo "Finishing gemelli  job"

#run qiime gemelli rpca on GMTOLsong_table2024_N20_f2all_V4_herb.qza with 5 components

  qiime gemelli rpca \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_herb.qza \
  --p-n-components 5 \
  --o-biplot ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_herb_rpca_biplot.qza \
  --o-distance-matrix ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_herb_rpca_distance_matrix.qza \
  --verbose

  #export GMTOL solo N30 table as a biom file

  qiime tools export --input-path GMTOLsolo_tableN30.qza  --output-path .

#make Amphibia table from GMTOL_table2.qza

qiime feature-table filter-samples \
  --i-table ~/TOL/FINAL_FILES/GMTOL_table2.qza \
  --m-metadata-file ~/TOL/FINAL_FILES/GMTOL_metadata2.txt \
  --p-where "Class='Amphibia' OR Class='Amphibian'" \
  --o-filtered-table ~/TOL/FINAL_FILES/GMTOL_table2_Amphibia.qza

#had to do it on qiime2023.2 instead .7 

qiime dev refresh-cache
  
  #runninng qiime gemelli phylogenetic-rpca on GMTOL_table2_Amphibia.qza

  qiime gemelli phylogenetic-rpca \
    --i-table ~/TOL/FINAL_FILES/GMTOL_table2_Amphibia.qza \
    --i-taxonomy ~/TOL/FINAL_FILES/GMTOL_taxonomy2.qza \
    --i-phylogeny ~/TOL/FINAL_FILES/GMTOL_rooted_tree2.qza \
    --p-min-feature-count 100 \
    --p-min-sample-count 500 \
    --o-biplot ~/TOL/FINAL_FILES/GMTOL_Amphibia_rpca_biplot.qza \
    --o-distance-matrix ~/TOL/FINAL_FILES/GMTOL_Amphibia_rpca_distance_matrix.qza \
    --o-counts-by-node-tree ~/TOL/FINAL_FILES/GMTOL_Amphibia_rpca_counts_by_node_tree.qza \
    --o-counts-by-node ~/TOL/FINAL_FILES/GMTOL_Amphibia_rpca_counts_by_node_phylotable.qza \
    --p-min-depth 1 \
    --verbose

export amphibian table 

qiime tools export --input-path GMTOL_table2_Amphibia.qza --output-path export

#export tree and taxonomy 

qiime tools export --input-path GMTOL_rooted_tree2.qza --output-path export
qiime tools export --input-path GMTOL_taxonomy2.qza --output-path export

now run phylogenetic-rpca on exported files

gemelli phylogenetic-rpca \
  --in-biom export/feature-table.biom \
  --taxonomy export/taxonomy.tsv \
  --in-phylogeny export/tree.nwk \
  --output-dir export \
  --min-feature-count 100 \
  --min-sample-count 500 \
  --min-depth 10 

#now import labeled-phylogeny.nwk ordination.txt ordination.txt phylo-table.biom and t2t-taxonomy.tsv into qiime2

qiime tools import \
  --type 'Phylogeny[Rooted]' \
  --input-path export/labeled-phylogeny.nwk \
  --output-path export/labeled-phylogeny.qza

qiime tools import \
  --type 'PCoAResults' \
  --input-path export/ordination.txt \
  --output-path export/ordination.qza

qiime tools import \
  --type 'FeatureTable[Frequency]' \
  --input-path export/phylo-table.biom \
  --output-path export/phylo-table.qza

#now plot community empress biplot with imported files

qiime empress community-plot \
  --i-feature-table export/phylo-table.qza \
  --i-tree export/labeled-phylogeny.qza \
  --i-pcoa export/ordination.qza \
  --m-sample-metadata-file GMTOL_metadata2.txt \
  --m-feature-metadata-file export/t2t-taxonomy.tsv \
  --p-filter-missing-features \
  --o-visualization export/community-plot.qzv
 
#now export the V4 GMTOL table and tree and taxonomy

qiime tools export --input-path GMTOLsong_table2024_N20_f2all_V4.qza --output-path export
#now the GMTOLsong_rooted_tree2024f2.qza file

qiime tools export --input-path GMTOLsong_rooted_tree2024f2.qza --output-path export

#now the GMTOLsong_taxonomy2024f2_V4.qza file

qiime tools export --input-path merged_GMTOL_taxonomy2024_N20all_f2_V4.qza --output-path export

#run gemelli phylogenetic-rpca on exported files

gemelli phylogenetic-rpca \
  --in-biom export/feature-table.biom \
  --taxonomy export/taxonomy.tsv \
  --in-phylogeny export/tree.nwk \
  --output-dir export \
  --min-feature-count 100 \
  --min-sample-count 500 \
  --min-depth 100

#so i ran this on slurm with 100 depth and it seemed to work. 

qiime gemelli phylogenetic-rpca-with-taxonomy \
    --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4.qza \
    --i-phylogeny ~/TOL/minich/GMTOLsong_rooted_tree2024f2.qza \
    --m-taxonomy-file ~/TOL/minich/merged_GMTOL_taxonomy2024_N20all_f2_V4.qza \
    --p-min-feature-count 100 \
    --p-min-sample-count 1000 \
    --o-biplot ~/TOL/minich/GMTOLsong_rpca_biplot.qza \
    --o-distance-matrix ~/TOL/minich/GMTOLsong_rpca_distance_matrix.qza \
    --o-counts-by-node-tree ~/TOL/minich/GMTOLsong_rpca_counts_by_node_tree.qza \
    --o-counts-by-node ~/TOL/minich/GMTOLsong_rpca_counts_by_node_phylotable.qza \
    --o-t2t-taxonomy ~/TOL/minich/GMTOLsong_rpca_taxonomy.qza \
    --p-min-depth 100 \
    --verbose

#visualize above files with empress plot

qiime empress community-plot \
  --i-feature-table ~/TOL/minich/GMTOLsong_rpca_counts_by_node_phylotable.qza \
  --i-tree ~/TOL/minich/GMTOLsong_rpca_counts_by_node_tree.qza \
  --i-pcoa ~/TOL/minich/GMTOLsong_rpca_biplot.qza \
  --m-sample-metadata-file ~/TOL/minich/Sep12GMTOLsong_metadata_all.txt \
  --m-feature-metadata-file ~/TOL/minich/GMTOLsong_rpca_taxonomy.qza \
  --p-filter-missing-features \
  --o-visualization ~/TOL/minich/GMTOLsong_rpca_empress.qzv


#make taxa bar plot out of GMTOLsong_table2024_N20_f2all_V4_GrpSimpClassDiet.qza

qiime taxa barplot \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_GrpSimpClassDiet.qza \
  --i-taxonomy ~/TOL/minich/merged_GMTOL_taxonomy2024_N20all_f2_V4.qza \
  --o-visualization ~/TOL/minich/taxa-bar-plotsGMTOLsong2024_N20_f2all_V4_GrpSimpClassDiet.qzv


# filter ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4.qza  to only include Actinopterygii and Mammalia and Aves and Reptilia and Insecta for Class and where DietSimp doesn't equal 'NA' or 'Unknown' or 'unknown'

qiime feature-table filter-samples \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4.qza \
  --m-metadata-file ~/TOL/minich/Oct24GMTOLsong_metadata_all.txt \
  --p-where "Class='Actinopterygii' OR Class='Mammalia' OR Class='Aves' OR Class='Reptilia' OR Class='Insecta' AND DietSimp!='NA' AND DietSimp!='Unknown' AND DietSimp!='unknown'" \
  --o-filtered-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_GrpSimpClass.qza

mv ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_GrpSimpClass.qza ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_SimpClass.qza

#now run core metrics on the filtered table

qiime diversity core-metrics-phylogenetic \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_SimpClass.qza \
  --i-phylogeny ~/TOL/minich/GMTOLsong_rooted_tree2024f2.qza \
  --p-sampling-depth 600 \
  --m-metadata-file ~/TOL/minich/Oct24GMTOLsong_metadata_all.txt \
  --output-dir ~/TOL/minich/core-metrics-nonphylo-results-GMTOLsong2024_N20_f2all_V4_SimpClass_600

#now do a beta sig test on DietClassSimp on unifrac distances

qiime diversity beta-group-significance \
  --i-distance-matrix ~/TOL/minich/core-metrics-nonphylo-results-GMTOLsong2024_N20_f2all_V4_SimpClass_600/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ~/TOL/minich/Oct24GMTOLsong_metadata_all.txt \
  --m-metadata-column DietClassSimp \
  --o-visualization ~/TOL/minich/beta-group-significance-DietClassSimp-unweighted-unifrac600.qzv \
  --p-pairwise

#now lets do 400 sampling depth

qiime diversity core-metrics-phylogenetic \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_SimpClass.qza \
  --i-phylogeny ~/TOL/minich/GMTOLsong_rooted_tree2024f2.qza \
  --p-sampling-depth 400 \
  --m-metadata-file ~/TOL/minich/Oct24GMTOLsong_metadata_all.txt \
  --output-dir ~/TOL/minich/core-metrics-results-GMTOLsong2024_N20_f2all_V4_SimpClass_400

#need to figure out how to get more taxa in the Grp table species that actually line up in the tree

#summarize GMTOLsong_table2024_N20_f2all_V4_GrpSpecies.qza

#filter GMTOLsong_table2024_N20_f2all_V4_GrpSpecies.qza to match  GrpSpeciesMetadataAug8.txt

    qiime feature-table filter-samples \
    --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_GrpSpecies.qza \
    --m-metadata-file ~/TOL/minich/GrpSpeciesMetadataAug8.txt \
    --o-filtered-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_GrpSpecies.qza

qiime feature-table summarize \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_GrpSpecies.qza \
  --m-sample-metadata-file ~/TOL/minich/GrpSpeciesMetadataAug8.txt \
  --o-visualization ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_GrpSpecies.qzv

#So the GrpSpecies table that is collapsed to phyla is the old GMTOL table... I need to collapse new one but it is not going to match the tree I think..will have to check. Because new should have more species which would explain why I lost species using old one

GMTOLsong_seqs2024_N20all_f2.qza
GMTOLsong_table2024_N20_f2all.qza

#summarize table 
qiime feature-table summarize \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all.qza \
  --m-sample-metadata-file ~/TOL/minich/Oct24GMTOLsong_metadata_all.txt \
  --o-visualization ~/TOL/minich/GMTOLsong_table2024_N20_f2all.qzv

  #collapse table by 'pref name'

    qiime feature-table group \
        --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all.qza \
        --p-axis sample \
        --m-metadata-file ~/TOL/minich/Oct24GMTOLsong_metadata_all.txt \
        --m-metadata-column 'pref name' \
        --p-mode sum \
        --o-grouped-table ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpecies.qza

#then summarize it

qiime feature-table summarize \
  --i-table ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpecies.qza \
  --m-sample-metadata-file ~/TOL/minich/Oct24GMTOLsong_metadata_all.txt \
  --o-visualization ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpecies.qzv

  #now collapsing V4 table to make additional pltos for katie with divergence vs ClassRelAbund
#collapse GMTOLsong_table2024_N20_f2all_V4.qza to Class level

qiime taxa collapse \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_GrpSpecies.qza \
  --i-taxonomy ~/TOL/minich/merged_GMTOL_taxonomy2024_N20all_f2_V4.qza \
  --p-level 3 \
  --o-collapsed-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_GrpSpecies_Class.qza


  #export the table as tsv

    qiime tools export --input-path ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_GrpSpecies_Class.qza --output-path ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_GrpSpecies_Class.biom

    biom convert -i GMTOLsong_table2024_N20_f2all_V4_GrpSpecies_Class.biom/feature-table.biom -o GMTOLsong_table2024_N20_f2all_V4_GrpSpecies_Class.tsv --to-tsv

#filter Grp table to match GrpSpeciesMetadataAug8.txt

    qiime feature-table filter-samples \
    --i-table ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpecies.qza \
    --m-metadata-file ~/TOL/minich/GrpSpeciesMetadataAug8.txt \
    --o-filtered-table ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf.qza

#first need to summarize grpAll table to see how many hosts I should cut off

qiime feature-table summarize \
    --i-table ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf.qza \
    --m-sample-metadata-file ~/TOL/minich/GrpSpeciesMetadataAug8.txt \
    --o-visualization ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf.qzv


  #filter table to exclude 400 or less reads so I dont waste time on making host tree of low read samples

    qiime feature-table filter-features \
    --i-table ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf.qza \
    --p-min-frequency 400 \
    --o-filtered-table ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf400.qza


#playing detective and seeing why i am losing samples when I grp V4GMTOLsong table

GMTOLsong_tableNov2024_N20_f2all_grpSpecies

#first filter the table to match the metadata file GrpSpeciesMetadataAug8.txt

qiime feature-table filter-samples \
  --i-table ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpecies.qza \
  --m-metadata-file ~/TOL/minich/GrpSpeciesMetadataAug8.txt \
  --o-filtered-table ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpecies.qza

  #summarize the table

qiime feature-table summarize \
  --i-table ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpecies.qza \
  --m-sample-metadata-file ~/TOL/minich/GrpSpeciesMetadataAug8.txt \
  --o-visualization ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpecies.qzv

  #export GMTOLsong_table2024_N20_f2all_V4.qza to biom then tsv

 qiime tools export --input-path ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4.qza --output-path ~/TOL/minich/exportN20allV4 

  biom convert -i exportN20allV4/feature-table.biom -o exportN20allV4/GMTOLsong_table2024_N20_f2all_V4.tsv --to-tsv

 # filter  GMTOLsong_table2024_N20_f2all.qza with latest metadata Oct24GMTOLsong_metadata_all.txt for Primer2 = V4

#first filter table to match metadata

qiime feature-table filter-samples \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all.qza \
  --m-metadata-file ~/TOL/minich/Oct24GMTOLsong_metadata_all.txt \
  --o-filtered-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_f.qza

  #now filter samples for V4

qiime feature-table filter-samples \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_f.qza \
  --m-metadata-file ~/TOL/minich/Oct24GMTOLsong_metadata_all.txt \
  --p-where "Primer2='V4'" \
  --o-filtered-table ~/TOL/minich/GMTOLsong_table2024_N20_f2allf_V4v2.qza


#testing Grp species again making a v2 grouped table by pref name on GMTOLsong_table2024_N20_f2all_f.qza

qiime feature-table group \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_f.qza \
  --p-axis sample \
  --m-metadata-file ~/TOL/minich/Oct24GMTOLsong_metadata_all.txt \
  --m-metadata-column 'pref name' \
  --p-mode sum \
  --o-grouped-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_grpSpecies_v2.qza

#summarize GMTOLsong_table2024_N20_f2allf_V4v2.qza

qiime feature-table summarize \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2allf_V4v2.qza \
  --o-visualization ~/TOL/minich/GMTOLsong_table2024_N20_f2allf_V4v2.qzv

#and summarize GMTOLsong_table2024_N20_f2all_V4.qza as well

qiime feature-table summarize \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4.qza \
  --o-visualization ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4.qzv

#making fish table to see what I have filter GMTOLsong_table2024_N20_f2all_V4.qza to only include Actinopterygii with Oct24GMTOLsong_metadata_all.txt

qiime feature-table filter-samples \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4.qza \
  --m-metadata-file ~/TOL/minich/Oct24GMTOLsong_metadata_all.txt \
  --p-where "Class='Actinopterygii'" \
  --o-filtered-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_fish.qza

#run core metrics on fish table

qiime diversity core-metrics-phylogenetic \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_fish.qza \
  --i-phylogeny ~/TOL/minich/GMTOLsong_rooted_tree2024f2.qza \
  --p-sampling-depth 400 \
  --m-metadata-file ~/TOL/minich/Oct24GMTOLsong_metadata_all.txt \
  --output-dir ~/TOL/minich/core-metrics-results-GMTOLsong2024_N20_f2all_V4_fish_400

  #filter the seqs file to match fish table

  qiime feature-table filter-seqs \
  --i-data ~/TOL/minich/GMTOLsong_seqs2024_N20all_f2.qza \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_fish.qza \
  --o-filtered-data ~/TOL/minich/GMTOLsong_seqs2024_N20all_f2_fish.qza

  #run core microbiome analysis 

#first install #seems like i need to do in 2020.11 qiime version
conda install -c richrr q2-coremicrobiome

#first import the biom so it is a 2020.11 version table

qiime tools import --input-path exportN20allV4/feature-table.biom --output-path ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_2020.11.qza --type 'FeatureTable[Frequency]' --input-format BIOMV210Format
#then run

qiime coremicrobiome full-pipeline --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_2020.11.qza --p-factor DietSimp --p-group Herbivore --p-outputfile coremic.q2 --m-groupfile-file Oct24GMTOLsong_metadata_all_SampleID.txt --p-make-relative --o-visualization Herbivore_Core_V4.qzv

#checking the seqs.qzv of GMTOLsong_seqs2024_N20all_f2.qza using qiime summary sequences function to see why so many samples are missing..could be from denoising them.
#summarize the demux.qza file called GMTOLsong_seqs2024_N20all_f2.qza to see sequences per sample

qiime feature-table tabulate-seqs \
  --i-data ~/TOL/minich/GMTOLsong_seqs2024_N20all_f2.qza \
  --o-visualization ~/TOL/minich/GMTOLsong_seqs2024_N20all_f2.qzv


#grouping the GMTOLsong_tableNov2024_N20_f2all_grpSpecies.qza table to timetree2 names with GrpSpeciesMetadataFeb11_ 25.txt and seeing if I can classify this with full length backbone

qiime feature-table group \
  --i-table ~/TOL/phylo/GMTOLsong_tableNov2024_N20_f2all_grpSpecies.qza \
  --p-axis sample \
  --m-metadata-file ~/TOL/phylo/GrpSpeciesMetadataFeb11_ 25.txt \
  --m-metadata-column 'timetree2' \
  --p-mode sum \
  --o-grouped-table ~/TOL/phylo/GMTOLsong_tableNov2024_N20_f2all_grpSpecies_timetree2.qza

#export GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf.qza in minich folder as atsv file and write the code with linebreaks please, and use \ to line break the code

qiime tools export \
--input-path ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf.qza \
--output-path ~/TOL/phylo/exportGMTOLsong_tableNov2024_N20_f2all_grpSpeciesf 

biom convert \
-i ~/TOL/phylo/exportGMTOLsong_tableNov2024_N20_f2all_grpSpeciesf/feature-table.biom \
-o ~/TOL/phylo/exportGMTOLsong_tableNov2024_N20_f2all_grpSpeciesf.tsv \
--to-tsv 

#import exportGMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed.tsv as biom into qiime2
#so first convert to biom 
#then import into qiime2

#convert GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed.tsv to biom

biom convert \
  -i exportGMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed.tsv \
  -o GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed.biom \
  --table-type="OTU table" \
  --to-hdf5

qiime tools import \
  --input-path GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed.biom \
  --output-path GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed.qza \
  --type 'FeatureTable[Frequency]'

#and now group this table with GrpSpeciesFeb12_metadata_renamed.txt (I used vim to copy paste to fix ascii error) and column timetree2

qiime feature-table group \
  --i-table GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed.qza \
  --m-metadata-file GrpSpeciesFeb12_metadata_renamed.txt \
  --m-metadata-column timetree2 \
  --p-mode sum \
  --p-axis sample \
  --o-grouped-table GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2.qza


#make taxonomy file on entire seqs file

qiime feature-classifier classify-sklearn \
  --i-classifier ~/TOL/minich/2022.10.backbone.full-length.nb.qza \
  --i-reads ~/TOL/minich/GMTOLsong_seqs2024_N20all_f2.qza \
  --o-classification ~/TOL/minich/GMTOLsong_taxonomyN20all_2024f2.qza

  #make qzv file of GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2.qza

    qiime feature-table summarize \
        --i-table GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2.qza \
        --o-visualization GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2.qzv

 #make taxa bar plot with GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2.qza and GMTOLsong_taxonomyN20all_2024f2.qza
 #also deleting underscores cuz apparently qiime2 didnt read in the dashes? well firs tI am trying without metadata

mv ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2.qza ~/TOL/phylo/
mv ~/TOL/minich/GMTOLsong_taxonomyN20all_2024f2.qza ~/TOL/phylo/

  qiime taxa barplot \
    --i-table GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2.qza \
    --i-taxonomy GMTOLsong_taxonomyN20all_2024f2.qza \
    --o-visualization GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_taxa-bar.qzv 

#filter out d__Bacteria;__ Unassigned;__ d__Bacteria;p__ from GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2.qza

qiime taxa filter-table \
  --i-table GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2.qza \
  --i-taxonomy GMTOLsong_taxonomyN20all_2024f2.qza \
  --p-include "p__" \
  --o-filtered-table GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt.qza

#filter out sample with less than 100 reads

qiime feature-table filter-samples \
  --i-table GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt.qza \
  --p-min-frequency 100 \
  --o-filtered-table GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt100.qza

#now make a taxa bar plot on the above table

qiime taxa barplot \
  --i-table GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt100.qza \
  --i-taxonomy GMTOLsong_taxonomyN20all_2024f2.qza \
  --o-visualization GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt100_taxa-bar.qzv

#YOU HAVE TO CHANGE FONT IN EXCEL TO MAKE IT WORK...doesnt matter about text file format

#make taxa barplot of ng_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt.qza to compare

qiime taxa barplot \
  --i-table GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt.qza \
  --i-taxonomy GMTOLsong_taxonomyN20all_2024f2.qza \
  --o-visualization GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt_taxa-bar_unfilt.qzv












