These files contain sample code for QCing, trimming, aligning, and generation of salmon quant tables for downstream DESeq2 analysis.

The main drawback of most of my code is the naming of output files (usually just with task ID [e.g. 1-32]
****PLEASE CHECK AT EACH STEP WHAT THE FILE #'s CORRESPOND TO BY:
1) Looking at each output file and checking what file the code was looking at
2) Doing something similar to the below in the shell - the order of the list will correspond to the Task ID order:
files=("$seqdir"/*R1*.fastq.gz)
echo ${!files[@]}

The order of actions when receiving raw fastq.gz files from YCGA for RNA-seq analysis would be the following: 
1) FastQC of your raw fastq files (to see what adapter trimming etc. needs to be done)
2) Trimming with Trimmomatic (fastp or other similar programs can also be used)
3) FastQC again at least of a few files, to check that trimming was successful
4) Alignment using EITHER STAR or HISAT2 (sample code for both is included here - STAR parameters were specifically for RNA-seq, so possibly I would recommend that)
5) Sorting/indexing of bam files if you want to be able to look at it in IGV (STAR code has sorting in a separate file, HISAT2 code includes sorting of bam files)
6) Running of salmon script to generate salmon quant files, which can then be read into R for DESeq2 analysis using tximport.
7) Downstream R analysis of data
