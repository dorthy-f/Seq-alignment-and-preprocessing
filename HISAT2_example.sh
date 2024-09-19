#!/bin/bash
#SBATCH --partition=day
#SBATCH --job-name=hisat3
#SBATCH --ntasks=1 --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=5G
#SBATCH --time=24:00:00
#SBATCH --error=hisat.%A_%a.err
#SBATCH --output=hisat.%A_%a.out
#SBATCH --array=1-32
#SBATCH --mail-type=ALL

###########################################
# please DO NOT remove 'module load StdEnv'
###########################################
module load StdEnv
###########################################

module load HISAT2/2.2.1-gompi-2020b
module load R-bundle-Bioconductor/3.15-foss-2020b-R-4.2.0
module load BEDTools/2.30.0-GCCcore-10.2.0
module load SAMtools/1.16.1-GCCcore-10.2.0

taskID=${SLURM_ARRAY_TASK_ID}

#specify location of pre-trimmed fastq files
trimdir=/home/df555/project/20231208-trimmed/

#Assumes you have paired end data
seqfiles1=("$trimdir"/*_output_forward_paired.fq.gz)
seqfiles2=("$trimdir"/*_output_reverse_paired.fq.gz)
seqfile1=${seqfiles1[$taskID-1]}
seqfile2=${seqfiles2[$taskID-1]}

cd $trimdir

#Aligns and then also sorts/indexes your bam files

hisat2 -x /home/df555/project/index/grch38_snp_tran/genome_snp_tran -1 $seqfile1 -2 $seqfile2 -p 16 | samtools sort -@ 7 -o sorted${SLURM_ARRAY_TASK_ID}.bam 

samtools index sorted${SLURM_ARRAY_TASK_ID}.bam