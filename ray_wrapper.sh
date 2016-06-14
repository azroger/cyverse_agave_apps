#!/bin/bash

#wrapper running the ray assembler
#more stuff from Roger Barthelson


###########################################################################
Output="${Output}"
kmer="${kmer}"
#n_cpu=8
seqFolder=Reads
interleaved="${interleaved}"
Output="RayOutput"
kmer="31"
# n_cpu="12"
# seqFolder="/iplant/home/shared/iplantcollaborative/example_data/Ray2.2.0/Reads"
runthis=''
#interleaved=''

# module purge
# module load intel/11.1
# module load openmpi
# module load irods
#iget -fT "/iplant/home/rogerab/applications/Ray2.2.0/bin/Ray"
#############################################
#iget -fTrN 12 "${seqFolder}"

chmod a+x ./Ray

Input1=$(basename ${seqFolder});
        if [[ $interleaved = yes ]];
        then
        	for x in $Input1/*
        	do
        	runthis="$runthis -i $x"
        	done
ibrun -n 30 -o 0 ./Ray -k $kmer $runthis -o "${Output}"
        else
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
        if [[ "$x" =~ .*[A-Z,a-z,_,0,3-9]\.f.* ]];
        then
        runthis="$runthis -s $x";
        fi
done

####################################################
time ibrun -n 30 -o 0 ./Ray -k $kmer $runthis -o "${Output}"
		fi
