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

srun --time=24:00:00 --partition=short --mem=64G -n 4 --pty bash -l 
zsh
conda activate /home/sdegregori/miniconda3/envs/qiime2-2023.7 

srun --time=8:00:00 --partition=short --mem=64G -n 4 --pty bash -l 
zsh
conda activate qiime2-amplicon-2024.10

srun --time=12:00:00 --partition=short --mem=64G -n 4 --pty bash -l 
zsh
conda activate /home/sdegregori/miniconda3/envs/qiime2-2023.2

srun --time=12:00:00 --partition=rocky9_test --mem=64G -n 1 --pty bash -l 
srun --time=12:00:00 --partition=short --mem=64G -n 1 --pty bash -l 
srun --time=24:00:00 --partition=short --mem=64G -n 4 --pty bash -l 

bash
conda activate qiime2-2023.7
df -h
conda activate /home/sdegregori/miniconda3/envs/qiime2-2023.7 
conda activate /home/sdegregori/miniconda3/envs/birdmanlucas
conda activate /home/sdegregori/miniconda3/envs/q24.5
conda activate /home/sdegregori/miniconda3/envs/qiime2-2023.2
conda activate /home/sdegregori/miniconda3/envs/qiime2-amplicon-2024.10


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

#this is missing FirmicutesAD table and then the subsequent empress plots I made

#now I want to try running Birdman

#installing qiime2 2024.5 ..had to do it on rocky_9 because glibc is updated there
#doesnt work still for birdman so now trying on normal barnacle by changing c-ares to different version

conda env create -n q24.5v2 --file qiime2-amplicon-2024.5-py39-linux-conda.yml

conda activate qiime2-2024.5

cd ./q2-birdman

git clone https://github.com/lucaspatel/q2-birdman.git

cd q2-birdman
conda env create -n q2-birdman-dev --file ./environments/q2-birdman-qiime2-tiny-2025.4-barnacle.yml
conda activate q2-birdman-dev

module load gcc_9.3.0
module load cmake_3.18.2

#trying to install cmdstanpy first 
pip uninstall cmdstanpy
conda install -c conda-forge cmdstanpy=0.9.76
#now trying conda install -c conda-forge cmdstan=2.33.1

conda install -c conda-forge cmdstan=2.33.1

#seems to not work above due to linux incompaitbility issues

conda env create -f BIRDMAn-CLI/birdman_env.yml -n birdman
conda activate birdman

cd BIRDMAn-CLI
pip install -e .

#run birdman-cli where Class is the metadata column of interest
birdman-cli run -i GMTOLsong_table2024_N20_f2all_V4.biom -o birdmanout2 -m Feb26_25_GMTOLsong_metadata_all.txt -f 'Chordata'

#not working so trying birdman base 

conda install -c conda-forge cmdstanpy

#doing kernel thing

python -m ipykernel install --user --name=birdman

#have to fix metadata to match for CLI to work and 

#filter GMTOLsong_table2024_N20_f2all_V4.qza to match Mar1_25_GMTOL_metadata_Vert.txt in qiime2

qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4.qza \
  --m-metadata-file ~/TOL/phylo/Mar1_25_GMTOL_metadata_Vert.txt \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert.qza

#and then export that table to folder called GMTOLsong_table2024_N20_f2all_V4_Vert

qiime tools export --input-path ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert.qza --output-path ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert

#and then rename biome file to GMTOLsong_table2024_N20_f2all_V4_Vert.biom

mv ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert/feature-table.biom ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert/GMTOLsong_table2024_N20_f2all_V4_Vert.biom

#now running BIRDMAN again

birdman-cli run -i ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert.biom -o birdmanout5 -m ~/TOL/phylo/Mar1_25_GMTOL_metadata_Vert.txt -f "Chordata"

mv ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert/GMTOLsong_table2024_N20_f2all_V4_Vert.biom ~/TOL/phylo/

#not working again so I am updating cmdstampy and arviz to match Lucas's which ended up helping and on to a new error though

conda install -c conda-forge arviz=0.17.1 cmdstanpy=1.0.7

#trying coremicrobiome again

qiime coremicrobiome full-pipeline --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_2020.11.qza --p-factor DietSimp --p-group Herbivore --p-outputfile coremic.q2 --m-groupfile-file Oct24GMTOLsong_metadata_all_SampleID.txt --p-make-relative --o-visualization Herbivore_Core_V4.qzv

#installing latest sra toolkit

#Download the file for ubuntu system
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-centos_linux64.tar.gz
# Unzip the archive
tar xzvf sratoolkit.current-centos_linux64.tar.gz

export PATH=$PATH:~/sratoolkit.3.2.0-centos_linux64/bin

#in python
from q2sra import Proj
proj = Proj('my_proj')

proj.add_field('Hello', required = True)
proj.add_field('Country', required = True)

proj.run('BaldiBraatBangladesh2024', 'PRJNA1081952')


#ok Now trying to add Ack Faec data to the table that I used for generating the tree fig

#filter out Akkermansia muciniphila and Faecalibacterium prausnitzii from GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt.qza

qiime taxa filter-table \
  --i-table GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt.qza \
  --i-taxonomy GMTOLsong_taxonomyN20all_2024f2.qza \
  --p-include muciniphila,prausnitzii \
  --o-filtered-table GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt_AkkFae.qza

  #then make a taxa bar plot of the above table

qiime taxa barplot \
  --i-table GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt_AkkFae.qza \
  --i-taxonomy GMTOLsong_taxonomyN20all_2024f2.qza \
  --o-visualization GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt_AkkFae_taxa-bar.qzv

  ~~~~~~~~~~~
  #running Beta significance qiime2 on GMTOLsong_table2024_N20_f2all_V4.qza for Class 

  qiime diversity beta-group-significance \
  --i-distance-matrix ~/TOL/minich/core-metrics-phylo-results-GMTOLsong_tableN20_V4_1k/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ~/TOL/phylo/Oct24GMTOLsong_metadata_all_SampleID.txt \
  --m-metadata-column Class \
  --o-visualization ~/TOL/phylo/beta-significance-GMTOLsong_V4_Class-unweighted_unifrac.qzv \
  --p-pairwise

#convert GMTOLsong_table2024_N20_f2all_V4_Vert.biom to tsv

biom convert -i GMTOLsong_table2024_N20_f2all_V4_Vert.biom -o GMTOLsong_table2024_N20_f2all_V4_Vert.tsv --to-tsv

#filter GMTOLsong_table2024_N20_f2all_V4_Vert.qza to samples with more than 100 reads and samples with less than 200000 reads

qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert.qza \
  --p-min-frequency 100 \
  --p-max-frequency 200000 \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k.qza

  #and filter features with less than 10 reads and dont show up in 2 samples

qiime feature-table filter-features \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k.qza \
  --p-min-frequency 10 \
  --p-min-samples 2 \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2.qza

  #and then group them by species2

qiime feature-table group \
--i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2.qza \
--p-axis sample \
--m-metadata-file ~/TOL/phylo/Feb26_25_GMTOLsong_metadata_all.txt \
--m-metadata-column 'species2' \
--p-mode median-ceiling \
--o-grouped-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2_Grpspecies2.qza


#trying coremic again with lower p-min-frac to 0.5 for Chordata Vertebrate

qiime coremicrobiome full-pipeline \
--i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_2020.11.qza \
--p-factor Chordata \
--p-group Vertebrate \
--p-outputfile coremic.q2Vert \
--m-groupfile-file Feb26_25_GMTOLsong_metadata_allVert.txt \
--p-make-relative --p-min-frac 0.5 \
--o-visualization Vert_Core_V4_2020.11.qzv \
--verbose

#trying to relax the p-min-frac to 0.3 and doing Class Insecta to try something smaller.

qiime coremicrobiome full-pipeline \  
--i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_2020.11.qza \
--p-factor Class \
--p-group Insecta \
--p-outputfile coremic.q2Insecta \
--m-groupfile-file Feb26_25_GMTOLsong_metadata_allVert.txt \
--p-make-relative --p-min-frac 0.3 \
--p-max-p 0.1 \
--o-visualization Insecta_Core_V4_2020.11.qzv \
--verbose

~~~~~~~~~~~~~~~

#Filtering ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2.qza to only include Class equal to Insecta and Mammalia

qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2.qza \
  --m-metadata-file ~/TOL/phylo/Feb26_25_GMTOLsong_metadata_all.txt \
  --p-where "Class='Insecta' OR Class='Mammalia'" \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2_InsectaMamm.qza


#summarize GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2_Grpspecies2.qza with GrpSpeciesmetadata

#filter table and metadata

qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2_Grpspecies2.qza \
  --m-metadata-file ~/TOL/phylo/GrpSpeciesMetadataFeb20_25_underscore.txt \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2_Grpspecies2.qza

qiime feature-table summarize \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2_Grpspecies2.qza \
  --m-sample-metadata-file ~/TOL/phylo/GrpSpeciesMetadataFeb20_25_underscore.txt \
  --o-visualization ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2_Grpspecies2.qzv

#convert table to biom

qiime tools export --input-path ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2_Grpspecies2.qza --output-path ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2_Grpspecies2

change the name of the biom file to GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2_Grpspecies2.biom

mv ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2_Grpspecies2/feature-table.biom ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2_Grpspecies2.biom

#filter table to only include Class==Mammalia or Chordata==Invertebrate

qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2_Grpspecies2.qza \
  --m-metadata-file ~/TOL/phylo/GrpSpeciesMetadataFeb20_25_underscore.txt \
  --p-where "Class='Mammalia' OR Chordata='Invertebrate'" \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2_Grpspecies2_MamInvert.qza



