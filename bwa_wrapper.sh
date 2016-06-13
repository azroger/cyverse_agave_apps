#!/bin/bash

#wrapper script for BWA-mem
#more stuff from Roger Barthelson


#module load bwa/0.7.12

stuffx=""
runthis=''
reference="${reference}"
reference_data="${reference_data}"
#reference_data=NC_010473.fa.tgz

#indx="${indx}"
#indx="ectest"
#reference="NC_010473.fa"

# kmer="${kmer}"
# basesize="${basesize}"
#
seqFolder="${seqFolder}"
#seqFolder="ecseqs"
seqmode="${seqmode}"
#seqmode="paired"
#
min_score="${min_score}"
read_type="${read_type}"
sort_type="${sort_type}"
runthis=''

###

if [ -n "${reference}" ];
then
newgenome="NEW"

# Usage:   bwa index [options] <in.fasta>

INPUT_Ref=$(basename ${reference})

bwa index "$INPUT_Ref"
directory="$INPUT_Ref"

else
INPUT_RD=$(basename ${reference_data})
refData=$(basename ${INPUT_RD} .tgz)
tar xvzf "${INPUT_RD}"
directory="${refData}"
fi

################

if [ -n "${min_score}" ]; then runthis="$runthis -T $min_score"; fi
if [ -n "${read_type}" ]; then runthis="$runthis -x ${read_type}"; fi


# Usage: bwa mem [options] <idxbase> <in1.fq> [in2.fq]

Input1=$(basename ${seqFolder});
if [ $seqmode = unpaired ];
then
echo "SE MODE!"
for x in $Input1/*
do
 bwa mem -t 8 "${directory}" $runthis "$x" > "$x"'.sam'
done
mv $Input1/*.sam ./
fi

if [ $seqmode = paired ];
then
echo "PE MODE!"
for x in $Input1/*
do
        echo "file for this iteration: $x"

        if [[ "$x" =~ .*1\.fq$ ]]; 
        then
        z=$(basename $x 1.fq)
                bwa mem -t 8 "${directory}" $runthis "$Input1"/"$z"'1.fq' "$Input1"/"$z"'2.fq' > "$z"'pe.sam'
        fi
        if [[ "$x" =~ .*1\.fa$ ]]; 
        then
        z=$(basename $x 1.fa)
                bwa mem -t 8 "${directory}" $runthis "$Input1"/"$z"'1.fa' "$Input1"/"$z"'2.fa' > "$z"'pe.sam'
        fi
        if [[ "$x" =~ .*1\.fastq$ ]]; 
        then
        z=$(basename $x 1.fastq)
                bwa mem -t 8 "${directory}" $runthis "$Input1"/"$z"'1.fastq' "$Input1"/"$z"'2.fastq' > "$z"'pe.sam'
        fi
        if [[ "$x" =~ .*1\.fasta$ ]]; 
        then
        z=$(basename $x 1.fasta)
                bwa mem -t 8 "${directory}" $runthis "$Input1"/"$z"'1.fasta' "$Input1"/"$z"'2.fasta' > "$z"'pe.sam'
        fi
done
fi
#mv $Input1/*.sam ./
#################################################################### 
mkdir 'BWA_output'
mv *.sam ./'BWA_output'
##
mkdir BWA_output_BAM
for y in BWA_output/*.sam
do
N=$(echo "$y" | sed 's/.sam//');
samtools view -bS -o "temp.bam" "$y"
samtools sort -m 2000M "temp.bam" "$N"".srtd"
rm temp.bam
done
mv BWA_output/*.bam BWA_output_BAM

#######
rm -R "$Input1"
rm -R "${directory}"
#rm temp*.bam

if [ -n "${reference}" ] ;
then
tar -czf "${directory}"'.tgz' "${directory}".*
rm "${directory}".[a,b,p,s]*
fi
######################################

rm bwa_wrapper.sh
