#run core metrics with metadata_2024Feb02.tsv and GMTOLhumanNov2023_Sam_rooted_tree.qza on qiime2/V4human_table.qza and then on the V3V4human_table.qza

#trying it on quest so had to do module load qiime2/2024.5-amplicon

qiime diversity core-metrics-phylogenetic --i-phylogeny GMTOLhumanNov2023_Sam_rooted_tree.qza --i-table qiime2/V4human_table.qza --p-sampling-depth 1000 --m-metadata-file metadata_2024Feb02.tsv --output-dir qiime2/core-metrics-results-V4human

qiime diversity core-metrics-phylogenetic --i-phylogeny GMTOLhumanNov2023_Sam_rooted_tree.qza --i-table qiime2/V3V4human_table.qza --p-sampling-depth 1000 --m-metadata-file metadata_2024Feb02.tsv --output-dir qiime2/core-metrics-results-V3V4human

#filter V4 table to only have Preschool and Adult for Age2

qiime feature-table filter-samples --i-table qiime2/V4human_table.qza --m-metadata-file metadata_2024Feb02.tsv --p-where "Age2='Preschool' OR Age2='Adult'" --o-filtered-table qiime2/V4human_table_Preschool_Adult.qza

#install Aldex2 on qiime2 ..have to install older qiime2 2020.11 seems to work

wget https://data.qiime2.org/distro/core/qiime2-2020.11-py36-linux-conda.yml
conda env create -n qiime2-2020.11 --file qiime2-2020.11-py36-linux-conda.yml
# OPTIONAL CLEANUP
rm qiime2-2020.11-py36-linux-conda.yml

conda activate qiime2-2020.11

conda install bioconductor-aldex2 -c defaults -c bioconda -c conda-forge

conda install -c dgiguere q2-aldex2

qiime dev refresh-cache

qiime aldex2 --help

#have to convert this to qiime2 2020.11 format

qiime tools export --input-path V4human_table_Preschool_Adult.qza --output-path .
#import it back 

qiime tools import --input-path feature-table.biom --type 'FeatureTable[Frequency]' --input-format BIOMV210Format --output-path V4human_table_Preschool_Adult_oldqiime.qza

#then run Aldex2 on these two factors

qiime aldex2 aldex2 --i-table V4human_table_Preschool_Adult_oldqiime.qza --m-metadata-file metadata_2024Feb02.tsv --m-metadata-column Age2 --output-dir aldex2-V4human_Preschool_Adult
