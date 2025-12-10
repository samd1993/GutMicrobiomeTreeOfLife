#in python read in Degregori_etal_Comparative_Review_metadata_qiimeseq_merge.txt
import pandas as pd
# Read in the metadata file
metadata = pd.read_csv('Degregori_etal_Comparative_Review_metadata_qiimeseq_merge.txt', sep='\t')
#now group the Accession Number column and show unique Genus within each Accession
grouped = metadata.groupby('Accession Number')['Genus'].unique().reset_index()
grouped 
#now sort by Accession Numbers with the most unique Genus counts and then print out the top 20
grouped['Unique_Genus_Count'] = grouped['Genus'].apply(len)
top20 = grouped.sort_values(by='Unique_Genus_Count', ascending=False).head(20)
print(top20)

#ok now collapse this by Accession Number and take the first row of each Accession Number to output as a collapsed table. But note the rows are all different and not duplicates
collapsed = metadata.drop_duplicates(subset=['Accession Number'])
collapsed.to_csv('Degregori_etal_Comparative_Review_metadata_qiimeseq_merge_collapsed.txt', sep='\t', index=False)