#now I would like to make a table with just Fusobacterium species GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt.qza

#convert GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt.qza to relative abundance

qiime feature-table relative-frequency \
  --i-table GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt.qza \
  --o-relative-frequency-table GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt_rel.qza

#below doesnt accept relative freq so I use original 
qiime taxa filter-table \
  --i-table GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt.qza \
  --i-taxonomy GMTOLsong_taxonomyN20all_2024f2.qza \
  --p-include "Fusobacterium" \
  --o-filtered-table GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt_Fusobacterium.qza

#collapse above table to species

qiime taxa collapse \
  --i-table GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt_Fusobacterium.qza \
  --i-taxonomy GMTOLsong_taxonomyN20all_2024f2.qza \
  --p-level 7 \
  --o-collapsed-table GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt_Fusobacterium_species.qza

  #export the filtered Fusobacterium table to biom and then tsv

qiime tools export \
  --input-path GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt_Fusobacterium_species.qza \
  --output-path ~/TOL/phylo/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt_Fusobacterium_species
biom convert \
  -i ~/TOL/phylo/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt_Fusobacterium_species/feature-table.biom \
  -o ~/TOL/phylo/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2_filt_Fusobacterium_species.tsv \
  --to-tsv


  ~~~~~~~~
  #converting this into above 100 reads GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2_Grpspecies2.qza features use filter-features to only features with more than 100 reads

qiime feature-table filter-features \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2_Grpspecies2.qza \
  --p-min-frequency 100 \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2.qza

  #install wget with homebrew (doing for this mac mini to work off barancle)

brew install wget

#some of this code mightve been done on DUmpy so watch for paths


qiime feature-table filter-features \
  --i-table GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2_Grpspecies2.qza \
  --p-min-frequency 100 \
  --o-filtered-table GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2.qza

  #then export and convert biom to tsv

qiime tools export \
  --input-path ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2.qza \
  --output-path ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2


mv ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2/feature-table.biom ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2.biom


#filtering GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2.qza for birdman. First export it

qiime tools export \
  --input-path ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2.qza \
  --output-path ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2

#filter the qza table to only include reads present in 3 samples or more
qiime feature-table filter-features \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2.qza \
  --p-min-samples 3 \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_3.qza

  #and then 5

qiime feature-table filter-features \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2.qza \
  --p-min-samples 5 \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_5.qza

  #and then 10

qiime feature-table filter-features \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2.qza \
  --p-min-samples 10 \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_10.qza

  #spit out of class by sample numbers

  Mammalia           978
Aves               638
Actinopterygii     565
Insecta            404
Reptilia           309
Amphibia           181
Bivalvia            68
Petromyzontida      39
Malacostraca        38
Anthozoa            29
Saline              26
Ophiuroidea         23
Hyperoartia         20
algae               20
Clitellata          20
Chondrichthyes      20
Arachnida           19
Echinoidea          18
water               18
Non-saline          15
Cephalochordata      6
Sarcopterygii        5

#filter and exclude from GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_5samples.qza Class that is not equal to Non-saline, Sarcopterygii, Cephalochordata, water, algae, Saline

qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_5samples.qza \
  --m-metadata-file ~/TOL/phylo/Feb26_25_GMTOLsong_metadata_all.txt \
  --p-exclude-ids \
  --p-where "Class='Non-saline' OR Class='Sarcopterygii' OR Class='Cephalochordata' OR Class='water' OR Class='algae' OR Class='Saline'" \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_5f.qza

  #filter above table to have reads with more than 150 counts

qiime feature-table filter-features \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_5f.qza \
  --p-min-frequency 150 \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_150_200k_10_5f.qza

#and then try filtering samples with less than 100k reads

qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_150_200k_10_5f.qza \
  --p-min-frequency 100000 \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_150_100k_10_5f.qza

#and then try same above code of filtering samples to 100k but on GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2 table

qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2.qza \
  --p-min-frequency 100000 \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_100k_10_2.qza

#seems like 3 is a good in between number to filter to for reads in certain number of samples 

qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_3.qza \
  --m-metadata-file ~/TOL/phylo/Feb26_25_GMTOLsong_metadata_all.txt \
  --p-exclude-ids \
  --p-where "Class='Non-saline' OR Class='Sarcopterygii' OR Class='Cephalochordata' OR Class='water' OR Class='algae' OR Class='Saline'" \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_3f.qza

#and then do samples to 100k

qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_3f.qza \
  --p-min-frequency 100000 \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_100k_10_3f.qza

  #and then export the above table

qiime tools export \
  --input-path ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_100k_10_3f.qza \
  --output-path ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_100k_10_3f

cp ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_100k_10_3f/feature-table.biom ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_100k_10_3f.biom

#try everythiing again on GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_100k_10_2.qza

qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2.qza \
  --m-metadata-file ~/TOL/phylo/Feb26_25_GMTOLsong_metadata_all.txt \
  --p-exclude-ids \
  --p-where "Class='Non-saline' OR Class='Sarcopterygii' OR Class='Cephalochordata' OR Class='water' OR Class='algae' OR Class='Saline'" \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2f.qza

#and then do samples to 100k

qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_10_2f.qza \
  --p-min-frequency 100000 \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_100k_10_2f.qza

  #export the above table

qiime tools export \
  --input-path ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_100k_10_2f.qza \
  --output-path ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_100k_10_2f

cp ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_100k_10_2f/feature-table.biom ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_100k_10_2f.biom

#and then send biom to ddn_scratch

cp ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_100k_10_2f.biom /ddn_scratch/sdegregori/lucas_table_filtered.biom

#do the same thing to GMTOLsong_table2024_N20_f2all_V4_Vert.qza where you filter by the unwanted classes and then more than 100 reads per feature and then reads that show up at least 5 times

qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert.qza \
  --m-metadata-file ~/TOL/phylo/Feb26_25_GMTOLsong_metadata_all.txt \
  --p-exclude-ids \
  --p-where "Class='Non-saline' OR Class='Sarcopterygii' OR Class='Cephalochordata' OR Class='water' OR Class='algae' OR Class='Saline'" \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertf.qza

#then features to 100

qiime feature-table filter-features \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertf.qza \
  --p-min-frequency 100 \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertf_100.qza

#and then do features that show up in 5 samples or more

qiime feature-table filter-features \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertf_100.qza \
  --p-min-samples 5 \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertf_100_5.qza

  #summarize the table

qiime feature-table summarize \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertf_100_5.qza \
  --m-sample-metadata-file ~/TOL/phylo/Feb26_25_GMTOLsong_metadata_all.txt \
  --o-visualization ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertf_100_5.qzv

  #now do samples with more than 100 reads but less than 100k reads

qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertf_100_5.qza \
  --p-min-frequency 100 \
  --p-max-frequency 100000 \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertf_100-100k_100_5.qza

  #and then export it 

qiime tools export \
  --input-path ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertf_100-100k_100_5.qza \
  --output-path ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertf_100-100k_100_5

cp ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertf_100-100k_100_5/feature-table.biom ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertf_100-100k_100_5.biom

#and then send biom to ddn_scratch
cp ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertf_100-100k_100_5.biom /ddn_scratch/sdegregori/lucas_table_filtered.biom

cp ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertf_100-100k_100_5.biom /ddn_scratch/sdegregori/

#summarize the table
qiime feature-table summarize \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertf_100-100k_100_5.qza \
  --m-sample-metadata-file ~/TOL/phylo/Feb26_25_GMTOLsong_metadata_all.txt \
  --o-visualization ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertf_100-100k_100_5.qzv

  #~~~~~~~~~~~~~~~~~ looking at V3-V4 data
#filter GMTOLsong_table2024_N20_f2all_f.qza to only include V3-V4 samples

qiime feature-table filter-samples \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_f.qza \
  --m-metadata-file ~/TOL/phylo/Feb26_25_GMTOLsong_metadata_all.txt \
  --p-where "Primer2='V3-V4'" \
  --o-filtered-table ~/TOL/V3-V4/GMTOLsong_table2024_N20_f2all_V3V4.qza

  #run core metrics on V3-V4 data

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ~/TOL/minich/GMTOLsong_rooted_tree2024f2.qza \
  --i-table ~/TOL/V3-V4/GMTOLsong_table2024_N20_f2all_V3V4.qza \
  --p-sampling-depth 400 \
  --m-metadata-file ~/TOL/phylo/Feb26_25_GMTOLsong_metadata_all.txt \
  --output-dir ~/TOL/V3-V4/core-metrics-phylo-results-GMTOLsong_tableN20_V3V4_400


#making a snake bird bat table
#first checking if GrpSpeciesMetadataFeb20_25_underscore.txt works with GrpSpecies V4 table
#use these 2 files to summarize the table with qiime2

qiime feature-table summarize \
  --i-table ~/TOL/phylo/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_nospace.qza \
  --m-sample-metadata-file ~/TOL/phylo/GrpSpeciesMetadataFeb21_25_nospace_filtered.txt \
  --o-visualization ~/TOL/phylo/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_nospace.qzv


#run core metrics on above table with GrpSpeciesMetadataFeb21_25_nospace_filtered_snake.txt

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ~/TOL/minich/GMTOLsong_rooted_tree2024f2.qza \
  --i-table ~/TOL/phylo/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_nospace.qza \
  --p-sampling-depth 400 \
  --m-metadata-file ~/TOL/phylo/GrpSpeciesMetadataFeb21_25_nospace_filtered_snake.txt \
  --output-dir ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_tableN20_V4_400

