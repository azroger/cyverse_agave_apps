#!/bin/bash
#wrapper script for gsnap on Lonestar & Stampede
#more stuff from Roger Barthelson
#Thanks to Andrew Lenards for help

tar xvzf bin.tgz
chmod a+x bin/*


stuffx=""
runthis=''
reference="${reference}"
reference_data="${reference_data}"
kmer="${kmer}"
basesize="${basesize}"
#
seqFolder="${seqFolder}"
snpsMap="${snpsMap}"
cmetMap="${cmetMap}"
atoiMap="${atoiMap}"
seqmode="${seqmode}"
#
orientation="${orientation}"
gunZip="${gunZip}"
maxMismatch="${maxMismatch}"
adapterStrip="${adapterStrip}"
indelPenalty="${indelPenalty}"
mode="${mode}"
stranded="${stranded}"
gmapTrigger="${gmapTrigger}"
novelSplicing="${novelSplicing}"
spliceIndex="${spliceIndex}"
quality="${quality}"
nPaths="${nPaths}"
nonExcess="${nonExcess}"
readGroupID="${readGroupID}"
readGroupName="${readGroupName}"
readGroupLibrary="${readGroupLibrary}"
readGroupPlatform="${readGroupPlatform}"
indx="${indx}"
directory="${indx}"
anno_path="${anno_path}"
splicemode="${splicemode}"
runthis=''
###
if [ -n "${kmer}" ]; then stuffx="$stuffx -k $kmer"; fi
if [ -n "${basesize}" ]; then stuffx="$stuffx -b $basesize"; fi
if [ -n "${reference}" ];
then
newgenome="NEW"
INPUT_Ref=$(basename ${reference})
#bin/gmap_build -B="./" "${stuffx}" -D "$directory" -d "${indx}" "${INPUT_Ref}"
#bin/gmap_build -d "${indx}" -F "${indx}" -D . "${reference}"
bin/gmap_build -d "${indx}" -D . "${reference}"
        if [ -n "${anno_path}" ]; 
        then
        anno_file=$(basename ${anno_path})
        if [ "${splicemode}" = 'splicesites' ];
        then
        cat "${anno_file}" | bin/gtf_splicesites > splicesites.txt
        cat splicesites.txt | bin/iit_store -o "${indx}"
        cp "${indx}"'.iit' "${indx}"/"${indx}"'.maps/'
        runthis="$runthis --use-splicing=${indx}"
        fi
        if [ "${splicemode}" = 'introns' ];
        then
        cat "${anno_file}" | bin/gtf_introns > introns.txt
        cat introns.txt | bin/iit_store -o "${indx}"
        cp "${indx}"'.iit' "${indx}"/"${indx}"'.maps/'
        runthis="$runthis --use-splicing=${indx}"
        fi
        fi
        if [ -n "${snpsMap}" ]; 
        then
        snps_file=$(basename ${snpsMap})
        cat "${snps_file}" | bin/vcf_iit > SNPs.txt
        cat SNPs.txt | bin/iit_store -o  SNPs.iit
        runthis="$runthis --use-snps='SNPs'"
        fi
        if [ -n "${cmetMap}" ]; 
        then
        bin/cmetindex -d "${indx}" -F ./"${directory}" "${INPUT_Ref}"
        runthis="$runthis --cmetdir=${directory}"
        if [ "${stranded}" = 'STRANDED' ];
        then
        mode="cmet-stranded";
        else
        mode="cmet-nonstranded"
        fi
        fi
        if [ -n "${atoiMap}" ]; 
        then
        bin/atoiindex -d "${indx}" -F ./"${directory}" "${INPUT_Ref}"
        runthis="$runthis --atoidir=${directory}"
        if [ "${stranded}" = 'STRANDED' ];
        then
        mode="atoi-stranded";
        else
        mode="atoi-nonstranded";
        fi
        fi
else
INPUT_RD=$(basename ${reference_data})
refData=$(basename ${INPUT_RD} .tar)
tar xvf "${INPUT_RD}"
directory="${refData}"
fi

################

if [ -n "${orientation}" ]; then runthis="$runthis --orientation=$orientation"; fi
if [ -n "${gunZip}" ]; then runthis="$runthis --gunzip"; fi
if [ -n "${maxMismatch}" ]; then runthis="$runthis -m $maxMismatch"; fi
if [ -n "${adapterStrip}" ]; then runthis="$runthis -a $adapterStrip"; fi
if [ -n "${indelPenalty}" ]; then runthis="$runthis -i $indelPenalty"; fi
if [ -n "${snpsMap}" ]; then runthis="$runthis --mode $mode"; fi
if [ -n "${cmetMap}" ]; then runthis="$runthis --mode $mode"; fi
if [ -n "${atoiMap}"  ]; then runthis="$runthis --mode $mode"; fi
if [ -n "${gmapTrigger}" ]; then runthis="$runthis --trigger-score-for-gmap=$gmapTrigger"; fi
if [ -n "${novelSplicing}" ]; then runthis="$runthis -N $novelSplicing"; fi
if [ -n "${quality}" ]; then runthis="$runthis --quality-protocol=$quality"; fi
if [ -n "${nPaths}" ]; then runthis="$runthis -n $nPaths"; fi
if [ -n "${nonExcess}" ]; then runthis="$runthis -Q"; fi
if [ -n "${readGroupID}" ]; then runthis="$runthis --read-group-id=$readGroupID"; fi
if [ -n "${readGroupName}" ]; then runthis="$runthis --read-group-name=$readGroupName"; fi
if [ -n "${readGroupLibrary}" ]; then runthis="$runthis --read-group-library=$readGroupLibrary"; fi
if [ -n "${readGroupPlatform}" ]; then runthis="$runthis --read-group-platform=$readGroupPlatform"; fi

Input1=$(basename ${seqFolder});
if [ $seqmode = unpaired ];
then
echo "SE MODE!"
for x in $Input1/*
do
 bin/gsnap -D . -d "${directory}" -A sam -t 16 $runthis "$x" > "$x"'.sam'
done
mv $Input1/*.sam ./
fi

if [ $seqmode = paired ];
then
echo "PE MODE!"
for x in $Input1/*
do
        echo "file for this iteration: $x"

        if [[ "$x" =~ .*1\.fq$ ]]; 
        then
        z=$(basename $x 1.fq)
                bin/gsnap -D . -d "${directory}" -A sam -t 16 $runthis "$Input1"/"$z"'1.fq' "$Input1"/"$z"'2.fq' > "$z"'pe.sam'
        fi
        if [[ "$x" =~ .*1\.fa$ ]]; 
        then
        z=$(basename $x 1.fa)
                bin/gsnap -D . -d "${directory}" -A sam -t 16 $runthis "$Input1"/"$z"'1.fa' "$Input1"/"$z"'2.fa' > "$z"'pe.sam'  
        fi
        if [[ "$x" =~ .*1\.fastq$ ]]; 
        then
        z=$(basename $x 1.fastq)
                bin/gsnap -D . -d "${directory}" -A sam -t 16 $runthis "$Input1"/"$z"'1.fastq' "$Input1"/"$z"'2.fastq' > "$z"'pe.sam'  
        fi
        if [[ "$x" =~ .*1\.fasta$ ]]; 
        then
        z=$(basename $x 1.fasta)
                bin/gsnap -D . -d "${directory}" -A sam -t 16 $runthis "$Input1"/"$z"'1.fasta' "$Input1"/"$z"'2.fasta' > "$z"'pe.sam'  
        fi
done
fi
#################################################################### 
mkdir "$Input1"'_gsnap'
mv *.sam ./"$Input1"'_gsnap'
rm -R "$Input1"

if [ -n "${reference}" ] ;
then
tar -cf "${directory}"'.tar' "${directory}"
rm -R "${directory}"
fi
######################################
rm -r bin
rm "${reference}" 

