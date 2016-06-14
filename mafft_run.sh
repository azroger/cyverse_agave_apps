#!/bin/bash
#SBATCH -J mafft2
#SBATCH -o mafft2.out
#SBATCH -e mafft2.err
#SBATCH -t 00:30:00
#SBATCH -p development
#SBATCH -N 1 -n 16
#SBATCH  -A iPlant-Collabs

module load mafft


#input_seq="${input_seq}"
input_seq="M3297.fa"
#stuff="$input_seq"
#stuff='--thread -8'"$stuff"
# gap="${gap}"
# offset="${offset}"
# maxiterate="${maxiterate}"
# clustalout="${clustalout}"
# reorder="${reorder}"
# output=mafft_out.fa
#maxiterate=1000
#retree=1
#clustalout=yes



#  	if [ -n "$clustalout" ];
#   	then
#  	output="mafft_out"; 
#  	stuff="--clustalout $stuff"
#  	fi
#  if [ -n "${gap}" ]; then stuff="'--op' ${gap} $stuff"; fi
#  if [ -n "${offset}" ]; then stuff="'--ep' ${offset} $stuff"; fi 
# if [ -n "${maxiterate}" ]; then stuff="--maxiterate ${maxiterate} $stuff"; fi
# if [ -n "${retree}" ]; then stuff="'--retree' ${retree} $stuff"; fi
#if [ -n "${maxiterate}" ]; then stuff="--maxiterate ${maxiterate} $stuff"; fi
# if [ -n "${retree}" ]; then stuff="--retree ${retree} $stuff"; fi

# if [ -n "

mafft --thread -8 "$input_seq" > mafft_out.fa