#do beta significance on the unifrac distance matrix with respect to Class_w_snake column

qiime diversity beta-group-significance \
  --i-distance-matrix ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_tableN20_V4_400/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ~/TOL/phylo/GrpSpeciesMetadataFeb21_25_nospace_filtered_snake.txt \
  --m-metadata-column Primer2 \
  --o-visualization ~/TOL/phylo/beta-significance-GMTOLsong_V4_Primer2-unweighted_unifrac.qzv \
  --p-pairwise

  #doesnt work I have to do it with full table not grouped table GMTOLsong_table2024_N20_f2all_V4.qza and May1_25_GMTOLsong_metadata_all.txt
#core metrics

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ~/TOL/minich/GMTOLsong_rooted_tree2024f2.qza \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4.qza \
  --p-sampling-depth 400 \
  --m-metadata-file ~/TOL/phylo/May1_25_GMTOLsong_metadata_all.txt \
  --output-dir ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_table_allN20_V4_400

 #doing beta significance on the unifrac distance matrix with respect to Class_w_snake column
qiime diversity beta-group-significance \
  --i-distance-matrix ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_table_allN20_V4_400/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ~/TOL/phylo/May1_25_GMTOLsong_metadata_all.txt \
  --m-metadata-column Class_w_snakes \
  --o-visualization ~/TOL/phylo/beta-significance-GMTOLsong_V4_Class_w_snake-unweighted_unifrac.qzv \
  --p-pairwise 

  #now do core metrics on the Vert table
#first filter table to Vertebrates only

qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4.qza \
  --m-metadata-file ~/TOL/phylo/May1_25_GMTOLsong_metadata_all.txt \
  --p-where "Chordata='Vertebrate'" \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertebrates.qza

  #actually filter the table to only include Class equal to Amphibia, Reptilia, Aves, Mammalia, snakes, Actinopterygii, or Chiroptera

qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4.qza \
  --m-metadata-file ~/TOL/phylo/May1_25_GMTOLsong_metadata_all.txt \
  --p-where "Class='Amphibia' OR Class='Reptilia' OR Class='Aves' OR Class='Mammalia' OR Class='Actinopterygii' OR Class='Chiroptera' OR Class='snakes'" \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertebratesf.qza

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ~/TOL/minich/GMTOLsong_rooted_tree2024f2.qza \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertebratesf.qza \
  --p-sampling-depth 400 \
  --m-metadata-file ~/TOL/phylo/May1_25_GMTOLsong_metadata_all.txt \
  --output-dir ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_table_allN20_V4_400_Vertebratesf

#doing beta significance on the unifrac distance matrix with respect to Class_w_snake column
qiime diversity beta-group-significance \
  --i-distance-matrix ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_table_allN20_V4_400_Vertebratesf/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ~/TOL/phylo/May1_25_GMTOLsong_metadata_all.txt \
  --m-metadata-column Class_w_snakes \
  --o-visualization ~/TOL/phylo/beta-significance-GMTOLsong_V4_Class_w_snake-unweighted_unifrac_Vertebratesf.qzv \
  --p-pairwise

#Make a rarefied table of ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertebratesf.qza to 1000
qiime feature-table rarefy \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertebratesf.qza \
  --p-sampling-depth 1000 \
  --o-rarefied-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertebratesf_1k.qza

#collapse table to species
#plots are weird so trying unrarefied as well
qiime taxa collapse \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertebratesf.qza \
  --i-taxonomy ~/TOL/phylo/GMTOLsong_taxonomyN20all_2024f2.qza \
  --p-level 7 \
  --o-collapsed-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertebratesf_species7.qza

  qiime feature-table group \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertebratesf_species7.qza \
  --m-metadata-file ~/TOL/phylo/May1_25_GMTOLsong_metadata_all.txt \
  --m-metadata-column Class_w_snakes \
  --p-axis sample \
  --p-mode median-ceiling \
  --o-grouped-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertebratesf_species7_GrpClass_w_snakes.qza

  #filter to reads above 100
qiime feature-table filter-features \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertebratesf_species7_GrpClass_w_snakes.qza \
  --p-min-frequency 10 \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertebratesf_10_species7_GrpClass_w_snakes.qza





  #filter above table to only have features with 300 reads
  #ok didnt work now I am doing 10 and note that I already rarefied to 1k and then did 100_5 filtering but it seems like it reset or something after the grouping, so doing another filter step

  #and then make a heatmap of table on Class_w_snakes heatmap without metadata
  qiime feature-table heatmap \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertebratesf_10_species7_GrpClass_w_snakes.qza \
  --p-color-scheme YlGnBu \
  --o-visualization ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertebratesf_10_species7_GrpClass_w_snakes_heatmap.qzv


  #now do at family level

qiime taxa collapse \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertebratesf_1k.qza \
  --i-taxonomy ~/TOL/phylo/GMTOLsong_taxonomyN20all_2024f2.qza \
  --p-level 5 \
  --o-collapsed-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vertebratesf_family5.qza

  #filter mitochondria and chloroplast and eukaryota from the GMTOLsong_tableNov2024_N20_f2all_grpSpecies_cancer_mam.qza 

qiime taxa filter-table \
  --i-table /ddn_scratch/sdegregori/cancer_mam/GMTOLsong_tableNov2024_N20_f2all_grpSpecies_cancer_mam.qza \
  --i-taxonomy ~/TOL/minich/merged_GMTOL_taxonomy2024f2.qza \
  --p-exclude mitochondria,chloroplast,eukaryota \
  --o-filtered-table /ddn_scratch/sdegregori/cancer_mam/GMTOLsong_tableNov2024_N20_f2all_grpSpecies_cancer_mamf.qza

  cp /ddn_scratch/sdegregori/cancer_mam/GMTOLsong_tableNov2024_N20_f2all_grpSpecies_cancer_mamf.qza /ddn_scratch/sdegregori/cancer_mam/GMTOL_cmr_table.qza

#export it to biom

qiime tools export \
  --input-path /ddn_scratch/sdegregori/cancer_mam/GMTOL_cmr_table.qza \
  --output-path /ddn_scratch/sdegregori/cancer_mam/GMTOL_cmr_table

#and rename

mv /ddn_scratch/sdegregori/cancer_mam/GMTOL_cmr_table/feature-table.biom /ddn_scratch/sdegregori/cancer_mam/GMTOL_cmr_table.biom

cp ~/TOL/minich/merged_GMTOL_taxonomy2024f2.qza /ddn_scratch/sdegregori/cancer_mam/GMTOL_cmr_taxonomy.qza

#export taxonomy file

qiime tools export \
  --input-path /ddn_scratch/sdegregori/cancer_mam/GMTOL_cmr_taxonomy.qza \
  --output-path /ddn_scratch/sdegregori/cancer_mam/GMTOL_cmr_taxonomy

#export tree

qiime tools export \
  --input-path ~/TOL/minich/GMTOLsong_rooted_tree2024f2.qza \
  --output-path /ddn_scratch/sdegregori/cancer_mam/GMTOL_cmr_tree

#now I want to make a new cmr table of all samples
#in python compare metadata files cancer_mam_metadata2.txt and Jul11_25_GMTOLsong_metadata_all.txt to get all samples that are in sampleid of cancer_mam which also match the Species_copy column in the Jul11_25 file

#then filter the Jul11_25_GMTOLsong_metadata_all.txt to only include those samples and save as cancer_mam_GMTOL_all_f.txt

python
import pandas as pd
# Load the metadata files
cancer_mam_metadata = pd.read_csv('cancer_mam_metadata2.txt', sep='\t') 
gmtol_metadata = pd.read_csv('Jul11_25_GMTOLsong_metadata_all.txt', sep='\t')
# Find common samples based on 'sampleid' in cancer_mam_metadata and 'Species_copy' in gmtol_metadata
common_samples = cancer_mam_metadata['sampleid'][cancer_mam_metadata['sampleid'].isin(gmtol_metadata['Species_copy'])]
#count how many
print(f"Number of common samples: {len(common_samples)}")

#now do this the other way around where I want all the rows of gmtol_metadata that match the sampleid of cancer_mam_metadata
filtered_gmtol_metadata = gmtol_metadata[gmtol_metadata['Species_copy'].isin(cancer_mam_metadata['sampleid'])]
#count how many
print(f"Number of filtered GMTOL samples: {len(filtered_gmtol_metadata)}")
# Save the filtered metadata to a new file
filtered_gmtol_metadata.to_csv('cancer_mam_GMTOL_all_f.txt', sep='\t', index=False)
#now from here subset only Primer equaling V4
#first read in the new file
filtered_gmtol_metadata = pd.read_csv('cancer_mam_GMTOL_all_f.txt', sep='\t')
filtered_gmtol_metadata_v4 = filtered_gmtol_metadata[filtered_gmtol_metadata['Primer2'] == 'V4']
#count how many
print(f"Number of V4 samples: {len(filtered_gmtol_metadata_v4)}")
# Save the V4 filtered metadata to a new file
filtered_gmtol_metadata_v4.to_csv('cancer_mam_GMTOL_all_V4_f.txt', sep='\t', index=False)

#now in bash with qiime I want to filter GMTOLsong_table2024_N20_f2all_f.qza to only include the samples in cancer_mam_GMTOL_all_V4_f.txt
qiime feature-table filter-samples \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_f.qza \
  --m-metadata-file cancer_mam_GMTOL_all_V4_f.txt \
  --o-filtered-table ~/cancer_mam/GMTOLsong_table2024_N20_f2all_cancer_mam_V4.qza

