#!/bin/bash
#SBATCH --partition=day
#SBATCH --job-name=trimming
#SBATCH --ntasks=1 --nodes=1
#SBATCH --cpus-per-task=7
#SBATCH --mem-per-cpu=5G
#SBATCH --time=24:00:00
#SBATCH --error=trim.%A_%a.err
#SBATCH --output=trim.%A_%a.out
#SBATCH --array=1-8
#SBATCH --mail-type=ALL

###########################################
# please DO NOT remove 'module load StdEnv'
###########################################
module load StdEnv
###########################################

module load Trimmomatic/0.39-Java-11 

taskID=${SLURM_ARRAY_TASK_ID}

seqdir=/home/df555/palmer_scratch/FASTQ_split
outdir=/home/df555/palmer_scratch/Trimmed

seqfiles1=("$seqdir"/*_R1.fastq.gz)
seqfile1=${seqfiles1[$taskID-1]} # get the i^th sequence file where i = array index

cd $seqdir

echo "[$0 $(date +%Y%m%d-%H%M%S)] [start] $SLURM_JOBID $SLURM_ARRAY_TASK_ID"

#make sure you have the trimming adapter sequences .fa file downloaded in the same folder as data

java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar SE -threads 7 $seqfile1  $outdir/${SLURM_ARRAY_TASK_ID}_output_forward.fq.gz ILLUMINACLIP:TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:35



echo "[$0 $(date +%Y%m%d-%H%M%S)] [end] $SLURM_JOBID $SLURM_ARRAY_TASK_ID"




