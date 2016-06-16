#!/bin/bash

#wrapper script for the velveth assembler
#more stuff from Roger Barthelson


Output="VelvetOut"
kmer="${kmer}"
strandSpecific="${strandSpecific}"
if [[ -n "${strandSpecific}" ]];
then
strandSpecific='-strand_specific'
fi
#####################################
#readtype1=-shortPaired
format1="${format1}"
reads1="${reads1}"
#######################
#readtype2=-shortPaired2
format2="${format2}"
reads2="${reads2}"
#######################
#readtype3=-longPaired
format3="${format3}"
reads3="${reads3}"
########################
#readtype4=-short
format4="${format4}"
reads4="${reads4}"
#########################
#readtype5=-long
format5="${format5}"
reads5="${reads5}"
#########################
#readtype6=-reference
#format6=-fasta
reads6="${reads6}"
###########################################################################
runthis=""${Output}" "${kmer}" "$strandSpecific""

#module load velvet/1.2.07

if [ -n "${reads1}" ] ;
then
#iget -fT "${reads1}"
INPUT_F1=$(basename ${reads1})
runthis="$runthis -shortPaired "${format1}" "${INPUT_F1}""
fi
if [ -n "${reads2}"] ;
then
#iget -fT "${reads2}"
INPUT_F2=$(basename ${reads2})
runthis="$runthis -shortPaired2 "${format2}" "${INPUT_F2}""
fi
if [ -n "${reads3}" ] ;
then
#iget -fT "${reads3}"
INPUT_F3=$(basename ${reads3})
runthis="$runthis -longPaired "${format3}" "${INPUT_F3}""
fi
if [ -n "${reads4}" ] ;
then
#iget -fT "${reads4}"
INPUT_F4=$(basename ${reads4})
runthis="$runthis -short "${format4}" "${INPUT_F4}""
fi
if [ -n "${reads5}" ] ;
then
#iget -fT "${reads5}"
INPUT_F5=$(basename ${reads5})
runthis="$runthis -long "${format5}" "${INPUT_F5}""
fi
if [ -n "${reads6}" ] ;
then
#iget -fT "${reads6}"
INPUT_F5=$(basename ${reads6})
runthis="$runthis -reference "${INPUT_F6}""
fi

export OMP_NUM_THREADS=8
echo $runthis | xargs velveth
 tar cvzf VelvetOut.tar.gz VelvetOut/*
 rm -r VelvetOut
