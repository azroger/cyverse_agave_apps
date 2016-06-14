#!/bin/bash

#wrapper script for the velvetg assembler
#more stuff from Roger Barthelson


velvet_dir="${velvet_dir}"
INPUT_tar=$(basename ${velvet_dir})
#INPUT_DIR=$(basename $INPUT_tar .tar.gz)
tar xvzf "$INPUT_tar"
plsrunthis="VelvetOut"
#plsrunthis=$INPUT_DIR
#######################################

if [ -n "${min_trans_lgth}" ]; then plsrunthis="$plsrunthis -min_trans_lgth ${min_trans_lgth}"; fi
if [ -n "${ctff}" ]; then plsrunthis="$plsrunthis '-cov_cutoff' ${ctff}"; fi
if [ -n "${min_pair_cnt}" ]; then plsrunthis="$plsrunthis '-min_pair_count' ${min_pair_cnt}"; fi
if [ -n "${ins_length}" ]; then plsrunthis="$plsrunthis '-ins_length' ${ins_length}"; fi
if [ -n "${ins_length_sd}" ]; then plsrunthis="$plsrunthis '-ins_length_sd' ${ins_length_sd}"; fi
if [ -n "${ins_length2}" ]; then plsrunthis="$plsrunthis '-ins_length2' ${ins_length2}"; fi
if [ -n "${ins_length2_sd}" ]; then plsrunthis="$plsrunthis '-ins_length2_sd' ${ins_length2_sd}"; fi
if [ -n "${ins_length_long}" ]; then plsrunthis="$plsrunthis '-ins_length_long' ${ins_length_long}"; fi
if [ -n "${ins_length_long_sd}" ]; then plsrunthis="$plsrunthis '-ins_length_long_sd' ${ins_length_long_sd}"; fi
if [ -n "${scaffolding}" ]; then plsrunthis="$plsrunthis '-scaffolding' ${scaffolding}"; fi
if [ -n "${paired_ctff}" ]; then plsrunthis="$plsrunthis '-paired_cutoff' ${paired_ctff}"; fi
if [ -n "${mrge}" ]; then plsrunthis="$plsrunthis '-merge' ${mrge}"; fi
if [ -n "${unused_reads}" ]; then plsrunthis="$plsrunthis '-unused_reads' ${unused_reads}"; fi
if [ -n "${alignments}" ]; then plsrunthis="$plsrunthis '-alignments' ${alignments}"; fi
if [ -n "${edgeFracCtff}" ]; then plsrunthis="$plsrunthis '-edgeFractionCutoff' ${edgeFracCtff}"; fi
if [ -n "${degree_ctff}" ]; then plsrunthis="$plsrunthis '-degree_cutoff' ${degree_ctff}"; fi

  

#module load oases/


#iget -fTr "${velvet_dir}"


echo $plsrunthis | xargs oases
wait
# tar cf Oases_Out.tar VelvetOut/*
if [ -r "VelvetOut/transcripts.fa" ] ;
then
cp VelvetOut/transcripts.fa ./
fi
tar cvzf Oases_Out.tar.gz VelvetOut/*
rm VelvetG_Out.tar.gz
wait
rm -r VelvetOut