#and then filter the final GMTOL trees and taxonomy files to match this new table. So first filter tree
qiime phylogeny filter-tree \
  --i-tree ~/TOL/minich/GMTOLsong_rooted_tree2024f2.qza \
  --i-table ~/cancer_mam/GMTOLsong_table2024_N20_f2all_cancer_mam_V4.qza \
  --o-filtered-tree ~/cancer_mam/GMTOLsong_rooted_tree2024f2_cancer_mam_V4.qza

#then filter taxonomy file
qiime feature-classifier filter-taxonomy \
  --i-taxonomy ~/TOL/minich/merged_GMTOL_taxonomy2024f2.qza \
  --i-table ~/cancer_mam/GMTOLsong_table2024_N20_f2all_cancer_mam_V4.qza \
  --o-filtered-taxonomy ~/cancer_mam/merged_GMTOL_taxonomy2024f2_cancer_mam_V4.qza


#run qiime2 tree job on rep_seqs_merged_filtered.qza in the cancer_qiita folder

#export ananya rep seqs qiime2 file
qiime tools export \
  --input-path /ddn_scratch/sdegregori/cancer_qiita/rep_seqs_merged_filtered.qza \
  --output-path /ddn_scratch/sdegregori/cancer_qiita/rep_seqs_merged_filtered

#merge phase1_human_rep-seqs.qza and GMTOLhumanNov2023_merged_seqs.qza

qiime feature-table merge-seqs \
  --i-data rep_seqs_merged_filtered.qza \
  --i-data GMTOLhumanNov2023_merged_seqs1.qza \
  --o-merged-data allphase_human_seqs_2025.qza

# merge GMTOLhumanNov2023_merged_tables.qza and phase1_merged_tables.qza

qiime feature-table merge \
  --i-tables GMTOLhumanNov2023_merged_tables.qza \
  --i-tables phase1_merged_tables.qza \
  --o-merged-table allphase_human_tables_2025.qza

  #filter seqs to match table
qiime feature-table filter-seqs \
  --i-data allphase_human_seqs_2025.qza \
  --i-table allphase_human_tables_2025.qza \
  --o-filtered-data allphase_human_seqs_2025f.qza

#make a core metrics with merged_human_metadata_allphases.txt 

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny allphase_human_tree_2025.qza  \
  --i-table allphase_human_tables_2025.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file merged_human_metadata_allphases.txt \
  --output-dir core-metrics-phylo-results-allphase_human_tables_2025_1k

~~~~~~~~~~~~~~~~~~~~~~~~~~
#collapse GMTOL table to speciel level

qiime taxa collapse \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert.qza \
  --i-taxonomy ~/TOL/phylo/GMTOLsong_taxonomyN20all_2024f2.qza \
  --p-level 7 \
  --o-collapsed-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_species7.qza

#summarize the table

qiime feature-table summarize \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_species7.qza \
  --m-sample-metadata-file ~/TOL/phylo/May1_25_GMTOLsong_metadata_all.txt \
  --o-visualization ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_species7.qzv

#filter the table to only include species that show up in at least 2 samples and have at least 10 reads
qiime feature-table filter-features \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_species7.qza \
  --p-min-frequency 10 \
  --p-min-samples 2 \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_species7_10_2.qza

  #summarize the filtered table
qiime feature-table summarize \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_species7_10_2.qza \
  --m-sample-metadata-file ~/TOL/phylo/May1_25_GMTOLsong_metadata_all.txt \
  --o-visualization ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_species7_10_2.qzv

#now try 100 reads across 2 samples
qiime feature-table filter-features \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_species7.qza \
  --p-min-frequency 100 \
  --p-min-samples 2 \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_species7_100_2.qza

#and then remove samples with 200l reads or more

qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_species7_100_2.qza \
  --p-max-frequency 200000 \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_species7_100_2_200k.qza

#summarize
qiime feature-table summarize \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_species7_100_2_200k.qza \
  --m-sample-metadata-file ~/TOL/phylo/May1_25_GMTOLsong_metadata_all.txt \
  --o-visualization ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_species7_100_2_200k.qzv


#summarize GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2.qza with GrpSpeciesMetadataFeb20_25_underscore.txt

qiime feature-table summarize \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2.qza \
  --m-sample-metadata-file ~/TOL/phylo/GrpSpeciesMetadataFeb20_25_underscore.txt \
  --o-visualization ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2.qzv

#and now collapse by species

qiime taxa collapse \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2.qza \
  --i-taxonomy ~/TOL/phylo/GMTOLsong_taxonomyN20all_2024f2.qza \
  --p-level 7 \
  --o-collapsed-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2_species7.qza

#and now summarize
qiime feature-table summarize \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2_species7.qza \
  --m-sample-metadata-file ~/TOL/phylo/GrpSpeciesMetadataFeb20_25_underscore.txt \
  --o-visualization ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2_species7.qzv

#read in python with pandas as a dataframe May1_25_GMTOLsong_metadata_all.txt

import pandas as pd
import numpy as np
#read in the metadata file
df = pd.read_csv('~/TOL/phylo/GrpSpeciesMetadataFeb20_25_underscore.txt', sep='\t')

#Can you make a new column for every level of the column 'Class' that is basically a yes no column depending on whether the row corresponds to that class or not?
df2=df.copy()
#print out all the Class levels
df2['Class'].unique()

#print how many rows there are for each level
df2['Class'].value_counts()

#now for all of these levels append a new yes no column for each level
df2['Insecta'] = np.where(df2['Class'] == 'Insecta', 'yes', 'no')
df2['Amphibia'] = np.where(df2['Class'] == 'Amphibia', 'yes', 'no')
df2['Mammalia'] = np.where(df2['Class'] == 'Mammalia', 'yes', 'no')
df2['Aves'] = np.where(df2['Class'] == 'Aves', 'yes', 'no')
df2['Reptilia'] = np.where(df2['Class'] == 'Reptilia', 'yes', 'no')
df2['Actinopterygii'] = np.where(df2['Class'] == 'Actinopterygii', 'yes', 'no')
df2['Bivalvia'] = np.where(df2['Class'] == 'Bivalvia', 'yes', 'no')
df2['Gastropoda'] = np.where(df2['Class'] == 'Gastropoda', 'yes', 'no')
df2['Malacostraca'] = np.where(df2['Class'] == 'Malacostraca', 'yes', 'no')
df2['Arachnida'] = np.where(df2['Class'] == 'Arachnida', 'yes', 'no')

#write df2 as a tab delimited text file
df2.to_csv('~/TOL/phylo/GrpSpeciesMetadataJun18_25_underscore_yesno.txt', sep='\t', index=False)


#export table to biom
qiime tools export \
  --input-path ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2_species7.qza \
  --output-path ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2_species7

  #rename the biom file
mv ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2_species7/feature-table.biom ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2_species7.biom

#send biom to ddn_scratch/sdegregori/birdmantest

cp ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2_species7.biom /ddn_scratch/sdegregori/birdmantest/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2_species7.biom

#read in May1_25_GMTOLsong_metadata_all.txt with pandas as a dataframe and use python to get the average number of replicate samples per host species in the column 'Species'

import pandas as pd
#read in the metadata file
df = pd.read_csv('May1_25_GMTOLsong_metadata_all.txt', sep='\t')
#group by Species and get the number of samples in each group
df_grouped = df.groupby('Species').size().reset_index(name='count')
#calculate the average number of samples per species
average_samples_per_species = df_grouped['count'].mean()
print(f'Average number of samples per species: {average_samples_per_species}')
#now get the median
median_samples_per_species = df_grouped['count'].median()
print(f'Median number of samples per species: {median_samples_per_species}')

#summarize GMTOLsong_seqs2024_ALL.qza with qiime2 in ~/TOL/minich

qiime feature-table summarize \
  --i-table ~/TOL/minich/GMTOLsong_table2024f.qza \
  --m-sample-metadata-file ~/TOL/phylo/May1_25_GMTOLsong_metadata_all.txt \
  --o-visualization ~/TOL/minich/GMTOLsong_table2024f_redo.qzv

#get rid of singletons and at least 2 samples
qiime feature-table filter-features \
  --i-table ~/TOL/minich/GMTOLsong_table2024f.qza \
  --p-min-frequency 2 \
  --p-min-samples 2 \
  --o-filtered-table ~/TOL/minich/GMTOLsong_table2024f_2_2.qza

#get rid of eukaryota, mitochondria, and chloroplast
qiime taxa filter-table \
  --i-table ~/TOL/minich/GMTOLsong_table2024f_2_2.qza \
  --i-taxonomy ~/TOL/minich/merged_GMTOL_taxonomy2024f2.qza \
  --p-exclude eukaryota,mitochondria,chloroplast \
  --o-filtered-table ~/TOL/minich/GMTOLsong_table2024f_2_2f.qza

#summarize the filtered table
qiime feature-table summarize \
  --i-table ~/TOL/minich/GMTOLsong_table2024f_2_2f.qza \
  --m-sample-metadata-file ~/TOL/phylo/May1_25_GMTOLsong_metadata_all.txt \
  --o-visualization ~/TOL/minich/GMTOLsong_table2024f_2_2f.qzv


#now I want to use GrpSpeciesMetadataJun18_25_underscore_yesno.txt and GMTOLsong_table2024_N20_f2all_V4_GrpSpecies_f.qza which is in minich folder

