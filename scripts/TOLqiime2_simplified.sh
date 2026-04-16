#!/bin/bash
# =============================================================================
# TOLqiime2_simplified.sh
# Gut Microbiome Tree of Life (GMToL) — QIIME2 Core Processing Pipeline
# Degregori et al. (2026) — Nature
#
# "An expansive animal gut microbiome dataset elucidates major compositional
#  shifts across bilaterian evolution"
#
# 17,366 samples | 1,553 host species | 26 host classes | 284 studies
# QIIME2 v2024.5 | Greengenes2 v2024.9
#
# Raw sequence fetching:  https://github.com/luisxxu/qiimeseq
# Full analysis code:     https://github.com/samd1993/GutMicrobiomeTreeOfLife
# Data portal:            https://qiita.ucsd.edu/GMToL/
# =============================================================================

conda activate qiime2-amplicon-2024.5


# =============================================================================
# STEP 1: PER-STUDY IMPORT & DEMULTIPLEXING
# Studies include V4 (515F) and V3-V4 (341F) primer regions.
# Raw FASTQs fetched per study via qiimeseq (github.com/luisxxu/qiimeseq).
# Run Steps 1-2 independently for each of the 284 studies.
# =============================================================================

qiime tools import \
  --type EMPPairedEndSequences \
  --input-path raw_data/${STUDY}/ \
  --output-path ${STUDY}_seqs.qza

qiime demux emp-paired \
  --i-seqs ${STUDY}_seqs.qza \
  --m-barcodes-file ${STUDY}_metadata.tsv \
  --m-barcodes-column barcode-sequence \
  --o-per-sample-sequences ${STUDY}_demux.qza \
  --o-error-correction-details ${STUDY}_demux_details.qza

# For single-end studies:
# qiime demux emp-single \
#   --i-seqs ${STUDY}_seqs.qza \
#   --m-barcodes-file ${STUDY}_metadata.tsv \
#   --m-barcodes-column barcode-sequence \
#   --o-per-sample-sequences ${STUDY}_demux.qza


# =============================================================================
# STEP 2: QUALITY FILTERING & DEBLUR DENOISING (per study)
# Forward reads only: V4 (515F) and V3-V4 (341F) studies share the same
# forward start position; reverse reads varied too greatly to merge.
# All studies trimmed to 150bp with Deblur default settings.
# =============================================================================

qiime quality-filter q-score \
  --i-demux ${STUDY}_demux.qza \
  --o-filtered-sequences ${STUDY}_filtered.qza \
  --o-filter-stats ${STUDY}_filter_stats.qza

qiime deblur denoise-16S \
  --i-demultiplexed-seqs ${STUDY}_filtered.qza \
  --p-trim-length 150 \
  --o-representative-sequences ${STUDY}_rep_seqs.qza \
  --o-table ${STUDY}_table.qza \
  --o-stats ${STUDY}_deblur_stats.qza


# =============================================================================
# STEP 3: MERGE ALL 284 STUDIES INTO A SINGLE DATASET
# Produces the raw merged dataset: 4,011,620 unique ASVs, 694M reads.
# =============================================================================

qiime feature-table merge \
  --i-tables study1_table.qza \
  --i-tables study2_table.qza \
  --i-tables studyN_table.qza \
  --o-merged-table merged_table.qza

qiime feature-table merge-seqs \
  --i-data study1_rep_seqs.qza \
  --i-data study2_rep_seqs.qza \
  --i-data studyN_rep_seqs.qza \
  --o-merged-data merged_rep_seqs.qza

qiime feature-table summarize \
  --i-table merged_table.qza \
  --m-sample-metadata-file metadata.tsv \
  --o-visualization merged_table_summary.qzv


# =============================================================================
# STEP 4: TAXONOMY CLASSIFICATION (Greengenes2 v2024.9)
# Full-length 16S classifier ensures proper classification of both
# V3-V4 and V4 amplicon regions.
# =============================================================================

qiime feature-classifier classify-sklearn \
  --i-classifier gg2-2024.9-full-length-classifier.qza \
  --i-reads merged_rep_seqs.qza \
  --o-classification taxonomy.qza

qiime taxa barplot \
  --i-table merged_table.qza \
  --i-taxonomy taxonomy.qza \
  --m-metadata-file metadata.tsv \
  --o-visualization taxa_barplot.qzv


