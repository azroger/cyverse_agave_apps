#!/bin/bash
#SBATCH -J bayesembler1
#SBATCH -o bayes1.out
#SBATCH -e bayes1.err
#SBATCH -t 06:00:00
#SBATCH -p normal
#SBATCH -N 1 -n 32
#SBATCH  -A iPlant-Master

module purge
module load TACC
#module load irods
#module load zlib
module load samtools


prBam1="TrmPr1_SRR566981.sra_1.fastq.bam"
prBam2="TrmPr1_SRR567164.sra_1.fastq.bam"
prBam3="TrmPr1_SRR567165.sra_1.fastq.bam"
#prBam4="TrmPr1_SRR567167.sra_1.fastq.bam"
 bamFile1=$(basename ${prBam1})
 bamFile2=$(basename ${prBam2})
 bamFile3=$(basename ${prBam3})
 bamFile4=$(basename ${prBam4})
strandSpec="${strandSpec}"
conf_thresh="${conf_thresh}"
count_thresh="${count_thresh}"
preMrna="${preMrna}"


if [ -n "${strandSpec}" ] ;
then
runthis="$runthis -s $strandSpec"
fi
if  [ -n "${conf_thresh}" ] ;
then
runthis="$runthis -c $conf_thresh"
fi
if [ -n "${count_thresh}" ] ;
then
runthis="$runthis -f $count_thresh"
fi
if [ -n "${preMrna}" ] ;
then
runthis="$runthis -m 1"
fi


if [ -e $bamFile2 ] ;
then
bfiles=$bamFile2
fi
if [ -e $bamFile3 ] ;
then
bfiles="$bfiles $bamFile3"
fi
if [ -e $bamFile4 ] ;
then
bfiles="$bfiles $bamFile4"
fi


samtools view -H -o bayheader.sam $bamFile1
if [[ -n $bfiles ]] ;
then
samtools cat -h bayheader.sam -o baybams1.bam $bamFile1 $bfiles
fi
if [[ $bfiles = '' ]] ;
then
mv $bamFile1 baybams1.bam
fi

samtools sort -o baybams2.bam  baybams1.bam

chmod a+x ./bayesembler
chmod -R a+x ./dependencies
time ./bayesembler -p 22 $runthis --output-mode full -b baybams2.bam