qiime feature-table summarize \
  --i-table ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_GrpSpecies_f.qza \
  --m-sample-metadata-file ~/TOL/phylo/GrpSpeciesMetadataJun18_25_underscore_yesno.txt \
  --o-visualization ~/TOL/minich/GMTOLsong_table2024_N20_f2all_V4_GrpSpecies_f.qzv

#above doesnt work!!!! 
#now try with GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2.qza

qiime feature-table summarize \
  --i-table ~/TOL/phylo/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2.qza \
  --m-sample-metadata-file ~/TOL/phylo/GrpSpeciesMetadataJun18_25_underscore_yesno.txt \
  --o-visualization ~/TOL/phylo/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_renamed_timetree2.qzv

#doesnt work now trying renaming. export GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf.qza in qiime2

qiime tools export \
  --input-path ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf.qza \
  --output-path ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf

#convert above to tsv

biom convert \
  --input-fp ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf/feature-table.biom \
  --output-fp ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf.tsv \
  --to-tsv
#have to add underscores
  #import GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_underscore.txt to qiime2
#conver GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_underscore.txt to biom

biom convert \
  --input-fp ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_underscore.txt \
  --output-fp ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_underscore.txt.biom \
  --to-hdf5

qiime tools import \
  --input-path ~/TOL/minich/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_underscore.txt.biom \
  --type 'FeatureTable[Frequency]' \
  --output-path ~/TOL/phylo/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_underscore.qza

#filter table to match metadata

qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_underscore.qza \
  --m-metadata-file ~/TOL/phylo/GrpSpeciesMetadataJun18_25_underscore_yesno.txt \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_underscore.qza


#make a qzv file 

qiime feature-table summarize \
  --i-table ~/TOL/phylo/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_underscore.qza \
  --m-sample-metadata-file ~/TOL/phylo/GrpSpeciesMetadataJun18_25_underscore_yesno.txt \
  --o-visualization ~/TOL/phylo/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_underscore.qzv

#now filter for Primer2 equal to V4 and DietSimp equal to 'Carnivore' or 'Omnivore' or 'Herbivore' 

qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_underscore.qza \
  --m-metadata-file ~/TOL/phylo/GrpSpeciesMetadataJun18_25_underscore_yesno.txt \
  --p-where "Primer2='V4' AND (DietSimp='Carnivore' OR DietSimp='Omnivore' OR DietSimp='Herbivore')" \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_underscore_V4CHO.qza

#and then do an code metrics on above table at 600 reads

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ~/TOL/minich/GMTOLsong_rooted_tree2024f2.qza \
  --i-table ~/TOL/phylo/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_underscore_V4CHO.qza \
  --p-sampling-depth 600 \
  --m-metadata-file ~/TOL/phylo/GrpSpeciesMetadataJun18_25_underscore_yesno.txt \
  --output-dir ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_tableN20_GrpSpecies_V4CHO_600

#filter final/GMTOLsong_table2024_N20_f2all_f.qza to only include V4 samples and DietSimp equal to 'Carnivore' or 'Omnivore' or 'Herbivore'
qiime feature-table filter-samples \
  --i-table ~/TOL/final/GMTOLsong_table2024_N20_f2all_f.qza \
  --m-metadata-file ~/TOL/final/Jul10_25_GMTOLsong_metadata_all.txt \
  --p-where "Primer2='V4' AND (DietSimp='Carnivore' OR DietSimp='Omnivore' OR DietSimp='Herbivore')" \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4CHO.qza

#do core metrics on the filtered table at 600 reads

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ~/TOL/final/GMTOLsong_rooted_tree2024f2.qza \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4CHO.qza \
  --p-sampling-depth 600 \
  --m-metadata-file ~/TOL/final/Jul10_25_GMTOLsong_metadata_all.txt \
  --output-dir ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_tableN20_V4CHO_600

#now do adonis on the GMTOLsong table using formula Phylum + Class + Order + Family + DietSimp + Chordata

qiime diversity adonis \
  --i-distance-matrix ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_tableN20_V4CHO_600/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ~/TOL/final/Jul10_25_GMTOLsong_metadata_all.txt \
  --p-formula "Phylum + Class + Order + Family + DietSimp + Chordata" \
  --o-visualization ~/TOL/phylo/adonis-GMTOLsong_V4CHO-uw.qzv

#then merge table by Chordata 
qiime feature-table group \
  --i-table ~/TOL/phylo/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_underscore_V4CHO.qza \
  --m-metadata-file ~/TOL/phylo/GrpSpeciesMetadataJun18_25_underscore_yesno.txt \
  --m-metadata-column Chordata \
  --p-axis sample \
  --p-mode median-ceiling \
  --o-grouped-table ~/TOL/phylo/GMTOLsong_tableNov2024_N20_f2all_grpSpeciesf_underscore_V4CHO_Chordata.qza

#and then do a taxa bar plot without metadata
qiime taxa barplot \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2_V4_VertInvert.qza \
  --i-taxonomy ~/TOL/phylo/GMTOLsong_taxonomyN20all_2024f2.qza \
  --o-visualization ~/TOL/phylo/taxaonomy_GMTOLsong_table2024_N20_f2all_VertInvert_barplot.qzv

CONDA_SUBDIR=osx-64 conda env create -n qiime2-2024.10 --file https://data.qiime2.org/distro/amplicon/qiime2-amplicon-2024.10-py310-osx-conda.yml
conda activate qiime2-2024.10
conda config --env --set subdir osx-64

#filter ~/TOL/final/GMTOLsong_table2024_N20_f2all_f.qza to only include Vertebrates and Invertebrates and Primer2 V4
qiime feature-table filter-samples \
  --i-table ~/TOL/final/GMTOLsong_table2024_N20_f2all_f.qza \
  --m-metadata-file ~/TOL/final/Jul11_25_GMTOLsong_metadata_all.txt \
  --p-where "Primer2='V4' AND (Chordata='Vertebrate' OR Chordata='Invertebrate')" \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2_V4_VertInvert.qza


#then run core metrics on above table at 600
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny ~/TOL/final/GMTOLsong_rooted_tree2024f2.qza \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2_V4_VertInvert.qza \
  --p-sampling-depth 600 \
  --m-metadata-file ~/TOL/final/Jul11_25_GMTOLsong_metadata_all.txt \
  --output-dir ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_tableN20_V4_VertInvert_600

#and then run beta significance on the unifrac distance matrix with respect to Chordata
qiime diversity beta-group-significance \
  --i-distance-matrix ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_tableN20_V4_VertInvert_600/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ~/TOL/final/Jul11_25_GMTOLsong_metadata_all.txt \
  --m-metadata-column Chordata \
  --o-visualization ~/TOL/phylo/beta-significance-GMTOLsong_VertInvert_Chordata-unweighted_unifrac.qzv \
  --p-pairwise

  #summarize GMTOLsong_table2024_N20_f2all_VertInvert.qza

qiime feature-table summarize \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2_V4_VertInvert.qza \
  --m-sample-metadata-file ~/TOL/final/Jul11_25_GMTOLsong_metadata_all.txt \
  --o-visualization ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_VertInvert.qzv

  #group ~/TOL/phylo/GMTOLsong_table2024_N20_f2_V4_VertInvert.qza by Chordata



  #make a taxa barplot
#not working. Trying sum

qiime feature-table group \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2_V4_VertInvert.qza \
  --m-metadata-file ~/TOL/final/Jul10_25_GMTOLsong_metadata_all.txt \
  --m-metadata-column Chordata \
  --p-axis sample \
  --p-mode sum \
  --o-grouped-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_GrpVertInvert_sum.qza

#and then make a taxa bar plot without metadata
qiime taxa barplot \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_GrpVertInvert_sum.qza \
  --i-taxonomy ~/TOL/phylo/GMTOLsong_taxonomyN20all_2024f2.qza \
  --o-visualization ~/TOL/phylo/taxaonomy_GMTOLsong_table2024_N20_f2all_GrpVertInvert_barplot.qzv

  #run a separate adonis for each factor that I listed before for CHO

qiime diversity adonis \
  --i-distance-matrix ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_tableN20_V4CHO_600/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ~/TOL/final/Jul10_25_GMTOLsong_metadata_all.txt \
  --p-formula "Phylum \
  --p-n-jobs 4 \
  --o-visualization ~/TOL/phylo/adonis-GMTOLsong_VertInvert-uw-Phylum.qzv

qiime diversity adonis \
  --i-distance-matrix ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_tableN20_V4CHO_600/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ~/TOL/final/Jul10_25_GMTOLsong_metadata_all.txt \
  --p-formula "Class" \
  --p-n-jobs 4 \
  --o-visualization ~/TOL/phylo/adonis-GMTOLsong_VertInvert-uw-Class.qzv

qiime diversity adonis \
  --i-distance-matrix ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_tableN20_V4CHO_600/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ~/TOL/final/Jul10_25_GMTOLsong_metadata_all.txt \
  --p-formula "Order" \
  --p-n-jobs 4 \
  --o-visualization ~/TOL/phylo/adonis-GMTOLsong_VertInvert-uw-Order.qzv

qiime diversity adonis \
  --i-distance-matrix ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_tableN20_V4CHO_600/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ~/TOL/final/Jul10_25_GMTOLsong_metadata_all.txt \
  --p-formula "Family" \
  --p-n-jobs 4 \
  --o-visualization ~/TOL/phylo/adonis-GMTOLsong_VertInvert-uw-Family.qzv