# =============================================================================
# STEP 5: CLOSED-REFERENCE OTU PICKING (Greengenes2 v2024.9)
# Generates the GG2-filtered dataset: only reads that map to the GG2 database.
# This produces two parallel datasets used in downstream analyses:
#   - De novo dataset (merged_table.qza):  all 3,376,978 ASVs after filtering
#   - GG2 dataset (gg2_table.qza):         74,384 ASVs matched to GG2
# The GG2 dataset is used for relative abundance and compositional analyses
# (Fig. 2); the de novo dataset with its MAFFT tree is used for diversity
# analyses to retain ASVs absent from the GG2 reference.
# =============================================================================

qiime greengenes2 non-v4-16s \
  --i-table merged_table.qza \
  --i-sequences merged_rep_seqs.qza \
  --i-backbone gg2-2024.9-backbone.id.nwk.qza \
  --o-mapped-table gg2_table.qza \
  --o-representatives gg2_rep_seqs.qza

qiime feature-table summarize \
  --i-table gg2_table.qza \
  --m-sample-metadata-file metadata.tsv \
  --o-visualization gg2_table_summary.qzv


# =============================================================================
# STEP 6: FILTERING
# Remove eukaryotes, mitochondrial DNA, and non-cyanobacterial chloroplasts.
# Remove singletons (min total frequency = 2) and features present in only
# one sample. Applied to the de novo dataset.
# After filtering: 3,376,978 ASVs; median 27,744 reads/sample.
# =============================================================================

# Remove host-associated contaminants (retain cyanobacteria)
qiime taxa filter-table \
  --i-table merged_table.qza \
  --i-taxonomy taxonomy.qza \
  --p-exclude "eukaryota,mitochondria,chloroplast" \
  --p-include "cyanobacteria" \
  --o-filtered-table no_contam_table.qza

qiime feature-table filter-seqs \
  --i-data merged_rep_seqs.qza \
  --i-table no_contam_table.qza \
  --o-filtered-data no_contam_rep_seqs.qza

# Remove singletons and features present in only one sample
qiime feature-table filter-features \
  --i-table no_contam_table.qza \
  --p-min-frequency 2 \
  --p-min-samples 2 \
  --o-filtered-table filtered_table.qza

qiime feature-table filter-seqs \
  --i-data no_contam_rep_seqs.qza \
  --i-table filtered_table.qza \
  --o-filtered-data filtered_rep_seqs.qza

qiime feature-table summarize \
  --i-table filtered_table.qza \
  --m-sample-metadata-file metadata.tsv \
  --o-visualization filtered_table_summary.qzv


# =============================================================================
# STEP 7: MULTI-KINGDOM PHYLOGENETIC TREE (MAFFT + FastTree)
# De novo tree construction within QIIME2 v2024.5. Used for all alpha and
# beta diversity analyses (Faith's PD, UniFrac) to capture the full breadth
# of ASVs, including those absent from the Greengenes2 reference.
# =============================================================================

qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences filtered_rep_seqs.qza \
  --o-alignment aligned_rep_seqs.qza \
  --o-masked-alignment masked_aligned_rep_seqs.qza \
  --o-tree unrooted_tree.qza \
  --o-rooted-tree rooted_tree.qza


# =============================================================================
# STEP 8: ALPHA & BETA DIVERSITY
# Restricted to V4 samples (515F primer; majority of dataset and host
# diversity). Rarefied to 1,000 reads, retaining >90% of samples.
# Alpha: Faith's phylogenetic diversity and Shannon's diversity (Fig. 3C).
# Beta: unweighted UniFrac distances (Fig. 3A, 3B).
# Environmental samples (algae, sediment, saline/non-saline water) included
# as outgroups and treated as their own class.
# =============================================================================

# Subset to V4 samples only
qiime feature-table filter-samples \
  --i-table filtered_table.qza \
  --m-metadata-file metadata.tsv \
  --p-where "[primer_region]='V4'" \
  --o-filtered-table v4_table.qza

# Core phylogenetic diversity metrics, rarefied to 1,000 reads
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rooted_tree.qza \
  --i-table v4_table.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file metadata.tsv \
  --output-dir diversity_results/

# Rarefaction curve to confirm 1,000 reads retains >90% of samples
qiime diversity alpha-rarefaction \
  --i-table v4_table.qza \
  --i-phylogeny rooted_tree.qza \
  --p-max-depth 5000 \
  --m-metadata-file metadata.tsv \
  --o-visualization alpha_rarefaction.qzv


# =============================================================================
# STEP 9: PAIRWISE PERMANOVA BY HOST CLASS
# Tests significance of gut microbiome composition differences across
# 26 host classes using unweighted UniFrac distances.
# Environmental samples included as outgroup class.
# Result: F=27.11, p<=0.001, df=22 (Fig. 3A).
# =============================================================================

