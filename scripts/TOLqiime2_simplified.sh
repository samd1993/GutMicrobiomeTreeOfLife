#!/bin/bash
# =============================================================================
# TOLqiime2_simplified.sh
# Gut Microbiome Tree of Life (GMTOL) - QIIME2 Analysis Pipeline
# Core workflow for 16S rRNA amplicon data processing and diversity analysis
# =============================================================================

# ---- Environment ----
conda activate qiime2-amplicon-2024.10


# =============================================================================
# STEP 1: IMPORT & DEMULTIPLEX
# =============================================================================

# Import raw multiplexed sequences (EMP paired-end format)
qiime tools import \
  --type EMPPairedEndSequences \
  --input-path raw_data/ \
  --output-path demux_input.qza

# Demultiplex using sample barcodes
qiime demux emp-paired \
  --i-seqs demux_input.qza \
  --m-barcodes-file metadata.tsv \
  --m-barcodes-column barcode-sequence \
  --o-per-sample-sequences demux.qza \
  --o-error-correction-details demux_details.qza

qiime demux summarize \
  --i-data demux.qza \
  --o-visualization demux_summary.qzv

# For single-end data (use instead of emp-paired above)
# qiime demux emp-single \
#   --i-seqs demux_input.qza \
#   --m-barcodes-file metadata.tsv \
#   --m-barcodes-column barcode-sequence \
#   --o-per-sample-sequences demux.qza


# =============================================================================
# STEP 2: QUALITY FILTERING & DENOISING
# =============================================================================

# Option A: Deblur (primary method used in GMTOL)
qiime quality-filter q-score \
  --i-demux demux.qza \
  --o-filtered-sequences demux_filtered.qza \
  --o-filter-stats demux_filter_stats.qza

qiime deblur denoise-16S \
  --i-demultiplexed-seqs demux_filtered.qza \
  --p-trim-length 150 \
  --o-representative-sequences rep_seqs.qza \
  --o-table table.qza \
  --o-stats deblur_stats.qza

# Option B: DADA2 paired-end (alternative)
# qiime dada2 denoise-paired \
#   --i-demultiplexed-seqs demux.qza \
#   --p-trim-left-f 0 \
#   --p-trim-left-r 0 \
#   --p-trunc-len-f 230 \
#   --p-trunc-len-r 200 \
#   --o-representative-sequences rep_seqs.qza \
#   --o-table table.qza \
#   --o-denoising-stats dada2_stats.qza


# =============================================================================
# STEP 3: MERGE ACROSS STUDIES
# =============================================================================

# Merge feature tables from multiple studies
qiime feature-table merge \
  --i-tables study1_table.qza \
  --i-tables study2_table.qza \
  --i-tables study3_table.qza \
  --o-merged-table merged_table.qza

# Merge corresponding representative sequences
qiime feature-table merge-seqs \
  --i-data study1_rep_seqs.qza \
  --i-data study2_rep_seqs.qza \
  --i-data study3_rep_seqs.qza \
  --o-merged-data merged_rep_seqs.qza

qiime feature-table summarize \
  --i-table merged_table.qza \
  --m-sample-metadata-file metadata.tsv \
  --o-visualization merged_table_summary.qzv


# =============================================================================
# STEP 4: TAXONOMY CLASSIFICATION & FILTERING
# =============================================================================

# Classify sequences using GreenGenes2 (non-V4 full-length approach used in GMTOL)
qiime greengenes2 non-v4-16s \
  --i-table merged_table.qza \
  --i-sequences merged_rep_seqs.qza \
  --i-backbone gg2_2022_10.phylogeny.id.nwk.qza \
  --o-mapped-table gg2_table.qza \
  --o-representatives gg2_rep_seqs.qza

# Alternative: sklearn classifier
# qiime feature-classifier classify-sklearn \
#   --i-classifier silva_classifier.qza \
#   --i-reads merged_rep_seqs.qza \
#   --o-classification taxonomy.qza

# Remove non-bacterial features (mitochondria, chloroplasts, eukaryota)
qiime taxa filter-table \
  --i-table gg2_table.qza \
  --i-taxonomy taxonomy.qza \
  --p-exclude mitochondria,chloroplast,eukaryota \
  --o-filtered-table filtered_table.qza

# Filter sequences to match filtered table
qiime feature-table filter-seqs \
  --i-data merged_rep_seqs.qza \
  --i-table filtered_table.qza \
  --o-filtered-data filtered_rep_seqs.qza

# Taxonomy bar plots
qiime taxa barplot \
  --i-table filtered_table.qza \
  --i-taxonomy taxonomy.qza \
  --m-metadata-file metadata.tsv \
  --o-visualization taxa_barplot.qzv

# Collapse to genus level (level 6) for downstream analyses
qiime taxa collapse \
  --i-table filtered_table.qza \
  --i-taxonomy taxonomy.qza \
  --p-level 6 \
  --o-collapsed-table genus_table.qza


# =============================================================================
# STEP 5: SAMPLE FILTERING
# =============================================================================

