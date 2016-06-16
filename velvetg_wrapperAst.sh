#!/bin/bash

#wrapper script for the velvetg assembler
#more stuff from Roger Barthelson

stuffx=''
junk1=''
junk2=''
junk3=''
runthis=''

velvet_dir="${velvet_dir}"
INPUT_DIR=$(basename ${velvet_dir})
tar xvzf "$INPUT_DIR"
#Inputs=$(basename $INPUT_DIR .tar)
stuffx=VelvetOut
#stuffx=$Inputs
#######################################

if [ -n "${read_trkg}" ]; then stuffx="$stuffx -read_trkg ${read_trkg}"; fi
if [ -n "${min_contig_lgth}" ]; then stuffx="$stuffx -min_contig_lgth ${min_contig_lgth}"; fi

if [ -n "${ctff}" ]; then stuffx="$stuffx '-cov_cutoff' ${ctff}"; fi
if [ -n "${exp_cov}" ]; then stuffx="$stuffx '-exp_cov' ${exp_cov}"; fi
if [ -n "${long_cov_cutoff}" ]; then stuffx="$stuffx '-long_cov_cutoff' ${long_cov_cutoff}"; fi
if [ -n "${ins_length}" ]; then junk1="$junk1 '-ins_length' ${ins_length}"; fi
if [ -n "${ins_length_sd}" ]; then junk1="$junk1 '-ins_length_sd' ${ins_length_sd}"; fi
if [ -n "${ins_length2}" ]; then junk1="$junk1 '-ins_length2' ${ins_length2}"; fi
if [ -n "${ins_length2_sd}" ]; then junk1="$junk1 '-ins_length2_sd' ${ins_length2_sd}"; fi
if [ -n "${ins_length_long}" ]; then junk1="$junk1 '-ins_length_long' ${ins_length_long}"; fi
if [ -n "${ins_length_long_sd}" ]; then junk1="$junk1 '-ins_length_long_sd' ${ins_length_long_sd}"; fi
if [ -n "${scaffolding}" ]; then junk2="$junk2 '-scaffolding' ${scaffolding}"; fi
if [ -n "${max_branch_length}" ]; then junk2="$junk2 '-max_branch_length' ${max_branch_length}"; fi
if [ -n "${long_mult_cutoff}" ]; then junk3="$junk3 '-long_mult_cutoff' ${long_mult_cutoff}"; fi
if [ -n "${unused_reads}" ]; then junk3="$junk3 '-unused_reads' ${unused_reads}"; fi
if [ -n "${alignments}" ]; then junk3="$junk3 '-alignments' ${alignments}"; fi
if [ -n "${paired_exp_fraction}" ]; then junk3="$junk3 '-min_pair_count' ${paired_exp_fraction}"; fi
if [ -n "${conserveLong}" ]; then junk3="$junk3 '-conserveLong' ${conserveLong}"; fi

runthis="$stuffx""${junk1}""${junk2}""${junk3}"


export OMP_NUM_THREADS=15
echo $runthis | xargs velvetg
cp VelvetOut/contigs.fa ./
tar cvzf VelvetG_Out.tar.gz VelvetOut/*
rm VelvetOut.tar.gz
wait
rm -r VelvetOut
#tar cf VelvetG_Out.tar VelvetOut/*
