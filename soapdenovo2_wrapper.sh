#!/bin/bash

#wrapper script for creating a config file or manifest for the soapdenovo assembler
#more stuff from Roger Barthelson


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
Output="SoapdenovoOut"
kmer="${kmer}"
n_cpu="24"
mergeLevel="${mergeLevel}"
dkmers="${dkmers}"
dEdges="${dEdges}"
repeats="${repeats}"
gapLenDiff="${gapLenDiff}"
minLen="${minLen}"
unmask="${unmask}"
options=''
if [ -n "${dkmers}" ]; then options="$options '-d' ${dkmers}"; fi
if [ -n "${mergeLevel}" ]; then options="$options '-M' ${mergeLevel}"; fi
if [ -n "${dEdges}" ]; then options="$options '-D' ${dEdges}"; fi
if [ -n "${repeats}" ]; then options="$options '-R'"; fi
if [ -n "${gapLenDiff}" ]; then options="$options '-G' ${gapLenDiff}"; fi
if [ -n "${minLen}" ]; then options="$options '-L' ${minLen}"; fi
if [ -n "${unmask}" ]; then options="$options '-u'"; fi

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

if [ "${avg_ins2}" != '' ] ;
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

if [ "${avg_ins3}" != '' ] ;
then
# iget -fT "${reads3_1}"
# iget -fT "${reads3_2}"
INPUT_F3_1=$(basename ${reads3_1})
INPUT_F3_2=$(basename ${reads3_2})
echo "[LIB]" >> config_file.txt
echo avg_ins="${avg_ins3}" >> config_file.txt
echo reverse_seq="${reverse_seq3}" >> config_file.txt
echo asm_flags="${asm_flags3}" >> config_file.txt
echo rank="${rank3}" >> config_file.txt
echo "${format3}"1"="${INPUT_F3_1} >> config_file.txt
echo "${format3}"2"="${INPUT_F3_2} >> config_file.txt
fi

if [ "${avg_ins4}" != '' ] ;
then
# iget -fT "${reads4_1}"
# iget -fT "${reads4_2}"
INPUT_F4_1=$(basename ${reads4_1})
INPUT_F4_2=$(basename ${reads4_2})
echo "[LIB]" >> config_file.txt
echo avg_ins="${avg_ins4}" >> config_file.txt
echo reverse_seq="${reverse_seq4}" >> config_file.txt
echo asm_flags="${asm_flags4}" >> config_file.txt
echo rank="${rank4}" >> config_file.txt
echo "${format4}"1"="${INPUT_F4_1} >> config_file.txt
echo "${format4}"2"="${INPUT_F4_2} >> config_file.txt
fi

if [ "${reads5_1}" != '' ] ;
then
#iget -fT "${reads5_1}"
INPUT_F5_1=$(basename ${reads5_1})
if [ "${reads5_2}" != '' ] ;
then
#iget -fT "${reads5_2}"
INPUT_F5_2=$(basename ${reads5_2})
echo "[LIB]" >> config_file.txt
echo avg_ins="${avg_ins5}" >> config_file.txt
echo reverse_seq="${reverse_seq5}" >> config_file.txt
echo asm_flags="${asm_flags5}" >> config_file.txt
echo rank="${rank5}" >> config_file.txt
echo "${format5}"1"="${INPUT_F5_1} >> config_file.txt
echo "${format5}"2"="${INPUT_F5_2} >> config_file.txt
else
echo "[LIB]" >> config_file.txt
echo asm_flags=1 >> config_file.txt
echo rank="${rank5}" >> config_file.txt
echo "${format5}""="${INPUT_F5_1} >> config_file.txt
fi
fi


if [ "${kRange}" == 63 ] ;
then
soap="SOAPdenovo-63mer all -s config_file.txt -K $kmer -p $n_cpu -o $Output $options"
else
soap="SOAPdenovo-127mer all -s config_file.txt -K $kmer -p $n_cpu -o $Output $options"
fi


$soap


	if [[ -r "${*.fastq}" ]];
	then
	rm *.fastq
	fi

     	if [[ -r "${*.fq}" ]];
        then
	rm *.fq
        fi
