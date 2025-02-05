#!/bin/bash
#SBATCH --partition=day
#SBATCH --job-name=star
#SBATCH --ntasks=1 --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=5G
#SBATCH --time=24:00:00
#SBATCH --error=star.%A_%a.err
#SBATCH --output=star.%A_%a.out
#SBATCH --array=2-8
#SBATCH --mail-type=ALL

###########################################
# please DO NOT remove 'module load StdEnv'
###########################################
module load StdEnv
###########################################

module load GCC/12.2.0
module load STAR/2.7.11a-GCC-12.2.0

taskID=${SLURM_ARRAY_TASK_ID}

INDEXDIR=/home/df555/palmer_scratch/indexed2

trimdir=/home/df555/palmer_scratch/Trimmed/

seqfiles1=("$trimdir"/*_output_forward.fq.gz)
seqfile1=${seqfiles1[$taskID-1]}

cd $trimdir

STAR --runThreadN 8 --genomeDir $INDEXDIR --readFilesIn $seqfile1 --outFileNamePrefix /home/df555/palmer_scratch/Aligned/${SLURM_ARRAY_TASK_ID}_ --readFilesCommand zcat --outSAMtype BAM Unsorted --quantTranscriptomeBan Singleend --outFilterType BySJout --alignSJoverhangMin 8 --outFilterMultimapNmax 20 --alignSJDBoverhangMin 1 --outFilterMismatchNmax 999 --outFilterMismatchNoverReadLmax 0.04 --alignIntronMin 20 --alignIntronMax 1000000 --alignMatesGapMax 1000000 --quantMode TranscriptomeSAM --outSAMattributes NH HI AS NM MD