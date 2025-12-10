#read in GMTOLsong_table2024_N20_f2all_gg2_f_Phylum_rel.tsv which has relative abundances for all samples in GMTOL at phyla level. Samples are columns, taxa are rows.
#read in Nov20_25_GMTOL_metadata_all.txt which has metadata for all samples in GMTOL including Class.

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
# Read in the relative abundance table
rel_abund = pd.read_csv('GMTOLsong_table2024_N20_f2all_gg2_f_Phylum_rel.tsv', sep='\t', index_col=0)
# Read in the metadata file
metadata = pd.read_csv('Nov20_25_GMTOL_metadata_all.txt', sep='\t')

# Transpose the relative abundance table so that samples are rows and taxa are columns
rel_abund_t = rel_abund.T
# Merge the relative abundance data with the metadata
merged = rel_abund_t.merge(metadata, left_index=True, right_on='sampleid')
#First I want to group by Chordata and plot relative abundances of phyla to compare Vertebrate to Invertebrate. I want to do this for d__Bacteria;p__Bacillota_A_368345, d__Bacteria;p__Pseudomonadota, d__Bacteria;p__Bacteroidota, and d__Bacteria;p__Bacillota_I. And I want to show error bars as well

# Define the phyla of interest
phyla_of_interest = ['d__Bacteria;p__Bacillota_A_368345', 'd__Bacteria;p__Pseudomonadota', 'd__Bacteria;p__Bacteroidota', 'd__Bacteria;p__Bacillota_I']
# Filter the merged data for the phyla of interest
filtered = merged[['Chordata'] + phyla_of_interest]
# Melt the dataframe for easier plotting
melted = filtered.melt(id_vars='Chordata', value_vars=phyla_of_interest, var_name='Phylum', value_name='Relative_Abundance')
# Plot the relative abundances with error bars
plt.figure(figsize=(10, 6))
sns.barplot(data=melted, x='Phylum', y='Relative_Abundance', hue='Chordata', ci='sem')
plt.title('Relative Abundance of Selected Phyla by Chordata Presence')
plt.ylabel('Relative Abundance')
plt.xlabel('Phylum')
plt.legend(title='Chordata Presence')
plt.tight_layout()
plt.savefig('GMTOL_phylym_relAbund_by_Chordata.png')
plt.show()


