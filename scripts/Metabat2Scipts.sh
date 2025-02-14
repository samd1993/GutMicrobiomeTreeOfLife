#example code from metabat tutorial github
bowtie2 -f  -x AlgaeBowtie -U Algae_11.renum.fna > Algae_11.renum.fna.AllReads.sam
samtools view -bS  Algae_11.renum.fna.AllReads.sam  | samtools 
sort – Algae_11..fna.AllReads

#exporting database to path first
#YOUHAVE to sepcify basename. So here I made a db foler inside db but instead of just db/db I have to put db/db/db to specify the basename of files since they all are db. something
export BOWTIE2_INDEXES=/home/sdegregori/woltka/db/db/db


#old one not working. Trying to build new one

bowtie2-build genomes/concat.fna db --threads 8 --large-index

#trying only woltka code before i do the above sam tools stuff
bowtie2 -x $BOWTIE2_INDEXES -1 Aptenodytes-patagonicus_S_S_Temp_D710-AK1680_R1_filtered.fastq.gz -2 Aptenodytes-patagonicus_S_S_Temp_D710-AK1680_R2_filtered.fastq.gz -S samout/Aptenodytes-patagonicus_S_S_Temp_D710-AK1680.sam --very-sensitive --no-head --no-unal

#not working. Trying to reinstall bowtie2

mamba create --name myenvname bowtie2
conda rename -n myenvname binn
mamba install -c bioconda samtools

#now trying a forloop to run bowtie2 on all paired end files and making the bam file and sorting it
#have to set BOWTIE_INDEXES also..use code above #REMEMBER TO ADD extra db to filepath...

for i in *R1_filtered.fastq.gz 
    do 
    dir=/ddn_scratch/sdegregori/songfastq/ 
    bowtie2 -p 4 -x $BOWTIE2_INDEXES -1 $dir/${i} -2 $dir/${i%R1_filtered.fastq.gz}R2_filtered.fastq.gz | samtools view -b -o $dir/${i%R1_filtered.fastq.gz}.bam
    done > bowtie2output.txt

basename Suricata-suricatta_S_S_Temp_D705-AK1681_R1_filtered.fastq.gz

#trying sort bam on one of the bam files. I shoul have done this in the for loop

samtools sort Torgos-tracheliotus_S_S_Temp_D703-AK1682_.bam -o Torgos-tracheliotus_S_S_Temp_D703-AK1682_sorted.bam

runMetaBat.sh Torgos-tracheliotus_S_S_Temp_D703-AK1682/scaffolds.fasta Torgos-tracheliotus_S_S_Temp_D703-AK1682_sorted.bam

#forum says I can run metabat2 itself to see if it works

metabat2 -i Torgos-tracheliotus_S_S_Temp_D703-AK1682/scaffolds.fasta  -o metabat2out/bins

#desnt work have to redo it by building scaffolds.db and then running metabat2

Torgos-tracheliotus_S_S_Temp_D703-AK1682_R1_filtered.fastq.gz
Torgos-tracheliotus_S_S_Temp_D703-AK1682_R2_filtered.fastq.gz

bowtie2-build Torgos-tracheliotus_S_S_Temp_D703-AK1682/scaffolds.fasta Torgos-tracheliotus_S_S_Temp_D703-AK1682/scaffolds.db

bowtie2 -x Torgos-tracheliotus_S_S_Temp_D703-AK1682/scaffolds.db -q --phred33 --very-sensitive --no-unal -S Torgos-tracheliotus_S_S_Temp_D703-AK1682/file.sam -1 Torgos-tracheliotus_S_S_Temp_D703-AK1682_R1_filtered.fastq.gz -2 Torgos-tracheliotus_S_S_Temp_D703-AK1682_R2_filtered.fastq.gz -p 4

samtools view -bS file.sam | samtools sort -o sorted.bam

#now I can run metabat2 and it works

runMetaBat.sh scaffolds.fasta sorted.bam

#now trying checkM2 install with bioconda with forge channel #apparently needs python V less whtn 3.9
conda
conda create -c bioconda -c conda-forge checkm2 -python=3.8

conda remove --prefix "/ddn_scratch/sdegregori/songfastq/Torgos-tracheliotus_S_S_Temp_D703-AK1682/ython=3.8" --all

#install and create a checkm2 env with python=3.8
conda create -c bioconda -c conda-forge -n checkm2 python=3.8
conda remove --all -n checkm2

#not working
git clone --recursive https://github.com/chklovski/checkm2.git && cd checkm2
conda env create -n checkm2 -f checkm2.yml
conda activate checkm2

checkm2 predict --threads 4 -x fa --input scaffolds.fasta.metabat-bins-20250120_181114 --output-directory checkout
#fyi had to download the checkm2 database first and also add the -x fa option because default is fna 
#run checkm2



