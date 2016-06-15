#!/bin/bash
#SBATCH -J spades1
#SBATCH -o spades1.out
#SBATCH -e spades1.err
#SBATCH -t 06:00:00
#SBATCH -p normal
#SBATCH -N 8 -n 128
#SBATCH  -A iPlant-Master


/work/01685/rogerab/bin3/SPAdes-3.5.0-Linux/bin/spades.py --pe1-1 frag_1.fastq --pe1-2 frag_2.fastq --pe2-rf --pe2-1 shortjump_1.fastq --pe2-2 shortjump_2.fastq -o spades_out
