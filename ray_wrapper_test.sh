#!/bin/bash

#$ -V                    #Inherit the submission environment

#$ -cwd                  # Start job in submission directory

#$ -N raytest1       # Job Name

#$ -j y                  # Combine stderr and stdout

#$ -o $JOB_NAME.o$JOB_ID # Name of the output file (eg. myMPI.oJobID)

#$ -pe 12way 12          # Requests 12 tasks/node, 24 cores total (16 now)

#$ -q development                  # Queue name "normal" 

#$ -l h_rt=01:00:00      # Run time (hh:mm:ss) - 1.5 hours (8 hrs now)

#$ -M rogerab@email.arizona.edu                   # Use email notification address

#$ -m be                 # Email at Begin and End of job

set -x                   # Echo commands, use "set echo" with csh



#wrapper running the ray assembler
#more stuff from Roger Barthelson


###########################################################################
# Output="${Output}"
# kmer="${kmer}"
# n_cpu="${n_cpu}"
# seqFolder="${seqFolder}"
Output="RayOutput"
kmer="31"
n_cpu="6"
seqFolder="/iplant/home/shared/iplantcollaborative/example_data/Ray2.2.0/Reads"
runthis=''


#module load mvapich2
module purge
module load intel/11.1
module load openmpi
module load irods
#############################################
#iget -fTr "${seqFolder}"
Input1=$(basename ${seqFolder});
for x in $Input1/*

do
        echo "file for this iteration: $x"
        if [[ "$x" =~ .*1\.fq$ ]]; 
        then
        w="2.fq"
        z=$(basename $x 1.fq)
        if [ -r $Input1/$z$w ];
        then
        runthis="$runthis -p $x $Input1/$z$w";
do
        echo "file for this iteration: $x"
        if [[ "$x" =~ .*1\.fq$ ]]; 
        then
        w="2.fq"
        z=$(basename $x 1.fq)
        if [ -r $Input1/$z$w ];
        then
        runthis="$runthis -p $x $Input1/$z$w";
        else
        runthis="$runthis -s $x";
        fi
        fi
        if [[ "$x" =~ .*1\.fasta$ ]]; 
        then
        w="2.fasta"
        z=$(basename $x 1.fasta);
        if [ -r $Input1/$z$w ];
        then
        runthis="$runthis -p $x $Input1/$z$w";
        else
        runthis="$runthis -s $x";
        fi
        fi
        if [[ "$x" =~ .*1\.fastq$ ]]; 
        then
        w="2.fastq"
        z=$(basename $x 1.fastq);
        if [[ -r $Input1/$z$w ]];
        then
        runthis="$runthis -p $x $Input1/$z$w";
        else
        runthis="$runthis -s $x";
        fi
        fi
        if [[ "$x" =~ .*1\.fa$ ]]; 
        then
        w="2.fa"
        z=$(basename $x 1.fa);
        if [ -r $Input1/$z$w ];
        then
        runthis="$runthis -p $x $Input1/$z$w";
        else
        runthis="$runthis -s $x";
        fi
        fi
                if [[ "$x" =~ .*2\.f.* ]];
                then
                read1=${x//2./1.};
                if [ -r $read1 ];
                then
                continue 1
                else
        runthis="$runthis -s $x";
        fi
        fi
done
####################################################

mpirun -n 12 /work/01685/rogerab/bin3/Ray-v2.2.0/Ray -k $kmer $runthis -o "${Output}"
