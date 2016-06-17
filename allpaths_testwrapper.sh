#!/bin/bash

#wrapper script for creating a config file or manifest for the allpathslg assembler
#more stuff from Roger Barthelson
#SBATCH -J allpathstest1              # Job name
#SBATCH -o myjob.%j.out       # Name of stdout output file (%j expands to jobId)
#SBATCH -p development        # Queue name
#SBATCH -N 1                  # Total number of nodes requested (16 cores/node)
#SBATCH -n 16                # Total number of mpi tasks requested
#SBATCH -t 01:00:00           # Run time (hh:mm:ss) - 1.5 hours

module load irods
#module load jdk32
module load picard
module load allpathslg

ulimit -s 100000000

#library1
#libName1="${libName1}"
libName1="fraggie"
#avg_ins1="${avg_ins1}"
avg_ins1="180"
#delta1="${delta1}"
delta1="80"
#reverse_seq1="${reverse_seq1}"
reverse_seq1="inward"
#format1="${format1}"
format1="Fragment"
#readStart1="${readStart1}"
#readEnd1="${readEnd1}"
readStart1="0"
readEnd1="0"
#reads1_1="${reads1_1}"
reads1_1="/iplant/home/shared/iplantcollaborative/example_data/allpaths/rhodo/frag_1.fastq"
#reads1_2="${reads1_2}"
reads1_2="/iplant/home/shared/iplantcollaborative/example_data/allpaths/rhodo/frag_2.fastq"
#######################
#library2
#libName2="${libName2}"
libName2="jumpy"
#avg_ins2="${avg_ins2}"
#delta2="${delta2}"
avg_ins2="3000"
delta2="500"
#reverse_seq2="${reverse_seq2}"
reverse_seq2="outward"
#format2="${format2}"
format2="Jumping"
#readStart2="${readStart2}"
#readEnd2="${readEnd2}"
readStart2="0"
readEnd2="0"
#reads2_1="${reads2_1}"
reads2_1="/iplant/home/shared/iplantcollaborative/example_data/allpaths/rhodo/shortjump_1.fastq"
#reads2_2="${reads2_2}"
reads2_2="/iplant/home/shared/iplantcollaborative/example_data/allpaths/rhodo/shortjump_2.fastq"
#######################
#library3
libName3="${libName3}"
avg_ins3="${avg_ins3}"
delta3="${delta3}"
reverse_seq3="${reverse_seq3}"
#asm_flags3="${asm_flags3}"
#rank3="${rank3}"
format3="${format3}"
readStart3="${readStart3}"
readEnd3="${readEnd3}"
reads3_1="${reads3_1}"
reads3_2="${reads3_2}"
########################
#library4
libName4="${libName4}"
avg_ins4="${avg_ins4}"
delta4="${delta4}"
reverse_seq4="${reverse_seq4}"
#asm_flags4="${asm_flags4}"
#rank4="${rank4}"
format4="${format4}"
readStart4="${readStart4}"
readEnd4="${readEnd4}"
reads4_1="${reads4_1}"
reads4_2="${reads4_2}"
#########################
#library5
libName5="${libName5}"
avg_ins5="${avg_ins5}"
delta5="${delta5}"
reverse_seq5="${reverse_seq5}"
#asm_flags5="${asm_flags5}"
#rank5="${rank5}"
format5="${format5}"
readStart5="${readStart5}"
readEnd5="${readEnd5}"
reads5_1="${reads5_1}"
reads5_2="${reads5_2}"
###########################################################################
#Options1="${Options1}"
Options1="OVERWRITE=TRUE"
Options2="${Options2}"
Options3="${Options3}"

echo "group_name, library_name, file_name" > in_groups.csv
echo "library_name, project_name, organism_name, type, paired, frag_size, frag_stddev, insert_size, insert_stddev, read_orientation, genomic_start, genomic_end" > in_libs.csv

iget -fT "${reads1_1}"
iget -fT "${reads1_2}"
INPUT_F1_1=$(basename ${reads1_1})
        if [[ "$INPUT_F1_1" =~ .*1\.f[aq].* ]]; 
        then
        Inputs1=${INPUT_F1_1/1\.f/?.f};
        else
        if [[ "$INPUT_F1_1" =~ .*\.bam ]];
        then
        Inputs1="$INPUT_F1_1"
        fi
        fi
echo "$libName1, $libName1, $Inputs1" >> in_groups.csv
if [ "${format1}" = 'Fragment' ] ;
then
echo "$libName1, de_stampede, genome, fragment, 1, $avg_ins1, $delta1, , , $reverse_seq1, $readStart1, $readEnd1" >> in_libs.csv
fi
if [ "${format1}" = 'Jumping' ] ;
then
echo "$libName1, de_stampede, genome, jumping, 1, , , $avg_ins1, $delta1, $reverse_seq1, $readStart1, $readEnd1" >> in_libs.csv
fi

