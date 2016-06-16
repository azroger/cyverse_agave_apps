#!/bin/bash

#wrapper script for the velvetg assembler
#more stuff from Roger Barthelson

stuffx=''
junk1=''
junk2=''
junk3=''
runthis=''

velvet_dir="/iplant/home/rogerab/archive/jobs/job-2188-velveth10/VelvetDirectory"
INPUT_DIR=$(basename ${velvet_dir})
tar -xf "$INPUT_DIR"
stuffx=$(basename $INPUT_DIR .tar)

#######################################

#ctff="${ctff}"    
read_trkg="${read_trkg}"
min_contig_lgth="${min_contig_lgth}"
amos_file="-amos_file yes"
ctff="${ctff}"
exp_cov="${exp_cov}"
long_cov_cutoff="${long_cov_cutoff}"
ins_length="-ins_length 500"
ins_length_sd="-ins_length_sd 200"
ins_length2="-ins_length2 3000"
ins_length2_sd="-ins_length2_sd 500"
ins_length_long="${ins_length_long}"
ins_length_long_sd="${ins_length_long_sd}" 
scaffolding="-scaffolding yes"
max_branch_length="${max_branch_length}"
long_mult_cutoff="${long_mult_cutoff}"
unused_reads="${unused_reads}"
alignments="${alignments}"
exportFiltered="${exportFiltered}"
paired_exp_fraction="${paired_exp_fraction}"
conserveLong="${conserveLong}"

stuffx=""${INPUT_DIR}"  "${read_trkg}" "${ctff}" "${min_contig_lgth}" "${amos_file}" "${exp_cov}" "${long_cov_cutoff}""
junk1=""${ins_length}" "${ins_length_sd}" "${ins_length2}" "${ins_length2_sd}" "${ins_length_long}" "${ins_length_long_sd}""
junk2=""${scaffolding}" "${max_branch_length}" "${max_divergence}" "${max_gap_count}" "${min_pair_count}" "${max_coverage}""
junk3=""${coverage_mask}" "${long_mult_cutoff}" "${unused_reads}" "${alignments}" "${paired_exp_fraction}" "${conserveLong}""

plsrunthis="${stuffx}""${junk1}""${junk2}""${junk3}"

module purge
module load TACC
module load iRODS
module load velvet


iget -fTr "${velvet_dir}"

export OMP_NUM_THREADS=6
echo $plsrunthis | xargs velvetg
