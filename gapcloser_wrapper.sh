#!/bin/bash

#wrapper script for creating a config file or manifest for the soapdenovo assembler's gapcloser
#more stuff from Roger Barthelson


#iget /iplant/home/rogerab/applications/soapdenovo2a/bin/GapCloser
chmod a+x ./GapCloser

inputDirectory="${inputDirectory}"
scaffold_name=SoapdenovoOut
scaffoldIn="${scaffold_name}"'.scafSeq'
max_rd_len="${max_rd_len}"
#Output="${Output}"
#kmer="${kmer}"
overlapParam="${overlapParam}"
options=''

if [ -n "${overlapParam}" ]; then options="$options '-p' ${overlapParam}"; fi

#iget -fTr "${inputDirectory}"
directory=$(basename ${inputDirectory})

cd $directory
../GapCloser -a $scaffoldIn -b config_file.txt -o $scaffold_name"_gapcloser.fa" -l $max_rd_len $options -t 32

cp SoapdenovoOut_gapcloser.fa ../