if [ "${libName2}" != '' ] ;
then
iget -fT "${reads2_1}"
iget -fT "${reads2_2}"
INPUT_F2_1=$(basename ${reads2_1})
        if [[ "$INPUT_F2_1" =~ .*1\.f[aq].* ]]; 
        then
        Inputs2=${INPUT_F2_1/1\.f/?.f};
        else
        if [[ "$INPUT_F2_1" =~ .*\.bam ]];
        then
        Inputs2="$INPUT_F2_1"
        fi
        fi
echo "$libName2, $libName2, $Inputs2" >> in_groups.csv
if [ "${format2}" = 'Fragment' ] ;
then
echo "$libName2, de_stampede, genome, fragment, 1, $avg_ins2, $delta2, , , $reverse_seq2, $readStart2, $readEnd2" >> in_libs.csv
fi
if [ "${format2}" = 'Jumping' ] ;
then
echo "$libName2, de_stampede, genome, jumping, 1, , , $avg_ins2, $delta2, $reverse_seq2, $readStart2, $readEnd2" >> in_libs.csv
fi
fi

if [ "${libName3}" != '' ] ;
then
iget -fT "${reads3_1}"
iget -fT "${reads3_2}"
INPUT_F3_1=$(basename ${reads3_1})
        if [[ "$INPUT_F3_1" =~ .*1\.f[aq].* ]]; 
        then
        Inputs3=${INPUT_F3_1/1\.f/?.f};
        else
        if [[ "$INPUT_F3_1" =~ .*\.bam ]];
        then
        Inputs3="$INPUT_F3_1"
        fi
        fi
echo "$libName3, $libName3, $Inputs3" >> in_groups.csv
if [ "${format3}" = 'Fragment' ] ;
then
echo "$libName3, de_stampede, genome, fragment, 1, $avg_ins3, $delta3, , , $reverse_seq3, $readStart3, $readEnd3" >> in_libs.csv
fi
if [ "${format3}" = 'Jumping' ] ;
then
echo "$libName3, de_stampede, genome, jumping, 1, , , $avg_ins3, $delta3, $reverse_seq3, $readStart3, $readEnd3" >> in_libs.csv
fi
fi

if [ "${libName4}" != '' ] ;
then
iget -fT "${reads4_1}"
iget -fT "${reads4_2}"
INPUT_F4_1=$(basename ${reads4_1})
        if [[ "$INPUT_F4_1" =~ .*1\.f[aq].* ]]; 
        then
        Inputs4=${INPUT_F4_1/1\.f/?.f};
        else
        if [[ "$INPUT_F4_1" =~ .*\.bam ]];
        then
        Inputs4="$INPUT_F4_1"
        fi
        fi
echo "$libName4, $libName4, $Inputs4" >> in_groups.csv        
if [ "${format4}" = 'Fragment' ] ;
then
echo "$libName4, de_stampede, genome, fragment, 1, $avg_ins4, $delta4, , , $reverse_seq4, $readStart4, $readEnd4" >> in_libs.csv
fi
if [ "${format4}" = 'Jumping' ] ;
then
echo "$libName4, de_stampede, genome, jumping, 1, , , $avg_ins4, $delta4, $reverse_seq4, $readStart4, $readEnd4" >> in_libs.csv
fi
fi 
      
if [ "${libName5}" != '' ] ;
then
iget -fT "${reads5_1}"
INPUT_F5_1=$(basename ${reads5_1})
if [ "${reads5_2}" != '' ] ;
then
iget -fT "${reads5_2}"
        if [[ "$INPUT_F5_1" =~ .*1\.f[aq].* ]]; 
        then
        Inputs5=${INPUT_F5_1/1\.f/?.f};
        else
        if [[ "$INPUT_F5_1" =~ .*\.bam ]];
        then
        Inputs5="$INPUT_F5_1"
        fi
        fi
echo "$libName5, $libName5, $Inputs5" >> in_groups.csv
if [ "${format5}" = 'Fragment' ] ;
then
echo "$libName5, de_stampede, genome, fragment, 1, $avg_ins5, $delta5, , , $reverse_seq5, $readStart5, $readEnd5" >> in_libs.csv
fi
if [ "${format5}" = 'Jumping' ] ;
then
echo "$libName5, de_stampede, genome, jumping, 1, , , $avg_ins5, $delta5, $reverse_seq5, $readStart5, $readEnd5" >> in_libs.csv
fi
fi
fi
if [ "${libName5}" != '' ];
then
if [ "${reads5_2}" = '' ] ;
then
echo "$libName5, $libName5, $INPUT_F5_1" >> in_groups.csv
echo "$libName5, de_stampede, genome, fragment, 0, , , , , , $readStart5, $readEnd5" >> in_libs.csv
fi
fi


#P=32
P=16


PrepareAllPathsInputs.pl DATA_DIR=$PWD PLOIDY=1
RunAllPathsLG PRE=$PWD REFERENCE_NAME=. DATA_SUBDIR=. RUN=allpaths SUBDIR=run THREADS=$P $Options1 $Options2 $Options3

ln -s allpaths/ASSEMBLIES/run/final.assembly.fasta genome.scf.fasta
ln -s allpaths/ASSEMBLIES/run/final.contigs.fasta  genome.ctg.fasta
