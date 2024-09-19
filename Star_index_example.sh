#!/bin/bash
#SBATCH --partition=day
#SBATCH --job-name=star
#SBATCH --ntasks=1 --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=5G
#SBATCH --time=3:00:00
#SBATCH --error=star.%A_%a.err
#SBATCH --output=star.%A_%a.out
#SBATCH --mail-type=ALL

###########################################
# please DO NOT remove 'module load StdEnv'
###########################################
module load StdEnv
###########################################

#uncomment the below if you need to get the genome file still - you only need to do this once!
#cd /home/df555/palmer_scratch/Emily/genome/
#wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/seqs_for_alignment_pipelines.ucsc_ids/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz
#wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_36/gencode.v36.annotation.gtf.gz
#gunzip GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz
#gunzip gencode.v36.annotation.gtf.gz

module load GCC/12.2.0
module load STAR/2.7.11a-GCC-12.2.0

#specify where the genome is located and where to store index files
GENOMEDIR=/home/df555/palmer_scratch/Emily/genome
INDEXDIR=/home/df555/palmer_scratch/Emily/indexed

STAR --runThreadN 4 --runMode genomeGenerate --genomeDir $INDEXDIR --genomeFastaFiles $GENOMEDIR/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna --sjdbGTFfile $GENOMEDIR/gencode.v36.annotation.gtf --sjdbOverhang 99
