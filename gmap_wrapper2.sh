#!/bin/bash

#wrapper script for gmap on Stampede
#more stuff from Roger Barthelson

tar xvzf bin.tgz
chmod a+x bin/*

sequence="${sequence}"
#sequence="/iplant/home/shared/iplantcollaborative/example_data/gmap/test_transcripts.fa"
indx="${indx}"
#indx="Athaliana"
directory="${indx}"
reference="${reference}"
#reference="/iplant/home/shared/iplantcollaborative/example_data/gmap/genome.fa"
reference_data="${reference_data}"
kmer="${kmer}"
no_splicing="${no_splicing}"
cross_species="${cross_species}"
Output_type="${Output_type}"
#Output_type="2"
nPaths="${nPaths}"
subOptimal="${subOptimal}"
readGroupID="${readGroupID}"
readGroupName="${readGroupName}"
readGroupLibrary="${readGroupLibrary}"
readGroupPlatform="${readGroupPlatform}"
stuffx=''
runthis=''

###
#iget -fTr /iplant/home/rogerab/applications/gmap12/bin
################
chmod a+x * ;
if [ -n "${kmer}" ]; then stuffx="$stuffx -k $kmer"; fi
if [ -n "${reference}" ];
then
#iget -fTr "${reference}"
INPUT_Ref=$(basename ${reference})
bin/gmap_build -d "${indx}" -D . $stuffx "${reference}"
else
#iget -fTr "${reference_data}"
INPUT_RD=$(basename ${reference_data})
refData=$(basename ${INPUT_RD} .tar)
tar xvf "${INPUT_RD}"
directory="${refData}"
fi

################
if [ -n "${nPaths}" ]; then runthis="$runthis -n $nPaths"; fi
if [ -n "${subOptimal}" ]; then runthis="$runthis --suboptimal-score=$subOptimal"; fi     
if [ -n "${kmer}" ]; then runthis="$runthis -n $kmer"; fi
if [ -n "${no_splicing}" ]; then runthis="$runthis --nosplicing"; fi
if [ -n "${cross_species}" ]; then runthis="$runthis --cross-species"; fi
if [ -n "${Output_type}" ]; then runthis="$runthis -f $Output_type"; fi
if [ -n "${readGroupID}" ]; then runthis="$runthis --read-group-id=$readGroupID"; fi
if [ -n "${readGroupName}" ]; then runthis="$runthis --read-group-name=$readGroupName"; fi
if [ -n "${readGroupLibrary}" ]; then runthis="$runthis --read-group-library=$readGroupLibrary"; fi
if [ -n "${readGroupPlatform}" ]; then runthis="$runthis --read-group-platform=$readGroupPlatform"; fi
################
#iget -fTr "${sequence}"
Input_seq=$(basename ${sequence});
bin/gmap -D . -d "${directory}" -t 8 $runthis $Input_seq > "$Input_seq"'.out'

#################################################################### 

if [ -n "${reference}" ] ;
then
tar -czf "${directory}"'.tar.gz' "${directory}"
rm -R "${directory}"
rm "${reference}"
fi
rm "${sequence}"
rm -R bin

######################################
 