qiime diversity adonis \
  --i-distance-matrix ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_tableN20_V4CHO_600/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ~/TOL/final/Jul10_25_GMTOLsong_metadata_all.txt \
  --p-formula "DietSimp" \
  --p-n-jobs 4 \
  --o-visualization ~/TOL/phylo/adonis-GMTOLsong_VertInvert-uw-DietSimp.qzv

qiime diversity adonis \
  --i-distance-matrix ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_tableN20_V4_VertInvert_600/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ~/TOL/final/Jul10_25_GMTOLsong_metadata_all.txt \
  --p-formula "Chordata" \
  --p-n-jobs 4 \
  --o-visualization ~/TOL/phylo/adonis-GMTOLsong_VertInvert-uw-Chordata.qzv

 qiime diversity adonis \
  --i-distance-matrix ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_tableN20_V4_VertInvert_600/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ~/TOL/final/Jul10_25_GMTOLsong_metadata_all.txt \
  --p-formula "Genus" \
  --p-n-jobs 4 \
  --o-visualization ~/TOL/phylo/adonis-GMTOLsong_VertInvert-uw-Genus.qzv 

  qiime diversity adonis \
  --i-distance-matrix ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_tableN20_V4_VertInvert_600/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ~/TOL/final/Jul10_25_GMTOLsong_metadata_all.txt \
  --p-formula "Species" \
  --p-n-jobs 4 \
  --o-visualization ~/TOL/phylo/adonis-GMTOLsong_VertInvert-uw-Species.qzv

#now do adonis on Study + Species
qiime diversity adonis \
  --i-distance-matrix ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_tableN20_V4_VertInvert_600/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ~/TOL/final/Jul10_25_GMTOLsong_metadata_all.txt \
  --p-formula "Study + Species" \
  --p-n-jobs 4 \
  --o-visualization ~/TOL/phylo/adonis-GMTOLsong_VertInvert-uw-StudySpecies.qzv

  #now do beta sig test on Class_snake_env_Invert on core-metrics-phylo-results-GMTOLsong_table_allN20_V4_400 folder
qiime diversity beta-group-significance \
  --i-distance-matrix ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_table_allN20_V4_400/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ~/TOL/final/Jul11_25_GMTOLsong_metadata_all.txt \
  --m-metadata-column Class_snake_env_Invert \
  --o-visualization ~/TOL/phylo/beta-significance-core-metrics-allN20_V4_400_Class_snake_env_Invert-uw.qzv \
  --p-pairwise

  #now do this on Class_snake_env_InvertVert

qiime diversity beta-group-significance \
  --i-distance-matrix ~/TOL/phylo/core-metrics-phylo-results-GMTOLsong_table_allN20_V4_400/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ~/TOL/final/Jul11_25_GMTOLsong_metadata_all.txt \
  --m-metadata-column Class_snake_env_InvertVert \
  --o-visualization ~/TOL/phylo/beta-significance-core-metrics-allN20_V4_400_Class_snake_env_InvertVert-uw.qzv \
  --p-pairwise

  #now do it on the unifrac from the core-metrics-phylo-results-GMTOLsong_tableN20_V4_1k folder

qiime diversity beta-group-significance \
  --i-distance-matrix ~/TOL/minich/core-metrics-phylo-results-GMTOLsong_tableN20_V4_1k/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file ~/TOL/final/Jul11_25_GMTOLsong_metadata_all.txt \
  --m-metadata-column Class_snake_env_InvertVert \
  --o-visualization ~/TOL/phylo/beta-significance-core-metrics-N20_V4_1k_Class_snake_env_Invert-uw.qzv \
  --p-pairwise

  #and then make a phylum table off the main V4 GMTOL table

qiime taxa collapse \



#making collapsed table for Lucas

qiime taxa collapse \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2.qza \
  --i-taxonomy ~/TOL/phylo/MTOLsong_taxonomyN20all_2024f2_lucas-2.qza \
  --p-level 7 \
  --o-collapsed-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2_species7.qza

#then cp to /ddn_scratch/sdegregori/birdmantest

cp ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2_species7.qza /ddn_scratch/sdegregori/birdmantest/MTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2_species7v2.qza

export /ddn_scratch/sdegregori/birdmantest/MTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2_species7v2.qza to biom file

qiime tools export \
  --input-path /ddn_scratch/sdegregori/birdmantest/MTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2_species7v2.qza \
  --output-path /ddn_scratch/sdegregori/birdmantest/MTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2_species7v2

#rename the biom file

mv /ddn_scratch/sdegregori/birdmantest/MTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2_species7v2/feature-table.biom /ddn_scratch/sdegregori/birdmantest/MTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2_species7v2.biom

#cp ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2.qza to /ddn_scratch/sdegregori/birdmantest/MTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2.qza

cp ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2.qza /ddn_scratch/sdegregori/birdmantest/MTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2.qza

#export the table to biom format
qiime tools export \
  --input-path /ddn_scratch/sdegregori/birdmantest/MTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2.qza \
  --output-path /ddn_scratch/sdegregori/birdmantest/MTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2

#rename /ddn_scratch/sdegregori/birdmantest/MTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2.qza to /ddn_scratch/sdegregori/birdmantest/GTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2.qza

mv /ddn_scratch/sdegregori/birdmantest/MTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2/feature-table.biom /ddn_scratch/sdegregori/birdmantest/GTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2.biom

mv /ddn_scratch/sdegregori/birdmantest/MTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2 /ddn_scratch/sdegregori/birdmantest/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2

mv /ddn_scratch/sdegregori/birdmantest/GTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2.biom /ddn_scratch/sdegregori/birdmantest/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2.biom

#write dada2 command to trim a single end fastq study at 150bp using placeholder simple names for tutorial like seqs.qza

qiime dada2 denoise-single \
  --i-demultiplexed-seqs seqs.qza \
  --p-trim-left 0 \
  --p-trunc-len 150 \
  --o-table table.qza \
  --o-representative-sequences rep-seqs.qza \
  --o-denoising-stats stats.qza

mkdir birdman

#in python read combined_birdman_results.tsv and select first column and then any column with header 'T.no]_mean' in it and make new df

import pandas as pd
#read in the combined_birdman_results.tsv file
df = pd.read_csv('combined_birdman_results.tsv', sep='\t')
#select first column of df and then subsequent column headers that contains string '_mean_' in header name
 = df[['Feature'] + [col for col in df.columns if '_mean' in col]]



#read in combined_birdman_results.tsv in python

import pandas as pd
#read in the combined_birdman_results.tsv file
df = pd.read_csv('combined_birdman_results.tsv', sep='\t')

#now make a df with only columns with ']_mean_' in the header name

mean_cols = [col for col in df.columns if ']_mean_' in col]
#make a new df with only the first column and the mean columns
df_mean = df[['Feature'] + mean_cols]

#now replace anything that comes before ']_mean_' with nothing, including the ]_mean_ part in the column names

df_mean.columns = [col.split(']')[1] if ']_mean_' in col else col for col in df_mean.columns]

df_mean.head()

#now write the df_mean to a tsv file ignoring the index

df_mean.to_csv('birdman_mean_resultsf.tsv', sep='\t', index=False)

#now make an community empress plot without taxonomy that uses the birdman_mean_resultsf.tsv file as the feature metadata file

qiime empress community-plot \
  --i-feature-table ../../Dumpy/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2_species7.qza \
  --i-tree birdman_phylogeny.qza \
  --m-sample-metadata-file ../../Dumpy/GrpSpeciesMetadataJun18_25_underscore_yesno.txt \
  --m-feature-metadata-file birdman_mean_resultsf.tsv \
  --o-visualization GMTOLsong_empress_plot_birdman_mean.qzv


#export the tree

qiime tools export \
  --input-path birdman_phylogeny.qza \
  --output-path birdman_phylogeny

  #summarize table
qiime feature-table summarize \
  --i-table ../../Dumpy/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2_species7.qza \
  --m-sample-metadata-file ../../Dumpy/GrpSpeciesMetadataJun18_25_underscore_yesno.txt \
  --o-visualization GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2_species7.qzv


qiime empress community-plot \
  --i-feature-table ../../Dumpy/birdman_feature_table-2.qza \
  --i-tree birdman_phylogeny.qza \
  --m-sample-metadata-file ../../Dumpy/GrpSpeciesMetadataJun18_25_underscore_yesno.txt \
  --m-feature-metadata-file birdman_mean_resultsf.tsv \
  --o-visualization GMTOLsong_empress_plot_birdman_mean.qzv

  #export birdman_taxonomy.qza to tsv
qiime tools export \
  --input-path ../../Dumpy/birdman_taxonomy.qza \
  --output-path ../../Dumpy/birdman_taxonomy

~~~~~~~~~~~~~~

import pandas as pd
#read in the combined_birdman_results.tsv file
df = pd.read_csv('combined_birdman_results-fixed.tsv', sep='\t')

#now make a df with only columns with ']_mean_' in the header name

mean_cols = [col for col in df.columns if ']_mean_' in col]
#make a new df with only the first column and the mean columns
df_mean = df[['Feature'] + mean_cols]

#now replace anything that comes before ']_mean_' with nothing, including the ]_mean_ part in the column names

df_mean.columns = [col.split(']')[1] if ']_mean_' in col else col for col in df_mean.columns]

df_mean.head()

#now write the df_mean to a tsv file ignoring the index

df_mean.to_csv('birdman_mean_resultsf-fixed.tsv', sep='\t', index=False)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