qiime diversity beta-group-significance \
  --i-distance-matrix diversity_results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata.tsv \
  --m-metadata-column host_class \
  --p-method permanova \
  --p-pairwise \
  --o-visualization host_class_permanova.qzv


# =============================================================================
# STEP 10: HEATMAP OF MICROBIAL TAXA ACROSS HOST CLASSES
# Filtered to features with >100 reads present in >=5 samples.
# Euclidean distance dendrograms connecting samples and features.
# Log-transformed color gradients account for the wide range of
# relative abundances across taxa (Fig. 3D).
# =============================================================================

qiime feature-table filter-features \
  --i-table filtered_table.qza \
  --p-min-frequency 100 \
  --p-min-samples 5 \
  --o-filtered-table heatmap_input_table.qza

qiime feature-table heatmap \
  --i-table heatmap_input_table.qza \
  --m-sample-metadata-file metadata.tsv \
  --m-sample-metadata-column host_class \
  --p-metric euclidean \
  --p-cluster both \
  --o-visualization heatmap.qzv


# =============================================================================
# STEP 11: EXPORT FOR DOWNSTREAM ANALYSES
# =============================================================================

# De novo feature table (biom + tsv)
# Used for: BIRDMAn differential abundance by host class (Fig. 6;
#   scripts/TOLbirdman.sh) and DESeq2 vertebrate vs. invertebrate
#   comparisons (Table S5)
qiime tools export \
  --input-path filtered_table.qza \
  --output-path exported/denovo_table/

biom convert \
  -i exported/denovo_table/feature-table.biom \
  -o exported/denovo_table/feature-table.tsv \
  --to-tsv

# GG2-filtered feature table (biom + tsv)
# Used for: relative abundance analyses, Bacillota_A:Pseudomonadota ratio
#   (Fig. 2C), phylum-level composition across host phylogeny (Fig. 2A),
#   and ancestral state reconstruction inputs (Fig. 4)
qiime tools export \
  --input-path gg2_table.qza \
  --output-path exported/gg2_table/

biom convert \
  -i exported/gg2_table/feature-table.biom \
  -o exported/gg2_table/feature-table.tsv \
  --to-tsv

# Rooted de novo tree → Faith's PD, unweighted UniFrac
qiime tools export \
  --input-path rooted_tree.qza \
  --output-path exported/tree/

# Taxonomy → filtering, iTOL tip annotations (Fig. 2, 5)
qiime tools export \
  --input-path taxonomy.qza \
  --output-path exported/taxonomy/

# Alpha diversity vectors → Faith's PD and Shannon (Fig. 3C, Table S3)
qiime tools export \
  --input-path diversity_results/faith_pd_vector.qza \
  --output-path exported/alpha/

qiime tools export \
  --input-path diversity_results/shannon_vector.qza \
  --output-path exported/alpha/

# Unweighted UniFrac distance matrix → PCoA (Fig. 3A, 3B), PERMANOVA (Table S3)
qiime tools export \
  --input-path diversity_results/unweighted_unifrac_distance_matrix.qza \
  --output-path exported/unifrac/

# PCoA results → ordination plots (Fig. 3A, 3B)
qiime tools export \
  --input-path diversity_results/unweighted_unifrac_pcoa_results.qza \
  --output-path exported/pcoa/


# =============================================================================
# DOWNSTREAM ANALYSES (outside QIIME2; see scripts/ for full code)
# =============================================================================
#
# Ancestral state reconstruction — ABDOMEN v1.0 (R)
#   Input:      GG2-filtered relative abundances at phylum and order rank
#   Parameters: detection threshold=0.00001, prior='empirical',
#               4 chains, 2,000 iterations
#   Output:     Ancestral gut microbiome composition across host tree (Fig. 4)
#   Script:     scripts/ABDOMEN.R
#
# Differential abundance by host class — BIRDMAn (R; Rahman et al. 2023)
#   Input:      De novo feature table
#   Output:     Enriched taxa per class; log-ratio construction (Fig. 6)
#   Script:     scripts/TOLbirdman.sh
#
# Differential abundance, vertebrate vs. invertebrate — DESeq2 (R)
#   Input:      De novo feature table
#   Output:     Significantly associated taxa (Table S5, padj<0.05)
#
# Host phylogeny — TimeTree (timetree.org; Kumar et al. 2022)
#   Output:     Time-calibrated host tree; used for ancestral reconstruction
#               and all iTOL tip annotations
#
# Host tree visualization — iTOL v7 (https://itol.embl.de/)
#   Input:      TimeTree host phylogeny + exported relative abundances/
#               presence-absence data
#   Output:     Annotated host trees (Fig. 2A, 5B-D)
