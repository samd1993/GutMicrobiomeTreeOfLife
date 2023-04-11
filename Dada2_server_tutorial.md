# How to access QUEST and submit a SLURM job
This tutorial will show you how to access a High Performance Cluster (HPC) from your own terminal. Most research labs and tech companies utilize some kind of clustering of compute power so employees can run computational intensive tasks and keep everything in the same place rather than running things locally on their own machine.
## Step 1: Access QUEST and make your project folder
Open your terminal and type

`ssh username@quest.northwestern.edu`

where username is your northwestern netID. Just like http is the protocol for accessing websites on your browser, SSH is the protocol to access remote servers.

You should be prompted with a password request. Type your netID password. The screen will be blank while you type for security reasons.

If entered correctly you should see the quest logo and then you will have entered the server.

You will notice you are in your $HOME directory. To access our project folder you will have to type:

`cd /projects/p31966/`

Because there is 15 of us, make your own project directory named after yourself (I do "sdegregori" for example).

`mkdir <yourname>
cd <yourname>`

All of your output files will end up here. 
But the actual qiime commands you should run in your $HOME directory. So now go back to home with `cd ~`. The ~ always takes you back to home directory. 


## Step 2: Download fastq.gz files
Make a directory for your next study as you usually do such as `mkdir arizza`. Then `cd arizza` to move into your study directory. Next, go to SRA explorer and enter the accession number of your study and copy and paste the curl commands into your terminal. These should download into your directory.
## Step 3: Make manifest file
 In your terminal, type:
  `vim <studyname>manifest.text`. 
This command will basically make a file named manifest.txt and bring you to a text editor. 
Now press `i` which takes you into edit mode copy and paste your manifest spreadsheet you made into this file. Make sure everything including the first row got pasted correctly. Now press the `Esc key` which will exit edit mode and now type `:wq` and then `Enter`. That will save and exit. Now when you type `ls` the file should appear. If you type `cat <studyname>manifest.txt` (remember to utilize tab to autofinish) it should print out correctly.
## Step 4: SRUN
Now we are ready to import.

Before you do however, it is bad etiquette to run any kind of computation in the login node. When you login to any kind of server you are in the login node. To formally request for memory to compute on you can run someting like this:

`srun --account=p31966 --time=2:00:00 --partition=short --mem=4G --pty bash -l`
  

where the account is our account quest has given us. Time is 2 hours and the memory is 4 gigs. If you want more than 4 hours then change --partition to `--parition=normal` instead of short.


Once your srun has been accepted you can now import your study.

  

## Step 5: Load Qiime2 and import

  

Quest has kindly given us a system wide qiime2 to load up. To do this type:

  `module avail`
  This shows all the available modules we have. You should see qiime2/2022.8

Now type:
`module load qiime2/2022.8`

  
You can now use qiime commands and now you can import your study as we always have done. See the qiime2 walk through tutorial if you need help with this.
The only difference will be downloading the qzv file to see where to trim. See below on how to download that.

## Using Cyberduck to download the demux.qzv file

Because you are on a server, you cannot simply open your File Explorer to find the qzv file. You need to downlaod it from the server onto your computer.
Officiial link: https://cyberduck.io
Once launched. You will want to start a new Bookmark (Bookmark tab on Windows is at the top of the app, on Mac it will be at the top left corner of your screen).


From the drop down menu select SFTP. This is the SSH File Transfer Protocol, the same protocol you used to login to quest.

**Nickname** is whatever you want

**Server** : quest.northwestern.edu

**Username** : NetID

**Password** : NetID password

![ExampleSFTP](https://user-images.githubusercontent.com/22188081/230944027-404d5b8b-0063-43fd-a659-6fba10d6b12e.png)

Once made you can now enter your Bookmark tabs and double click on this to login to Quest. From there, find your demuxfile, left click and download, or hit `Alt + DownArrow`. The file should be in your download folder now, and ready to view on Qiime2 View.
  

## Step 6: Run dada2

  

Once you have your demux file you can now run dada2. We will do this by submitting a job to the server. This way you can close your computer, go grab some food, enjoy a nice coffee etc. and let the server let you know when your job is done. Quest uses SLURM to submit jobs.

To do this you will need to save a file called `<studyname>dada2.sh`
where "studyname" is the name of your study.

  

Again we wil use vim and type `vim <studyname>dada2.sh`

Again, hit `i` and use this template to copy paste into the editor:

  

```
#!/bin/bash
#SBATCH -J dada2
#SBATCH --mail-type=ALL
#SBATCH -A p31966
#SBATCH --mail-user=samuel.degregori@northwestern.edu
#SBATCH -N 1
#SBATCH -n 6
#SBATCH --mem=24G
#SBATCH -t 48:00:00
#SBATCH -p normal
#SBATCH --output=output.log  

module purge all
module load qiime2/2022.8 

qiime dada2 denoise-paired \
--i-demultiplexed-seqs demuxStudyname.qza \
--p-trunc-len-f 150 \
--p-trunc-len-r 150 \
--p-trim-left-f 0 \
--p-trim-left-r 0 \
--p-n-threads 0 \
--o-representative-sequences rep-seqs-dadaStudyname.qza \
--o-table tableStudyname.qza \
--o-denoising-stats stats-dadaStudyname.qza

echo "Finishing dada2 job"
```

  

What you will want to change is the Studyname obviously, trim lengths if you need to, single or paired depending on your study.

For the actual job submission, **-J** is just the job name, change the email to yours, **-A** is the account which for us is **p31966**, **-N** is the node which we are only using 1 node, **-n** is the amount of cores, **-t** is the toal time we are requesting, and **-p** is the partition which is set for normal since we get up to 48 hours of CPU time for normal. The output log will contain important info if your job fails.

  

Notice how the **--p-n-thread** count is set to 0. This will actually tell the computer to use all available cores. We would not want to do this on your local machine but because we have a specified core count for this job, we actually want to use all available cores. FYI: all machines consist of processors called CPUs which have n number of cores which have n number of threads within each core.

  

Once you are done editing your dada2 sh file, hit Esc and then ":wq" and it should save. You should now see a `<studyname>dada2.sh` file in your directory.

 

You can now type

`chmod u+x <studyname>dada2.sh`

which will authorize your sh file (FYI: sh files are the extensions for bash scripts, which is what we just made)

  
**Important**: before you run the next step always make sure you are in the directory where your demux file is in! The only other option is to include the full paths in your slurm script to every file.

Now type:

  

`sbatch <studyname>dada2.sh`

To submit your job. You should now receive an email saying it submitted (this may take awhile since QUEST needs to find CPUs to open up for your job-- the more cores, time, or memory you request will increase the queue time).

  

Good job! You submitted your first job. If you get another immediate email saying job finished it is likely that your job failed. If you get a job completion email in a couple hours/days then your job will have completed. The cool thing is you can submit multiple jobs which should be much easier than always waiting for dada2 to finish. Sidenote: sometimes SLURM will email you job FAILED after a couple hours/days but really it finished and you should see the output files in your directory. If you don't then the job failed and I would try again but request 48G instead of 24G.

## Final Steps:

Before you move your files to p31966, download your 3 outputs files (demux, table, rep seqs) and upload to sharepoint, plus your metadata.

Then you can move the entire study to p31966.
First make a study folder in p31966

`mkdir /projects/p31966/<studyname>`

Now move all your study files to the new folder in p31966. Make sure you are outside the study directory in your home folder

`mv <studyname>/* /projects/p31966/<studyname>`

The code above basically will move all file contents of the study you just completed in qiime2 over to p31966
