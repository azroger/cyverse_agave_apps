#!/bin/bash
#SPAdes wrapper script Roger Barthelson 2015

tar xvzf spades.tgz

read_type1="${read_type1}"
#read_type1="paired"
format1="${format1}"
#format1="pe"
reads1_1="${reads1_1}"
#reads1_1="frag_1.fastq"
reads1_2="${reads1_2}"
#reads1_2="frag_2.fastq"
single1="${single1}"
#######################
read_type2="${read_type2}"
#read_type2="paired"
format2="${format2}"
#format2="mp"
reads2_1="${reads2_1}"
#reads2_1="shortjump_1.fastq"
reads2_2="${reads2_2}"
#reads2_2="shortjump_2.fastq"
single2="${single2}"
#######################
read_type3="${read_type3}"
format3="${format3}"
reads3_1="${reads3_1}"
reads3_2="${reads3_2}"
single3="${single3}"
########################
read_type4="${read_type4}"
format4="${format4}"
single4="${single4}"
#########################
read_type5="${read_type5}"
format5="${format5}"
single5="${single5}"
###########################################################################
sanger_file="${sanger_file}"
#########################
pacbio_file="${pacbio_file}"
#########################
nanopore_file="${nanopore_file}"
###########################################################################
Output="SPADES_Out"
kmer="${kmer}"
#kmer="35"
meta="${meta}"
iontorrent="${iontorrent}"
single_cell="${single_cell}"
cov_cutoff="${cov_cutoff}"
phred="${phred}"
Stuff=''
Options=''
Pr=''

if [ "${read_type1}" = 'single' ] ;
then
if [[ -r $single1 ]];
then
Stuff="--s1 $single1"
fi
fi
if [[ -n "${format1}" ]] ;
then
Prfa="${format1}"
fi
if [[ -r $reads1_1 ]];
then
if [ "${read_type1}" = 'paired' ] ;
then
Stuff="$Stuff --${Prfa}1-1 $reads1_1 --${Prfa}1-2 $reads1_2"
fi
if [ "${read_type1}" = 'paired-plus' ] ;
then
Stuff="$Stuff --${Prfa}1-1 $reads1_1 --${Prfa}1-2 $reads1_2 --${Prfa}1-s $single1"
fi
fi
###########################################################################
if [ "${read_type2}" = 'single' ] ;
then
if [[ -r $single2 ]];
then
Stuff="$Stuff --s2 $single2"
fi
fi
if [[ -n $format2 ]] ;
then
Prfb="${format2}"
fi
if [[ -r $reads2_1 ]];
then
if [ "${read_type2}" = 'paired' ] ;
then
Stuff="$Stuff --${Prfb}2-1 $reads2_1 --${Prfb}2-2 $reads2_2"
fi
if [ "${read_type2}" = 'paired-plus' ] ;
then
Stuff="$Stuff --${Prfb}2-1 $reads2_1 --${Prfb}2-2 $reads2_2 --${Prfb}2-s $single2"
fi
fi
###########################################################################
if [ "${read_type3}" = 'single' ] ;
then
if [[ -r $single3 ]];
then
Stuff="$Stuff --s3 $single3"
fi
fi
if [[ -n $format3 ]] ;
then
Prfc="$format3"
fi
if [[ -r $reads3_1 ]];
then
if [ "${read_type3}" = 'paired' ] ;
then
Stuff="$Stuff --${Prfc}3-1 $reads3_1 --${Prfc}3-2 $reads3_2"
fi
if [ "${read_type3}" = 'paired-plus' ] ;
then
Stuff="$Stuff --${Prfc}3-1 $reads3_1 --${Prfc}3-2 $reads3_2 --${Prfc}3-s $single3"
fi
fi
###########################################################################
if [ "${read_type4}" = 'single' ] ;
then
if [[ -r $single4 ]];
then
Stuff="$Stuff --s4 $single4"
fi
fi
if [[ -n $format4 ]] ;
then
Prfd="$format4"
fi
if [ "${read_type4}" = 'paired' ] ;
then
if [[ -r $reads4_1 ]];
then
Stuff="$Stuff --${Prfd}4-1 $reads4_1 --${Prfd}4-2 $reads4_2"
fi
if [ "${read_type4}" = 'paired-plus' ] ;
then
Stuff="$Stuff --${Prfd}4-1 $reads4_1 --${Prfd}4-2 $reads4_2 --${Prfd}4-s $single4"
fi
fi
###########################################################################
if [ "${read_type5}" = 'single' ] ;
then
if [[ -r $single5 ]];
then
Stuff="$Stuff --s5 $single5"
fi
fi
if [[ -n $format5 ]] ;
then
Prfe="$format5"
fi
if [[ -r $reads5_1 ]];
then
if [ "${read_type5}" = 'paired' ] ;
then
Stuff="$Stuff --${Prfe}5-1 $reads5_1 --${Prfe}5-2 $reads5_2"
fi
if [ "${read_type5}" = 'paired-plus' ] ;
then
Stuff="$Stuff --${Prfe}5-1 $reads5_1 --${Prfe}5-2 $reads5_2 --${Prfe}5-s $single5"
fi
fi
###########################################################################
if [[ $sanger_file != '' ]];
then
Stuff="$Stuff --sanger $sanger_file"
fi
###########################################################################
if [[ $pacbio_file != '' ]];
then
Stuff="$Stuff --pacbio $pacbio_file"
fi
###########################################################################
if [[ $nanopore_file != '' ]];
then
Stuff="$Stuff --nanopore $nanopore_file"
fi
###########################################################################
if [[ $meta != '' ]];
then
Options="$Options --meta";
fi
if [[ $iontorrent != '' ]];
then
Options="$Options --iontorrent"
fi
if [[ $single_cell != '' ]];
then
Options="$Options --sc"
fi
if [[ -n $cov_cutoff ]];
then
Options="$Options --cov-cutoff $cov_cutoff"
fi
if [[ $phred != '' ]];
then
Options="$Options --phred-offset $phred"
fi
echo "$Stuff"
echo "$Options"
#bin/spades.py -o Spades_Output $Stuff -k $kmer $Options -m 8
bin/spades.py -o Spades_Output $Stuff -k $kmer $Options -m 990

rm -r bin
rm -r share
if [[ -n *.fastq ]]; then rm *.fastq; fi
if [[ -n *.fq ]]; then rm *.fq; fi
