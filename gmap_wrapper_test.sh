#!/bin/bash

#wrapper script for gmap on Stampede
#more stuff from Roger Barthelson
#----------------------------------------------------
# Example SLURM job script to run MPI applications on 
# TACC's Stampede system.
#
#----------------------------------------------------

#SBATCH -J gmaptest1            # Job name
#SBATCH -o gsq.%j.out       # Name of stdout output file (%j expands to jobId)
#SBATCH -p development        # Queue name
#SBATCH -N 1                  # Total number of nodes requested (16 cores/node)
#SBATCH -n 16                 # Total number of mpi tasks requested
#SBATCH -t 01:00:00           # Run time (hh:mm:ss) - 1.5 hours


#sequence="${sequence}"
sequence="/iplant/home/shared/iplantcollaborative/example_data/gmap/test_transcripts.fa"
#indx="${indx}"
indx="Athaliana"
directory="${indx}"
#reference="${reference}"
reference="/iplant/home/shared/iplantcollaborative/example_data/gmap/genome.fa"
reference_data="${reference_data}"
kmer="${kmer}"
basesize="${basesize}"
no_splicing="${no_splicing}"
cross_species="${cross_species}"
#Output_type="${Output_type}"
Output_type="2"
nPaths="${nPaths}"
stuffx=''
runthis=''

###
iget -fTr /iplant/home/rogerab/applications/gmap12/bin
mv bin/* ./
################
chmod a+x * ;
if [ -n "${kmer}" ]; then stuffx="$stuffx -k $kmer"; fi
if [ -n "${basesize}" ]; then stuffx="$stuffx -b $basesize"; fi
if [ -n "${reference}" ];
then
iget -fTr "${reference}"
INPUT_Ref=$(basename ${reference})
./gmap_build -B="./" "${stuffx}" -D "$directory" -d "${indx}" "${INPUT_Ref}"
else
iget -fTr "${reference_data}"
INPUT_RD=$(basename ${reference_data})
refData=$(basename ${INPUT_RD} .tar)
tar xvf "${INPUT_RD}"
directory="${refData}"
fi

################
if [ -n "${nPaths}" ]; then runthis="$runthis -n $nPaths"; fi
if [ -n "${kmer}" ]; then runthis="$runthis -n $kmer"; fi
if [ -n "${basesize}" ]; then runthis="$runthis --basesize $basesize"; fi
if [ -n "${no_splicing}" ]; then runthis="$runthis --nosplicing"; fi
if [ -n "${cross_species}" ]; then runthis="$runthis --cross-species"; fi
if [ -n "${nPaths}" ]; then runthis="$runthis -n $nPaths"; fi
if [ -n "${Output_type}" ]; then runthis="$runthis -f $Output_type"; fi
################
iget -fTr "${sequence}"
Input_seq=$(basename ${sequence});
./gmap -D "${directory}" -d "${directory}" -t 8 $runthis $Input_seq > "$Input_seq"'.out'

#################################################################### 

if [ -n "${reference}" ] ;
then
tar -cf "${directory}"'.tar' "${directory}"
rm -R "${directory}"
fi
######################################
 