# Filter samples to species/group of interest
qiime feature-table filter-samples \
  --i-table filtered_table.qza \
  --m-metadata-file metadata.tsv \
  --p-where "[host_species]='Homo sapiens'" \
  --o-filtered-table species_table.qza

# Remove low-frequency features
qiime feature-table filter-features \
  --i-table species_table.qza \
  --p-min-frequency 10 \
  --p-min-samples 2 \
  --o-filtered-table qc_table.qza

qiime feature-table summarize \
  --i-table qc_table.qza \
  --m-sample-metadata-file metadata.tsv \
  --o-visualization qc_table_summary.qzv


# =============================================================================
# STEP 6: PHYLOGENETIC TREE CONSTRUCTION
# =============================================================================

# Build phylogenetic tree via MAFFT alignment + FastTree
qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences filtered_rep_seqs.qza \
  --o-alignment aligned_rep_seqs.qza \
  --o-masked-alignment masked_aligned_rep_seqs.qza \
  --o-tree unrooted_tree.qza \
  --o-rooted-tree rooted_tree.qza

# (When using GreenGenes2, the backbone tree is used directly)
# Filter tree to match feature table
qiime phylogeny filter-tree \
  --i-tree rooted_tree.qza \
  --i-table qc_table.qza \
  --o-filtered-tree filtered_tree.qza


# =============================================================================
# STEP 7: ALPHA & BETA DIVERSITY
# =============================================================================

# Core phylogenetic diversity metrics (rarefied)
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny filtered_tree.qza \
  --i-table qc_table.qza \
  --p-sampling-depth 1000 \
  --m-metadata-file metadata.tsv \
  --output-dir diversity_results/

# Alpha rarefaction curves (to determine appropriate sampling depth)
qiime diversity alpha-rarefaction \
  --i-table qc_table.qza \
  --i-phylogeny filtered_tree.qza \
  --p-max-depth 5000 \
  --m-metadata-file metadata.tsv \
  --o-visualization alpha_rarefaction.qzv

# Alpha diversity group significance
qiime diversity alpha-group-significance \
  --i-alpha-diversity diversity_results/faith_pd_vector.qza \
  --m-metadata-file metadata.tsv \
  --o-visualization faith_pd_significance.qzv

# Beta diversity group significance (PERMANOVA)
qiime diversity beta-group-significance \
  --i-distance-matrix diversity_results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata.tsv \
  --m-metadata-column host_species \
  --p-method permanova \
  --o-visualization unweighted_unifrac_significance.qzv

# PERMANOVA via adonis (multi-variable)
qiime diversity adonis \
  --i-distance-matrix diversity_results/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file metadata.tsv \
  --p-formula "host_species + diet + age" \
  --o-visualization adonis_results.qzv


# =============================================================================
# STEP 8: DIFFERENTIAL ABUNDANCE
# =============================================================================

# ANCOM-BC differential abundance analysis
qiime composition ancombc \
  --i-table genus_table.qza \
  --m-metadata-file metadata.tsv \
  --p-formula "host_species" \
  --o-differentials ancombc_differentials.qza

qiime composition da-barplot \
  --i-data ancombc_differentials.qza \
  --o-visualization ancombc_barplot.qzv


# =============================================================================
# STEP 9: DIMENSIONALITY REDUCTION (GEMELLI)
# =============================================================================

# Phylogenetic RPCA (handles compositional + phylogenetic structure)
qiime gemelli phylogenetic-rpca-with-taxonomy \
  --i-table filtered_table.qza \
  --i-phylogeny filtered_tree.qza \
  --i-taxonomy taxonomy.qza \
  --p-min-feature-count 10 \
  --p-min-sample-count 500 \
  --o-biplot rpca_biplot.qza \
  --o-distance-matrix rpca_distance_matrix.qza \
  --o-counts-by-node rpca_counts_by_node.qza \
  --o-t2t-taxonomy rpca_t2t_taxonomy.qza \
  --o-counts-by-node-taxonomy rpca_counts_by_node_taxonomy.qza


# =============================================================================
# STEP 10: VISUALIZATION
# =============================================================================

# Interactive phylogenetic tree with microbiome data (EMPress)
qiime empress community-plot \
  --i-tree filtered_tree.qza \
  --i-feature-table qc_table.qza \
  --m-sample-metadata-file metadata.tsv \
  --m-feature-metadata-file taxonomy.qza \
  --o-visualization empress_community_plot.qzv

# Export feature table to biom/tsv for downstream R/Python analyses
qiime tools export \
  --input-path qc_table.qza \
  --output-path exported_table/

# Convert biom to TSV
biom convert \
  -i exported_table/feature-table.biom \
  -o exported_table/feature-table.tsv \
  --to-tsv

# Export rooted tree (for use in R packages like phyloseq)
qiime tools export \
  --input-path filtered_tree.qza \
  --output-path exported_tree/

# Export taxonomy
qiime tools export \
  --input-path taxonomy.qza \
  --output-path exported_taxonomy/
