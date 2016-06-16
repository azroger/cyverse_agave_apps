#!/bin/bash

#wrapper script for the velveth assembler
#more stuff from Roger Barthelson

stuffx=''
junk1=''
junk2=''
junk3=''
junk4=''
junk5=''
junk6=''
runthis=''

# Output="${Output}"
# kmer="${kmer}"
Output=TestOut
kmer=39
strandSpecific="${strandSpecific}"
#####################################
readtype1=-shortPaired
#format1="${format1}"
format1=-fastq
#reads1="${reads1}"
reads1='/iplant/home/rogerab/test_dir/frag_pr.fastq'
#######################
readtype2=-shortPaired2
#format2="${format2}"
format2=-fastq
#reads2="${reads2}"
reads2='/iplant/home/rogerab/test_dir/shortjump_pr.fastq'
#######################
readtype3=-longPaired
format3="${format3}"
reads3="${reads3}"
########################
readtype4=-short
#format4="${format4}"
format4=-fasta
#reads4="${reads5}"
reads4='/iplant/home/rogerab/test_dir/frag.fa'
#########################
readtype5=-long
format5="${format5}"
reads5="${reads5}"
#########################
readtype6=-reference
format6=-fasta
reads6="${reads6}"
###########################################################################
stuffx=""${Output}" "${kmer}" "${strandSpecific}""

module purge
module load TACC
module load irods
module load velvet/1.2.08

if [ "${reads1}" != '' ] ;
then
iget -fT "${reads1}"
INPUT_F1=$(basename ${reads1})
junk1=" -shortPaired "${format1}" "${INPUT_F1}""
fi
if [ "${reads2}" != '' ] ;
then
iget -fT "${reads2}"
INPUT_F2=$(basename ${reads2})
junk2=" -shortPaired2 "${format2}" "${INPUT_F2}""
fi
if [ "${reads3}" != '' ] ;
then
iget -fT "${reads3}"
INPUT_F3=$(basename ${reads3})
junk3=" -longPaired "${format3}" "${INPUT_F3}""
fi
if [ "${reads4}" != '' ] ;
then
iget -fT "${reads4}"
INPUT_F4=$(basename ${reads4})
junk4=" -short "${format4}" "${INPUT_F4}""
fi
if [ "${reads5}" != '' ] ;
then
iget -fT "${reads5}"
INPUT_F5=$(basename ${reads5})
junk5=" -long "${format5}" "${INPUT_F5}""
fi
if [ "${reads6}" != '' ] ;
then
iget -fT "${reads6}"
INPUT_F5=$(basename ${reads6})
junk6=" -reference "${INPUT_F6}""
fi

runthis="${stuffx}""${junk6}""${junk1}""${junk2}""${junk3}""${junk4}""${junk5}"

export OMP_NUM_THREADS=6
echo $runthis | xargs velveth
