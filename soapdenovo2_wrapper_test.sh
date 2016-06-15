#!/bin/bash

#wrapper script for creating a config file or manifest for the soapdenovo assembler
#more stuff from Roger Barthelson

iget -fTr /iplant/home/rogerab/applications/soapdenovo2/bin/* 
chmod a+x ./*                                                                                    

#max_rd_len="${max_rd_len}"
max_rd_len=101
#avg_ins1="${avg_ins1}"
avg_ins1=180
#reverse_seq1="${reverse_seq1}"
reverse_seq1=0
#asm_flags1="${asm_flags1}"
asm_flags1=3
#rank1="${rank1}"
rank1=1
#format1="${format1}"
format1=q
#reads1_1="${reads1_1}"
reads1_1='/iplant/home/rogerab/test_dir/frag_1.fastq'
#reads1_2="${reads1_2}"
reads1_2='/iplant/home/rogerab/test_dir/frag_2.fastq'
#######################
#avg_ins2="${avg_ins2}"
avg_ins2=3000
#reverse_seq2="${reverse_seq2}"
reverse_seq2=0
#asm_flags2="${asm_flags2}"
asm_flags2=3
#rank2="${rank2}"
rank2=2
#format2="${format2}"
format2=q
#reads2_1="${reads2_1}"
reads2_1='/iplant/home/rogerab/test_dir/shortjump_1.fastq'
#reads2_2="${reads2_2}"
reads2_2='/iplant/home/rogerab/test_dir/shortjump_2.fastq'
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
asm_flags5=1
rank=1
format5=f
reads5_1='/iplant/home/rogerab/test_dir/frag.fa'
###########################################################################
# Output="${Output}"
# kmer="${kmer}"
# n_cpu="${n_cpu}"
Output=TestOut
kmer=39
n_cpu=6
mergeLevel="${mergeLevel}"
dkmers="${dkmers}"
dEdges="${dEdges}"
repeats="${repeats}"
gapLenDiff="${gapLenDiff}"
minLen="${minLen}"
unmask="${unmask}"
options="${mergeLevel}""${dkmers}""${dEdges}""${repeats}""${gapLenDiff}""${minLen}""${unmask}"

iget -fT "${reads1_1}"
iget -fT "${reads1_2}"
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

if [ "avg_ins2" != '' ] ;
then
iget -fT "${reads2_1}"
iget -fT "${reads2_2}"
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
iget -fT "${reads3_1}"
iget -fT "${reads3_2}"
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
iget -fT "${reads4_1}"
iget -fT "${reads4_2}"
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

if [ "${avg_ins5}" != '' ] ;
then
iget -fT "${reads5_1}"
INPUT_F5_1=$(basename ${reads5_1})
if [ "${reads5_2}" != '' ] ;
then
iget -fT "${reads5_2}"
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

# SOAPdenovo all -s configFile [-K kmer -d -D -M mergeLevel -R -u -G gapLenDiff -L minContigLen -p n_cpu] -o Output
#   -s ShortSeqFile: The input file name of solexa reads
#   -a initKmerSetSize: define the initial KmerSet size(unit: GB)
#   -K kmer(default 23): k value in kmer
#   -p n_cpu(default 8): number of cpu for use
#   -F (optional) fill gaps in scaffold
#   -M mergeLevel(default 1,min 0, max 3): the strength of merging similar sequences during contiging
#   -d (optional): delete kmers with frequency one (default no)
#   -D (optional): delete edges with coverage one (default no)
#   -R (optional): unsolve repeats by reads (default no)
#   -G gapLenDiff(default 50): allowed length difference between estimated and filled gap
#   -L minLen(default K+2): shortest contig for scaffolding
#   -u (optional): un-mask contigs with high coverage before scaffolding (default mask)
#   -o Output: prefix of output file name



SOAPdenovo-63mer all -s config_file.txt -K "${kmer}" -p "${n_cpu}" -o "${Output}" "${options}"

