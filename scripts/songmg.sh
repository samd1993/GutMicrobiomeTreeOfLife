wget "https://qiita.ucsd.edu/public_download/?data=raw&study_id=11166"

wget "https://qiita.ucsd.edu/public_download/?data=raw&study_id=14696"

#doesnt work because its private I guess? song mg artifact ID in qiita is: 99857
#according to daniel I first do this in term: REDBIOM_HOST=http://redbiom.ucsd.edu:7330
#then look for files in /qmounts/qiita_data/per_sample_FASTQ

cd /qmounts/qiita_data/per_sample_FASTQ #at root

ls /qmounts/qiita_data/per_sample_FASTQ/99857
#and then moved all files here to my folder
#now moving levin et al which is ID 154180 for Prep 2 and 154188 for Prep 1

ls /qmounts/qiita_data/per_sample_FASTQ/154180

ls /qmounts/qiita_data/per_sample_FASTQ/154188

#making these 2 scratch folders
/panfs/sdegregori/songfastq
/panfs/sdegregori/songlevinfastq

cp /qmounts/qiita_data/per_sample_FASTQ/99857/* /ddn_scratch/sdegregori/songfastq/
cp /qmounts/qiita_data/per_sample_FASTQ/154180/* /panfs/sdegregori/levinfastq/
cp /qmounts/qiita_data/per_sample_FASTQ/154188/* /panfs/sdegregori/levinfastq/

#holding off on Levin so I dont take up uneccessary storage







#downloading Spades and trying assembly with it

    wget https://github.com/ablab/spades/releases/download/v4.0.0/SPAdes-4.0.0-Linux.tar.gz
    tar -xzf SPAdes-4.0.0-Linux.tar.gz
    cd SPAdes-4.0.0-Linux/bin/

    #exporting it to home so i can run one liners
export PATH="$HOME/SPAdes-4.0.0-Linux/bin:$PATH"

spades.py --test

bin/spades.py --meta -1 left.fastq.gz -2 right.fastq.gz -o output_folder

#!/bin/bash
#SBATCH -J TOL
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samdegregori@gmail.com
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --mem=64G
#SBATCH -t 1-00
#SBATCH -p rocky9_test
#SBATCH -o Output_Files/slurm-songMAG-%A-%a.out 
#SBATCH -e Error_Files/slurm-songMAG-%A-%a.err

bash
cd /ddn_scratch/sdegregori/songfastq/
export  PATH="$HOME/SPAdes-4.0.0-Linux/bin:$PATH"

sed -n "${SLURM_ARRAY_TASK_ID}p" ../songMAGmeta.txt | while read sample R1 R2 x; do 

	if [ -z "${sample:-}" ]; then
		continue
	fi
	out_dir=spadesout2/${sample}
	if [ ! -s $out_dir/scaffold.fasta ]; then
		spades.py --meta -t 16 -1 ${R1} -2 ${R2} -o ${out_dir}
	fi
done

sed -n songMAGmeta.txt | echo $sample

for file1 in *R1*fastq
do 
file2=${file1/R1/R2}
out=${file1%%.fastq}_output
spades.py --careful -1 $file1 -2 $file2 -o $out &
done


#! /bin/bash
for i in `ls *R1_filtered.fastq.gz`

        do
        echo $i
        
        echo "Input file 1: " $1
        fastq=$1
        # derive R2 from R1
        fastq2="${fastq/R1/R2}"
        echo $fastq
        echo $fastq2
        # Run script

        spades.py -o $fastq.spades -t 1 --meta -1 $fastq -2 $fastq2

done

#none of these are working trying katies again

#!/bin/bash
#SBATCH -J TOL
#SBATCH --mail-type=ALL
#SBATCH --mail-user=samdegregori@gmail.com
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --mem=64G
#SBATCH -t 1-00
#SBATCH -p rocky9_test
#SBATCH -o outputkatie.log
#SBATCH --array=1-16%16

echo "Starting spades job"

file=$(ls *R1_filtered.fastq.gz | sed -n ${SLURM_ARRAY_TASK_ID}p)

file2=${file/R1/R2}

spades.py --meta -1 $file -2 $file2 -o ${file%%_R1_filtered.fastq.gz}

echo "Finishing spades job"


