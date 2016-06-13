#!/bin/bash
#!/bin/bash
#SBATCH -J gsnap1
#SBATCH -o gsnap1.out
#SBATCH -e gsnap1.err
#SBATCH -t 01:00:00
#SBATCH -p development
#SBATCH -N 1 -n 16
#SBATCH  -A iPlant-Collabs

module load irods

#wrapper script for gsnap on Lonestar & Stampede
#more stuff from Roger Barthelson
#Thanks to Andrew Lenards for help

chmod a+x *


stuffx=""
runthis=''
#reference="${reference}"
reference="/iplant/home/shared/iplantcollaborative/example_data/gsnap/e_coli.fa"
reference_data="${reference_data}"
#reference_data="/iplant/home/shared/iplantcollaborative/example_data/gsnap/Ecoli.tar"
#newgenome="${newgenome}"
kmer="${kmer}"
basesize="${basesize}"
#
seqFolder="${seqFolder}"
seqFolder="/iplant/home/shared/iplantcollaborative/example_data/gsnap/ecSeqs"
seqmode="paired"
#seqmode="${seqmode}"
#
orientation="${orientation}"
chastity="${chastity}"
gunZip="${gunZip}"
maxMismatch="${maxMismatch}"
adapterStrip="${adapterStrip}"
indelPenalty="${indelPenalty}"
#mode="${mode}"
#threads="${threads}"
gmapMode="${gmapMode}"
gmapTrigger="${gmapTrigger}"
novelSplicing="${novelSplicing}"
#novelSplicing="1"
spliceIndex="${spliceIndex}"
quality="${quality}"
#quality=sanger
nPaths="${nPaths}"
nonExcess="${nonExcess}"
readGroupID="${readGroupID}"
readGroupName="${readGroupName}"
#readGroupName=ecolistuff
readGroupLibrary="${readGroupLibrary}"
#readGroupLibrary=lib1
readGroupPlatform="${readGroupPlatform}"
#readGroupPlatform=illumina
#indx="${indx}"
indx=ecoli
directory=$indx
###
#iget -fTr /iplant/home/rogerab/applications/gsnap-gmap_121212/bin
#chmod a+x * ;
if [ -n "${kmer}" ]; then stuffx="$stuffx -k $kmer"; fi
if [ -n "${basesize}" ]; then stuffx="$stuffx -b $basesize"; fi
if [ -n "${reference}" ];
then
newgenome="NEW"
iget -fTr "${reference}"
INPUT_Ref=$(basename ${reference})
./gmap_build -B="./" "${stuffx}" -D "$directory" -d "${indx}" "${INPUT_Ref}"
#./gmap_build -B="./" "${stuffx}" -d "${indx}" "${INPUT_Ref}"
else
#iget -fTr "${reference_data}"
INPUT_RD=$(basename ${reference_data})
refData=$(basename ${INPUT_RD} .tar)
tar xvf "${INPUT_RD}"
directory="${refData}"
fi

################

if [ -n "${orientation}" ]; then runthis="$runthis -o $orientation"; fi
if [ -n "${chastity}" ]; then runthis="$runthis --filter-chastity=$chastity"; fi
if [ -n "${gunZip}" ]; then runthis="$runthis --gunzip $gunZip"; fi
if [ -n "${maxMismatch}" ]; then runthis="$runthis -m $maxMismatch"; fi
if [ -n "${adapterStrip}" ]; then runthis="$runthis -a $adapterStrip"; fi
if [ -n "${indelPenalty}" ]; then runthis="$runthis -i $indelPenalty"; fi
#if [ -n "${mode}" ]; then runthis="$runthis --mode $mode"; fi
if [ -n "${gmapMode}" ]; then runthis="$runthis -gmap-mode=$gmapMode"; fi
if [ -n "${gmapTrigger}" ]; then runthis="$runthis --trigger-score-for-gmap=$gmapTrigger"; fi
if [ -n "${novelSplicing}" ]; then runthis="$runthis -N $novelSplicing"; fi
if [ -n "${quality}" ]; then runthis="$runthis --quality-protocol=$quality"; fi
if [ -n "${nPaths}" ]; then runthis="$runthis -n $nPaths"; fi
if [ -n "${nonExcess}" ]; then runthis="$runthis -Q"; fi
if [ -n "${readGroupID}" ]; then runthis="$runthis --read-group-id=$readGroupID"; fi
if [ -n "${readGroupName}" ]; then runthis="$runthis --read-group-name=$readGroupName"; fi
if [ -n "${readGroupLibrary}" ]; then runthis="$runthis --read-group-library=$readGroupLibrary"; fi
if [ -n "${readGroupPlatform}" ]; then runthis="$runthis --read-group-platform=$readGroupPlatform"; fi
if [ -n "${spliceIndex}" ]; 
then
#iget -fT "${spliceIndex}";
INPUT_Spl=$(basename ${spliceIndex});
runthis="$runthis -s ./$INPUT_Spl";
fi

iget -fTr "${seqFolder}"
Input1=$(basename ${seqFolder});
if [ $seqmode == unpaired ];
then
echo "SE MODE!"
for x in $Input1/*
do ./gsnap -D "${directory}" -d "${directory}" -A sam -t 16 $runthis "$x" > "$x"'.sam'
done
mv $Input1/*.sam ./
fi

if [ $seqmode == paired ];
then
echo "PE MODE!"
for x in $Input1/*
do
        echo "file for this iteration: $x"

        if [[ "$x" =~ .*1\.fq$ ]]; 
        then
        z=$(basename $x 1.fq)
#                 echo "I found one!" 
#                 echo "I found: $x and $z"
                ./gsnap -D "${directory}" -d "${directory}" -A sam -t 16 $runthis "$Input1"/"$z"'1.fq' "$Input1"/"$z"'2.fq' > "$z"'pe.sam'
        fi
        if [[ "$x" =~ .*1\.fa$ ]]; 
        then
        z=$(basename $x 1.fa)
                ./gsnap -D "${directory}" -d "${directory}" -A sam -t 16 $runthis "$Input1"/"$z"'1.fa' "$Input1"/"$z"'2.fa' > "$z"'pe.sam'  
        fi
        if [[ "$x" =~ .*1\.fastq$ ]]; 
        then
        z=$(basename $x 1.fastq)
                ./gsnap -D "${directory}" -d "${directory}" -A sam -t 16 $runthis "$Input1"/"$z"'1.fastq' "$Input1"/"$z"'2.fastq' > "$z"'pe.sam'  
        fi
        if [[ "$x" =~ .*1\.fasta$ ]]; 
        then
        z=$(basename $x 1.fasta)
                ./gsnap -D "${directory}" -d "${directory}" -A sam -t 16 $runthis "$Input1"/"$z"'1.fasta' "$Input1"/"$z"'2.fasta' > "$z"'pe.sam'  
        fi
done
fi
#################################################################### 
mkdir "$Input1"'_gsnap'
mv *.sam ./"$Input1"'_gsnap'
rm -R "$Input1"

if [ -n "${reference}" ] ;
then
#tar -cf "${indx}"'.tar' "${indx}"/"${indx}"/*
tar -cf "${directory}"'.tar' "${directory}"
rm -R "${directory}"
#gzip -9 -S .gz "${indx}"'.tar'
fi
######################################
 
