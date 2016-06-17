#!/bin/bash


#library1
libName1="${libName1}"
avg_ins1="${avg_ins1}"
delta1="${delta1}"
#reverse_seq1="${reverse_seq1}"
format1="${format1}"
readStart1="${readStart1}"
readEnd1="${readEnd1}"
reads1_1="${reads1_1}"
reads1_2="${reads1_2}"
#######################
#library2
libName2="${libName2}"
avg_ins2="${avg_ins2}"
delta2="${delta2}"
#reverse_seq2="${reverse_seq2}"
format2="${format2}"
readStart2="${readStart2}"
readEnd2="${readEnd2}"
reads2_1="${reads2_1}"
reads2_2="${reads2_2}"
#######################
#library3
libName3="${libName3}"
avg_ins3="${avg_ins3}"
delta3="${delta3}"
#reverse_seq3="${reverse_seq3}"
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
format5="${format5}"
readStart5="${readStart5}"
readEnd5="${readEnd5}"
reads5_1="${reads5_1}"
reads5_2="${reads5_2}"
###########################################################################
PHRED64="${PHRED64}"
forcePhred="${forcePhred}"
ploidy="${ploidy}"
Options1="${Options1}"
Options2="${Options2}"
Options3="${Options3}"

echo "group_name, library_name, file_name" > in_groups.csv
echo "library_name, project_name, organism_name, type, paired, frag_size, frag_stddev, insert_size, insert_stddev, read_orientation, genomic_start, genomic_end" > in_libs.csv

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
if [ "${format1}" = 'fragment' ] ;
then
echo "$libName1, de_lonestar, genome, fragment, 1, $avg_ins1, $delta1, , , inward, $readStart1, $readEnd1" >> in_libs.csv
fi
if [ "${format1}" = 'jumping' ] ;
then
echo "$libName1, de_lonestar, genome, jumping, 1, , , $avg_ins1, $delta1, outward, $readStart1, $readEnd1" >> in_libs.csv
fi

if [ "${reads2_1}" != '' ] ;
then

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
if [ "${format2}" = 'fragment' ] ;
then
echo "$libName2, de_lonestar, genome, fragment, 1, $avg_ins2, $delta2, , , inward, $readStart2, $readEnd2" >> in_libs.csv
fi
if [ "${format2}" = 'jumping' ] ;
then
echo "$libName2, de_lonestar, genome, jumping, 1, , , $avg_ins2, $delta2, outward, $readStart2, $readEnd2" >> in_libs.csv
fi
fi

if [ "${reads3_1}" != '' ] ;
then

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
if [ "${format3}" = 'fragment' ] ;
then
echo "$libName3, de_lonestar, genome, fragment, 1, $avg_ins3, $delta3, , , inward, $readStart3, $readEnd3" >> in_libs.csv
fi
if [ "${format3}" = 'jumping' ] ;
then
echo "$libName3, de_lonestar, genome, jumping, 1, , , $avg_ins3, $delta3, outward, $readStart3, $readEnd3" >> in_libs.csv
fi
fi

if [ "${reads4_1}" != '' ] ;
then

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
if [ "${format4}" = 'fragment' ] ;
then
echo "$libName4, de_lonestar, genome, fragment, 1, $avg_ins4, $delta4, , , $reverse_seq4, $readStart4, $readEnd4" >> in_libs.csv
fi
if [ "${format4}" = 'jumping' ] ;
then
echo "$libName4, de_lonestar, genome, jumping, 1, , , $avg_ins4, $delta4, $reverse_seq4, $readStart4, $readEnd4" >> in_libs.csv
fi
fi 
      
if [ "${reads5_1}" != '' ] ;
then

INPUT_F5_1=$(basename ${reads5_1})
if [ "${reads5_2}" != '' ] ;
then

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
if [ "${format5}" = 'fragment' ] ;
then
echo "$libName5, de_lonestar, genome, fragment, 1, $avg_ins5, $delta5, , , $reverse_seq5, $readStart5, $readEnd5" >> in_libs.csv
fi
if [ "${format5}" = 'jumping' ] ;
then
echo "$libName5, de_lonestar, genome, jumping, 1, , , $avg_ins5, $delta5, $reverse_seq5, $readStart5, $readEnd5" >> in_libs.csv
fi
fi
fi
if [ "${reads5_1}" != '' ];
then
if [[ "${reads5_2}" == '' ]] ;
then
echo "$libName5, $libName5, $INPUT_F5_1" >> in_groups.csv
echo "$libName5, de_lonestar, genome, fragment, 0, , , , , , $readStart5, $readEnd5" >> in_libs.csv
fi
fi


P=32
#P=16
#PHRED_64=0 FORCE_PHRED=0 
if [ "${PHRED64}" != '' ] ;
then
prepare="$prepare PHRED_64=1"
fi
if [ "${forcePhred}" != '' ] ;
then
prepare="$prepare FORCE_PHRED=1" 
fi



PrepareAllPathsInputs.pl DATA_DIR=$PWD PLOIDY=$ploidy $prepare
RunAllPathsLG PRE=$PWD REFERENCE_NAME=. DATA_SUBDIR=. RUN=allpaths SUBDIR=run THREADS=$P $Options1 $Options2 $Options3

ln -s allpaths/ASSEMBLIES/run/final.assembly.fasta genome.scf.fasta
ln -s allpaths/ASSEMBLIES/run/final.contigs.fasta  genome.ctg.fasta
