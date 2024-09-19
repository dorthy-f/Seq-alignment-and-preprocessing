#!/bin/bash
#SBATCH --partition=day
#SBATCH --job-name=salmon
#SBATCH --ntasks=1 --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=5G
#SBATCH --time=24:00:00
#SBATCH --error=salmon.%A_%a.err
#SBATCH --output=salmon.%A_%a.out
#SBATCH --array=1-15
#SBATCH --mail-type=ALL

###########################################
# please DO NOT remove 'module load StdEnv'
###########################################
module load StdEnv
###########################################

module load Salmon/1.4.0-gompi-2020b

taskID=${SLURM_ARRAY_TASK_ID}

GENOMEDIR=/home/df555/palmer_scratch/Emily/genome

aligndir=/home/df555/palmer_scratch/Emily/Aligned/

#makes a list of all the Aligned.toTranscriptome bam files generated using STAR alignment
seqfiles1=("$aligndir"/*_Aligned.toTranscriptome.out.bam)
seqfile1=${seqfiles1[$taskID-1]}

cd $aligndir

#libType is currently set to Auto-detect, you can also change it to stranded etc. (e.g. ISR for TruSeq stranded libraries)
salmon quant -t $GENOMEDIR/GRCh38_no_alt_analysis_set_gencode.v36.transcripts.fa --libType A -a $seqfile1 -o /home/df555/palmer_scratch/Emily/quant/${SLURM_ARRAY_TASK_ID}.salmon_quant --gcBias --seqBias
