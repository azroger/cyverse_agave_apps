#!/bin/bash

#wrapper script for creating a config file or manifest for the soapdenovo assembler
#more stuff from Roger Barthelson


iget /iplant/home/rogerab/applications/soapdenovo2a/bin/GapCloser
chmod a+x ./GapCloser

#inputDirectory="${inputDirectory}"
inputDirectory="/iplant/home/rogerab/analyses/soapdenovo_spAassemblathon_2-2013-07-10-18-02-54.054"
#scaffold_name="${scaffold_name}"
scaffold_name=SoapOutput39assemblathon1.scafSeq
#max_rd_len="${max_rd_len}
max_rd_len=101
#Output="${Output}"
overlapParam="${overlapParam}"
options=''

if [ -n "${overlapParam}" ]; then options="$options '-p' ${overlapParam}"; fi

iget -fTr "${inputDirectory}"
directory=$(basename ${inputDirectory})

cd $directory
../GapCloser -a $scaffold_name -b config_file.txt -o $scaffold_name"_gapcloser.fa" -l $max_rd_len $options -t 24