qiime empress community-plot \
  --i-feature-table ../../Dumpy/GMTOLsong_table2024_N20_f2all_V4_Vert_filt_100_200k_100_2_Grpspecies2_species7.qza \
  --i-tree birdman_phylogeny.qza \
  --m-sample-metadata-file ../../Dumpy/GrpSpeciesMetadataJun18_25_underscore_yesno.txt \
  --m-feature-metadata-file birdman_mean_resultsf-fixed.tsv \
  --o-visualization GMTOLsong_empress_plot_birdman_mean.qzv

  ~~~~~~~~~~~~~~~~~~~~
  #in python check for duplicate Features in Feature column and print them out from dataframe as rows

import pandas as pd
#read in the combined_birdman_results.tsv file ignoring indexes

df = pd.read_csv('combined_birdman_results-fixed.tsv', sep='\t')
df

#check for duplicate Features in Feature column
duplicates = df[df.duplicated(['Feature'], keep=False)]
#now print out the duplicates
print(duplicates)
#write to tsv file
duplicates.to_csv('birdman_duplicates.tsv', sep='\t', index=False)
#now make revert to old df but keep the 1st duplicate of each pair

df_unique = df.drop_duplicates(subset=['Feature'], keep='first')
#write the unique df to a tsv file
df_unique.to_csv('birdman_unique_results.tsv', sep='\t', index=False)

mean_cols = [col for col in df_unique.columns if ']_mean_' in col]
#make a new df with only the first column and the mean columns
df_mean = df_unique[['Feature'] + mean_cols]

#now replace anything that comes before ']_mean_' with nothing, including the ]_mean_ part in the column names

df_mean.columns = [col.split(']')[1] if ']_mean_' in col else col for col in df_mean.columns]

df_mean.head()

#now write the df_mean to a tsv file ignoring the index

df_mean.to_csv('birdman_mean_resultsf-unique.tsv', sep='\t', index=False)

~~~~~~~~~~~~~~~~~~~~~~~~~

#now make community empress plot with the unique results

qiime empress community-plot \
  --i-feature-table birdman_feature_table-2.qza \
  --i-tree birdman_phylogeny_maybe2.qza \
  --m-sample-metadata-file ../../Dumpy/GrpSpeciesMetadataJun18_25_underscore_yesno.txt \
  --m-feature-metadata-file birdman_mean_resultsf-unique.tsv \
  --o-visualization GMTOLsong_empress_plot_birdman_mean.qzv

  #now use python to check how many



#doing luis prelim fig for k99. Filter merged-table.qza  with metadata.txt so primer is equal to V4 and 'age' equals Adult and Children and assume everything is in this directory: /ddn_scratch/lxxu/gmtol/dadaqiimeseq/studies3/pcoa

qiime feature-table filter-samples \
  --i-table merged-table.qza \
  --m-metadata-file metadata.txt \
  --p-where "Primer='V4' AND (age='Adult' OR age='Children')" \
  --o-filtered-table V4_AdultChildren_table.qza

#now run core metrics on the filtered table at 2000 reads

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny qiimeseq-rooted_treef.qza \
  --i-table V4_AdultChildren_table.qza \
  --p-sampling-depth 2000 \
  --m-metadata-file metadata.txt \
  --output-dir core-metrics-results-V4_AdultChildren_2000

#copy /ddn_scratch/lxxu/gmtol/dadaqiimeseq/studies3/pcoa/core-metrics-results-V4_AdultChildren_2000 to core-metrics-results-V4_AdultChildren_2000

cp -r /ddn_scratch/lxxu/gmtol/dadaqiimeseq/studies3/pcoa/core-metrics-results-V4_AdultChildren_2000 .
#do a qiime cache refresh
qiime cache refresh

#trying gg2 
 qiime greengenes2 non-v4-16s \
    --i-table merged-table.qza \
    --i-sequences merged-rep-seqs.qza \
    --p-threads 4 \
    --i-backbone ~/TOL/2022.10.backbone.full-length.fna.qza \
    --o-mapped-table merged_table_gg2.qza \
    --o-representatives merged_seqs_gg2.qza

#make a qzv out of the merged_rep_seqs_gg2.qza file using tabulate seqs
qiime metadata tabulate \
  --m-input-file merged_seqs_gg2.qza \
  --o-visualization merged_seqs_gg2.qzv

#now run core metrics at 2000 reads on the merged_table_gg2.qza file with 2022.10.phylogeny.id.nwk 4 threads
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny 2022.10.phylogeny.id.nwk.qza \
  --i-table merged_table_gg2_f.qza \
  --p-sampling-depth 2000 \
  --m-metadata-file Luis_metadata.txt \
  --p-n-jobs-or-threads auto \
  --output-dir core-metrics-results-_all_2000_gg2

  #filter table to match metadata
qiime feature-table filter-samples \
  --i-table merged_table_gg2.qza \
  --m-metadata-file Luis_metadata.txt \
  --o-filtered-table merged_table_gg2_f.qza

#cp the new table, sequences, and tree I used to /ddn_scratch/lxxu/gmtol/dadaqiimeseq/studies3/pcoa/gg2

cp merged_table_gg2_f.qza /ddn_scratch/lxxu/gmtol/dadaqiimeseq/studies3/pcoa/gg2/
cp merged_seqs_gg2.qza /ddn_scratch/lxxu/gmtol/dadaqiimeseq/studies3/pcoa/gg2/
cp 2022.10.phylogeny.id.nwk.qza /ddn_scratch/lxxu/gmtol/dadaqiimeseq/studies3/pcoa/gg2/

https://ftp.microbio.me/greengenes_release/2022.10/2022.10.taxonomy.id.tsv.qza


#for metadata.txt in python I want to find out the sample size of each Disease stratified by age
python
import pandas as pd
#read in the metadata.txt file
df = pd.read_csv('Luis_metadata.txt', sep='\t')
#group by Disease and age and count the number of samples in each group
df_grouped = df.groupby(['disease', 'age']).size().reset_index(name='sample_size')
#now print the df_grouped
print(df_grouped)

#make a metadata file with disease = 'Obesity, Diabetes' and '± Obesity/T2D' and then 130 random samples from 'Healthy' but make sure all of this are V3-V4 samples

df_filtered = df[(df['disease'].isin(['Obesity, Diabetes', '± Obesity/T2D'])) | (df['disease'] == 'Healthy') & (df['primer'] == 'V3-V4')]
#now randomly sample 130 samples from the Healthy group
df_healthy = df_filtered[df_filtered['disease'] == 'Healthy'].sample(n=130, random_state=42)
#now concatenate the two dataframes
df_final = pd.concat([df_filtered[df_filtered['disease'].isin(['Obesity, Diabetes', '± Obesity/T2D'])], df_healthy])
df_final.shape
#list out primers by disease
df_final.groupby('disease')['primer'].unique()
#write the df_final to a tsv file
df_final.to_csv('Luis_metadata_t2d.txt', sep='\t', index=False)

#now filter the merged_table_gg2_f.qza file to only include the samples in df_final
qiime feature-table filter-samples \
  --i-table merged_table_gg2_f.qza \
  --m-metadata-file Luis_metadata_t2d.txt \
  --o-filtered-table merged_table_gg2_f_t2d.qza

# for Luis_metadata_t2d.txt I want to group 'Obesity, Diabetes', '± Obesity/T2D' into a new group called ObesityT2D in a new column called diseaseAncom

python
import pandas as pd
#read in the Luis_metadata_t2d.txt file
df = pd.read_csv('Luis_metadata_t2d.txt', sep='\t')
#replace 'Obesity, Diabetes', '± Obesity/T2D' with 'ObesityT2D' in the disease column
df['diseaseAncom'] = df['disease'].replace({'Obesity, Diabetes': 'ObesityT2D', '± Obesity/T2D': 'ObesityT2D'})
print(df['diseaseAncom'].unique())
#write the df to a tsv file
df.to_csv('Luis_metadata_t2d_ancom.txt', sep='\t', index=False)

#now run ancom on the merged_table_gg2_f_t2d.qza file with the Luis_metadata_t2d_ancom.txt file on the diseaseAncom column
#start with insitial steps of ancom
qiime composition add-pseudocount \
  --i-table merged_table_gg2_f_t2d.qza \
  --o-composition-table merged_table_gg2_f_t2d_pseudocount.qza

#apparently dont need to do above. Instead first collapse the table to spcies using the gg2 taoxnomy file and the t2d table
qiime taxa collapse \
  --i-table merged_table_gg2_f_t2d.qza \
  --i-taxonomy 2022.10.taxonomy.id.tsv.qza \
  --p-level 7 \
  --o-collapsed-table merged_table_gg2_f_t2d_species.qza

#then run ancombc
qiime composition ancombc \
  --i-table merged_table_gg2_f_t2d_species.qza \
  --m-metadata-file Luis_metadata_t2d_ancom.txt \
  --p-formula "diseaseAncom" \
  --o-differentials ancombc-Luis_metadata_t2d_ancom.qza

#now make a visualization of the ancombc results

qiime composition da-barplot \
  --i-data ancombc-Luis_metadata_t2d_ancom.qza \
  --p-significance-threshold 0.001 \
  --p-level-delimiter ";s__" \
  --o-visualization ancombc-Luis_metadata_t2d_ancom_species.qzv

qiime composition ancombc \
  --i-table merged_table_gg2_f_t2d_species.qza \
  --m-metadata-file Luis_metadata_t2d_ancom.txt \
  --p-formula "age + diseaseAncom" \
  --o-differentials ancombc-Luis_metadata_t2dAge_ancom.qza

