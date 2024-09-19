#!/bin/bash
#SBATCH --partition=day
#SBATCH --job-name=trimnew
#SBATCH --ntasks=1 --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=5G
#SBATCH --time=24:00:00
#SBATCH --error=trim.%A_%a.err
#SBATCH --output=trim.%A_%a.out
#SBATCH --array=1-32
#SBATCH --mail-type=ALL

###########################################
# please DO NOT remove 'module load StdEnv'
###########################################
module load StdEnv
###########################################

module load Trimmomatic/0.39-Java-11 

taskID=${SLURM_ARRAY_TASK_ID}

#Specify directory of raw sequencing data and directory for trimmed files to go
seqdir=/home/df555/project/20231208-data
outdir=/home/df555/project/20231208-trimmed
 
#For PAIRED data (assumes each sample has an R1 and R2 read)
seqfiles1=("$seqdir"/.*R1*.fastq.gz)
seqfiles2=("$seqdir"/.*R2*.fastq.gz)
seqfile1=${seqfiles1[$taskID-1]} # get the i^th sequence file where i = array index
seqfile2=${seqfiles2[$taskID-1]}

cd $seqdir

echo "[$0 $(date +%Y%m%d-%H%M%S)] [start] $SLURM_JOBID $SLURM_ARRAY_TASK_ID"

#Make sure you have the trimming adapter sequences .fa file downloaded in the same folder as data
#The following code assumes paired end data (hence the two seqfiles) and trims the Nextera PE indexes - you can change the .fa file to change the trimmed indexes

java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar PE -threads 16 $seqfile1 $seqfile2 $outdir/${SLURM_ARRAY_TASK_ID}_output_forward_paired.fq.gz $outdir/${SLURM_ARRAY_TASK_ID}_output_forward_unpaired.fq.gz $outdir/${SLURM_ARRAY_TASK_ID}_output_reverse_paired.fq.gz $outdir/${SLURM_ARRAY_TASK_ID}_output_reverse_unpaired.fq.gz ILLUMINACLIP:NexteraPE-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:35

echo "[$0 $(date +%Y%m%d-%H%M%S)] [end] $SLURM_JOBID $SLURM_ARRAY_TASK_ID"