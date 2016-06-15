#!/bin/bash

#wrapper script for creating a config file or manifest for the soapdenovo assembler
#more stuff from Roger Barthelson
#!/bin/bash

#$ -V                    #Inherit the submission environment

#$ -cwd                  # Start job in submission directory

#$ -N soaptrans8       # Job Name

#$ -A iPlant-Collabs

#$ -j y                  # Combine stderr and stdout

#$ -o $JOB_NAME.o$JOB_ID # Name of the output file (eg. myMPI.oJobID)

#$ -pe 24way 24          # Requests 12 tasks/node, 24 cores total (16 now)

#$ -q largemem                  # Queue name "normal" 

#$ -l h_rt=12:00:00      # Run time (hh:mm:ss) - 1.5 hours (8 hrs now)

#$ -M rogerab@email.arizona.edu                   # Use email notification address

#$ -m be                 # Email at Begin and End of job

set -x                   # Echo commands, use "set echo" with csh

#iget -fTr /iplant/home/rogerab/applications/soapdenovo2/bin/* 
#chmod a+x ./*                                                                                    
source ~/.profile_user

#max_rd_len="${max_rd_len}"
max_rd_len=78
#avg_ins1="${avg_ins1}"
avg_ins1=300
#reverse_seq1="${reverse_seq1}"
reverse_seq1=0
#asm_flags1="${asm_flags1}"
asm_flags1=3
#rank1="${rank1}"
rank1=1
#format1="${format1}"
format1=q
#reads1_1="${reads1_1}"
reads1_1='/iplant/home/rogerab/testfiles/Error_correct_test.paired.A.fastq'
#reads1_2="${reads1_2}"
reads1_2='/iplant/home/rogerab/testfiles/Error_correct_test.paired.B.fastq'
#######################
avg_ins2="${avg_ins2}"
#avg_ins2=3000
reverse_seq2="${reverse_seq2}"
#reverse_seq2=0
asm_flags2="${asm_flags2}"
#asm_flags2=3
rank2="${rank2}"
#rank2=2
format2="${format2}"
#format2=q
reads2_1="${reads2_1}"
#reads2_1='/iplant/home/rogerab/test_dir/shortjump_1.fastq'
reads2_2="${reads2_2}"
#reads2_2='/iplant/home/rogerab/test_dir/shortjump_2.fastq'
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
format5=q
#reads5_1="${reads5_1}"
reads5_2="${reads5_2}"
#asm_flags5="1"
#rank5="${rank5}"
#format5=f
reads5_1='/iplant/home/rogerab/testfiles/Error_correct_test.unpaired.fastq'
###########################################################################
# Output="${Output}"
# kmer="${kmer}"
# n_cpu="${n_cpu}"
Output=BAkmerNrm_soap
kmer=25
n_cpu=24
kRange=''
mergeLevel="-M 2"
dkmers="${dkmers}"
dEdges="${dEdges}"
repeats="${repeats}"
gapLenDiff="${gapLenDiff}"
minLen="${minLen}"
unmask="${unmask}"
options="${mergeLevel}""${dkmers}""${dEdges}""${repeats}""${gapLenDiff}""${minLen}""${unmask}"

iget -f "${reads1_1}"
iget -f "${reads1_2}"
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

if [ -r "avg_ins2" ] ;
then
iget -f "${reads2_1}"
iget -f "${reads2_2}"
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

if [ "${reads5_1}" != '' ] ;
then
iget -f "${reads5_1}"
INPUT_F5_1=$(basename ${reads5_1})
if [ "${reads5_2}" != '' ] ;
then
iget -f "${reads5_2}"
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
echo "${format5}""="${INPUT_F5_1} >> config_file.txt
fi
fi

if [ "${kRange}" != '' ] ;
then
soap="SOAPdenovo-Trans-127mer all -s config_file.txt -K $kmer -p 24 -o $Output $options"
else
soap="SOAPdenovo-Trans-31mer all -s config_file.txt -K $kmer -p 24 -o $Output $options"
fi

#./SOAPdenovo-127mer all -s config_file.txt -K "${kmer}" -p 12 -o "${Output}" "${options}"

$soap