#now make a visualization of the ancombc results
qiime composition da-barplot \
  --i-data ancombc-Luis_metadata_t2dAge_ancom.qza \
  --p-significance-threshold 0.001 \
  --p-level-delimiter ";s__" \
  --o-visualization ancombc-Luis_metadata_t2dAge_ancomS.qzv

#now do age* diseaseAncom

qiime composition ancombc \
  --i-table merged_table_gg2_f_t2d_species.qza \
  --m-metadata-file Luis_metadata_t2d_ancom.txt \
  --p-formula "age * diseaseAncom" \
  --o-differentials ancombc-Luis_metadata_t2dxAge_ancom.qza

#now make a visualization of the ancombc results
qiime composition da-barplot \
  --i-data ancombc-Luis_metadata_t2dxAge_ancom.qza \
  --p-significance-threshold 0.01 \
  --o-visualization ancombc-Luis_metadata_t2dxAge_ancom01.qzv

#ok now add a new column to Luis_metadata_t2d_ancom.txt where age and diseaseAncom are combined into a new column called ageDiseaseAncom where the values are 'Adult_ObesityT2D', 'Children_ObesityT2D', 'Adult_Healthy', 'Children_Healthy'

python
import pandas as pd
#read in the Luis_metadata_t2d_ancom.txt file
df = pd.read_csv('Luis_metadata_t2d_ancom.txt', sep='\t')
#add a new column called ageDiseaseAncom where the values are 'Adult_ObesityT2D', 'Children_ObesityT2D', 'Adult_Healthy', 'Children_Healthy'
df['ageDiseaseAncom'] = df.apply(lambda x: f"{x['age']}_{x['diseaseAncom']}", axis=1)
df['ageDiseaseAncom'].unique()
#write the df to a tsv file
df.to_csv('Luis_metadata_t2d_ancom_ageDisease.txt', sep='\t', index=False)
exit()

#now run ancombc on the merged_table_gg2_f_t2d_species.qza file with the Luis_metadata_t2d_ancom_ageDisease.txt file on the ageDiseaseAncom column  (adding a 2 here so for original without reference level set look for non 2)

qiime composition ancombc \
  --i-table merged_table_gg2_f_t2d_species.qza \
  --m-metadata-file Luis_metadata_t2d_ancom_ageDisease.txt \
  --p-formula "ageDiseaseAncom" \
  --p-reference-levels "ageDiseaseAncom::Adult_Healthy" \
  --o-differentials ancombc-Luis_metadata_t2dAgeDisease_ancom2.qza

#now make a visualization of the ancombc results
qiime composition da-barplot \
  --i-data ancombc-Luis_metadata_t2dAgeDisease_ancom.qza \
  --p-significance-threshold 0.01 \
  --o-visualization ancombc-Luis_metadata_t2dAgeDisease_ancom01.qzv


#filter Luis_metadata_t2d_ancom.txt to just Adult
python
import pandas as pd
#read in the Luis_metadata_t2d_ancom.txt file
df = pd.read_csv('Luis_metadata_t2d_ancom.txt', sep='\t')
#filter the df to just Adult
df_adult = df[df['age'] == 'Adult']
#write the df_adult to a tsv file
df_adult.to_csv('Luis_metadata_t2d_ancom_adult.txt', sep='\t', index=False)



#now filter the merged_table_gg2_f_t2d_species.qza file to just Adult samples
qiime feature-table filter-samples \
  --i-table merged_table_gg2_f_t2d_species.qza \
  --m-metadata-file Luis_metadata_t2d_ancom.txt \
  --p-where "age='Adult'" \
  --o-filtered-table merged_table_gg2_f_t2d_species_adult.qza

#now run ancombc on the merged_table_gg2_f_t2d_species_adult.qza file with the Luis_metadata_t2d_ancom_adult.txt file on the diseaseAncom column
qiime composition ancombc \
  --i-table merged_table_gg2_f_t2d_species_adult.qza \
  --m-metadata-file Luis_metadata_t2d_ancom_adult.txt \
  --p-formula "diseaseAncom" \
  --o-differentials ancombc-Luis_metadata_t2d_adult_ancom_test.qza \
  --verbose

#now make a visualization of the ancombc results
qiime composition da-barplot \
  --i-data ancombc-Luis_metadata_t2d_adult_ancomOT2D.qza \
  --p-significance-threshold 0.01 \
  --o-visualization ancombc-Luis_metadata_t2d_adult_ancomOT2D01.qzv

  #show unique values in the diseaseAncom column in Luis_metadata_t2d_ancom_adult.txt

  python
import pandas as pd
#read in the Luis_metadata_t2d_ancom_adult.txt file
df = pd.read_csv('Luis_metadata_t2d_ancom_adult.txt', sep='\t')
#show unique values in the diseaseAncom column
print(df['diseaseAncom'].unique())

#show number of values in the diseaseAncom column
print(df['diseaseAncom'].value_counts())

#filter GMTOLsong_table2024_N20_f2all_V4.qza to have no samples with 0 reads

qiime feature-table filter-samples \
  --i-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4.qza \
  --p-min-frequency 1 \
  --o-filtered-table ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_filt.qza

  #then export the table to biom format
qiime tools export \
  --input-path ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_filt.qza \
  --output-path ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_filt

#then rename the biom file to GMTOLsong_table2024_N20_f2all_V4_filt.biom
mv ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_filt/feature-table.biom ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_filt.biom
#then copy the biom file to /ddn_scratch/sdegregori/birdmantest/GMTOLsong_table2024_N20_f2all_V4_filt.biom
cp ~/TOL/phylo/GMTOLsong_table2024_N20_f2all_V4_filt.biom /ddn_scratch/sdegregori/birdmantest/GMTOLsong_table2024_N20_f2all_V4_filt.biom
#then convert to tsv
biom convert \
  --input-fp /ddn_scratch/sdegregori/birdmantest/GMTOLsong_table2024_N20_f2all_V4_filt.biom \
  --output-fp /ddn_scratch/sdegregori/birdmantest/GMTOLsong_table2024_N20_f2all_V4_filt.tsv \
  --to-tsv 

#summarize GMTOLsolo_tableN5.qza
qiime feature-table summarize \
  --i-table GMTOLsolo_tableN5.qza \
  --o-visualization GMTOLsolo_tableN5.qzv

#import 55205_NZdata_Templeton_S0_L001_I1_001.fastq.gz  55205_NZdata_Templeton_S0_L001_R2_001.fastq.gz
55205_NZdata_Templeton_S0_L001_R1_001.fastq.gz files using qiime2 EMP protocol 
 qiime tools import \
  --type EMPPairedEndSequences \
  --input-path jianshu \
  --output-path jianshuGMTOL_NZ_1500.qza


#prune the tree 
/home/mcdonadt/greengenes2/release/2024.09/2024.09.phylogeny.asv.nwk.qza with this feature metadata feature_metadata.tsv

qiime phylogeny filter-tree \
  --i-tree /home/mcdonadt/greengenes2/release/2024.09/2024.09.phylogeny.asv.nwk.qza \
  --m-metadata-file feature_metadata.tsv \
  --o-filtered-tree pruned_tree_2024.09_asv.qza

#export the tree
qiime tools export \
  --input-path pruned_tree_2024.09_asv.qza \
  --output-path pruned_tree_2024.09_asv

  #example code for Igor
#prune this tree: /home/mcdonadt/greengenes2/release/2024.09/2024.09.phylogeny.asv.nwk.qza
  
  from skbio import TreeNode
  import pandas as pd

#load the tree
tree = TreeNode.read('/home/mcdonadt/greengenes2/release/2024.09/2024.09.phylogeny.asv.nwk')
#load the feature metadata file

df = pd.read_csv('feature_metadata.tsv', sep='\t')
#make a list of the features to keep
features_to_keep = set(df['feature-id'])
#prune the tree
pruned_tree = tree.prune(features_to_keep)

cd /projects/cancer_qiita/data/biom_tables/all_studies_current_gg2.2024.9.fna.qza



#use full_metadata.txt and merged_table_gg2.qza to make a table with only samples with age6 not equal to 'NaN'

qiime feature-table filter-samples \
  --i-table merged_table_gg2.qza \
  --m-metadata-file full_metadata.txt \
  --p-where "age6 IS NOT 'NaN'" \
  --o-filtered-table merged_table_gg2_age6.qza

  #and then use the gg2 tree and run core metrics at 1000 sampling depth but use correct path for tree it is somewhere else
wget https://ftp.microbio.me/greengenes_release/2022.10/2022.10.phylogeny.id.nwk.qza
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny 2022.10.phylogeny.id.nwk.qza \
  --i-table merged_table_gg2_age6.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file full_metadata.txt \
  --p-n-jobs-or-threads auto \
  --output-dir core-metrics-results-gg2_age6_1k   

  ~~~~~~~~~~~~~~~~~~~~
  #I want to do gg2 on GMTOLsong_table2024_N20_f2all_f.qza but in the ~TOL/final folder

#installing qiime2 greengenes2 plugin if not already installed on qiime2-2024.5

  qiime greengenes2 non-v4-16s \
    --i-table ~/TOL/final/GMTOLsong_table2024_N20_f2all_f.qza \
    --i-sequences ~/TOL/final/GMTOLsong_seqs2024_N20all_f2.qza \
    --p-threads 4 \
    --i-backbone /home/mcdonadt/greengenes2/release/2024.09/2024.09.backbone.full-length.fna.qza \
    --o-mapped-table ~/TOL/final/GMTOLsong_table2024_N20_f2all_gg2_f.qza \
    --o-representatives ~/TOL/final/GMTOLsong_rep_seqs2024_N20_f2all_gg2_f.qza
 