#!/bin/bash

#wrapper script for creating a config file or manifest for the soapdenovo assembler
#more stuff from Roger Barthelson

chmod a+x ./SOAPdenovo-Trans*

max_rd_len="${max_rd_len}"
avg_ins1="${avg_ins1}"
reverse_seq1="${reverse_seq1}"
asm_flags1="${asm_flags1}"
rank1="${rank1}"
format1="${format1}"
reads1_1="${reads1_1}"
reads1_2="${reads1_2}"
#######################
avg_ins2="${avg_ins2}"
reverse_seq2="${reverse_seq2}"
asm_flags2="${asm_flags2}"
rank2="${rank2}"
format2="${format2}"
reads2_1="${reads2_1}"
reads2_2="${reads2_2}"
#######################
avg_ins3="${avg_ins3}"
reverse_seq3="${reverse_seq3}"
asm_flags3="${asm_flags3}"
rank3="${rank3}"
format3="${format3}"
reads3_1="${reads3_1}"
reads3_2="${reads3_2}"
########################
avg_ins4="${avg_ins4}"
reverse_seq4="${reverse_seq4}"
asm_flags4="${asm_flags4}"
rank4="${rank4}"
format4="${format4}"
reads4_1="${reads4_1}"
reads4_2="${reads4_2}"
#########################
avg_ins5="${avg_ins5}"
reverse_seq5="${reverse_seq5}"
asm_flags5="${asm_flags5}"
rank5="${rank5}"
format5="${format5}"
reads5_1="${reads5_1}"
reads5_2="${reads5_2}"
###########################################################################
Output="SoapTransOut"
kmer="${kmer}"
n_cpu=24
kRange="${kRange}"
mergeLevel="${mergeLevel}"
dkmers="${dkmers}"
dEdges="${dEdges}"
fillGaps="${fillGaps}"
locusMax="${locusMax}"
if [ -n "${fillGaps}" ] ;
then 
fillGaps="-F"
fi
if [ -n "${dkmers}" ] ;
then 
dkmers="-d ${dkmers}"
fi
if [ -n "${dEdges}" ] ;
then 
dEdges="-D ${dEdges}"
fi

if [ -n "${locusMax}" ] ;
then 
locusMax="-t ${locusMax}"
fi
minLen="${minLen}"
if [ -n "${minLen}" ] ;
then 
minLen="-L ${minLen}"
fi
if [ -n "${mergeLevel}" ] ;
then 
mergeLevel="-M ${mergeLevel}"
fi
options="$mergeLevel""$dkmers""$dEdges""$fillGaps""$locusMax""$minLen"

if [[ -n "avg_ins1" ]] ;
then
# iget -fT "${reads1_1}"
# iget -fT "${reads1_2}"
INPUT_F1_1=$(basename ${reads1_1})
INPUT_F1_2=$(basename ${reads1_2})


echo max_rd_len="${max_rd_len}" > config_file.txt
echo "[LIB]" >> config_file.txt
echo avg_ins="${avg_ins1}" >> config_file.txt
echo reverse_seq="${reverse_seq1}" >> config_file.txt
echo asm_flags="${asm_flags1}" >> config_file.txt
echo rank="${rank1}" >> config_file.txt
echo "${format1}"1"="${INPUT_F1_1} >> config_file.txt
echo "${format1}"2"="${INPUT_F1_2} >> config_file.txt

fi

if [[ -n "avg_ins2" ]] ;
then
# iget -fT "${reads2_1}"
# iget -fT "${reads2_2}"
INPUT_F2_1=$(basename ${reads2_1})
INPUT_F2_2=$(basename ${reads2_2})
echo "[LIB]" >> config_file.txt  
echo avg_ins="${avg_ins2}" >> config_file.txt
echo reverse_seq="${reverse_seq2}" >> config_file.txt
echo asm_flags="${asm_flags2}" >> config_file.txt
echo rank="${rank2}" >> config_file.txt
echo "${format2}"1"="${INPUT_F2_1} >> config_file.txt
echo "${format2}"2"="${INPUT_F2_2} >> config_file.txt
fi

if [[ -n "${reads5_1}" ]] ;
then
# iget -fT "${reads5_1}"
INPUT_F5_1=$(basename ${reads5_1})
# if [ "${reads5_2}" != '' ] ;
# then
# # iget -fT "${reads5_2}"
# INPUT_F5_2=$(basename ${reads5_2})
# echo "[LIB]" >> config_file.txt
# echo avg_ins="${avg_ins5}" >> config_file.txt
# echo reverse_seq="${reverse_seq5}" >> config_file.txt
# echo asm_flags="${asm_flags5}" >> config_file.txt
# echo rank="${rank5}" >> config_file.txt
# echo "${format5}"1"="${INPUT_F5_1} >> config_file.txt
# echo "${format5}"2"="${INPUT_F5_2} >> config_file.txt
# else
echo "[LIB]" >> config_file.txt
echo asm_flags=1 >> config_file.txt
echo "${format5}""="${INPUT_F5_1} >> config_file.txt
#fi
fi

if [[ "${kRange}" == '127' ]] ;
then
soap="./SOAPdenovo-Trans-127mer all -s config_file.txt -K $kmer -p 24 -o $Output $options"
else
soap="./SOAPdenovo-Trans-31kmer all -s config_file.txt -K $kmer -p 24 -o $Output $options"
fi

$soap

rm *.fq
rm *.fastq
