#!/bin/bash

#$ -V                    #Inherit the submission environment

#$ -cwd                  # Start job in submission directory

#$ -N newblertest               # Job Name

#$ -j y                  # Combine stderr and stdout

#$ -o $JOB_NAME.o$JOB_ID # Name of the output file (eg. myMPI.oJobID)

#$ -pe 16way 16          # Requests 12 tasks/node, 24 cores total (16 now)

#$ -q development                # Queue name "normal" (vis now)

#$ -l h_rt=01:00:00      # Run time (hh:mm:ss) - 1.5 hours (8 hrs now)

#$ -M rogerab@email.arizona.edu         # Use email notification address

#$ -m be                 # Email at Begin and End of job

set -x                   # Echo commands, use "set echo" with csh


#MODE=${mode}
#INPUT="${inputSeqs}"
#OUTNAME="${outputName}"
#OUTFORM=${outputFormat}

#MODE="auto"
INPUT="/iplant/home/rogerab/data/sequencing1/FFGLB5S04.sff"
##
OUTNAME="NewblerOut"
##OUTFORM="directory"
CPU=16
MIN_CONTIG_SIZE=100
LARGE_CONTIG_SIZE=500



module purge
module load TACC
module swap intel gcc
module load irods

iinit:Sphaeralcea
wait

#Copy from iRODS
iget -fT "${INPUT}"
wait
INPUT_F=$(basename ${INPUT})

/work/01685/rogerab/bin3/bin/runAssembly -o "${OUTNAME}" -m -force -large -cpu "${CPU}" -a "${MIN_CONTIG_SIZE}" -l "${LARGE_CONTIG_SIZE}" "${OTHER}" "${INPUT_F}"
#/work/01685/rogerab/bin3/bin/runAssembly -o "${OUTNAME}" -m -force -large -cpu 6 "${INPUT_F}"

