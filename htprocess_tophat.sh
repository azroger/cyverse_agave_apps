#!/bin/bash


# module load irods
# module load samtools



tar xvzf tophat-2.0.13.Linux_x86_64.tar.gz
tar xvzf bowtie2.tar.gz
export PATH=$PATH:./tophat-2.0.13.Linux_x86_64/:./bowtie2-2.2.4/




               	anchor=${anchor};
               	mismatch=${mismatch};
               	min_intron=${min_intron};
               	max_intron=${max_intron};
               	edit_dist=${edit_dist};
               	max_hits=${max_hits};
               	speed=${speed};
               	annotation=${annotation};
            	option1=${option1};
                option2=${option2};
                reference=${reference};
                segment=${segment};


speedy=`echo ${speed} | sed 's/X/-/g'`; 
#command1="$command1 $speedy";
ref=$(basename ${reference})
annotate=$(basename ${annotation})


command1=''
if [[ -n "${anchor}" ]] ;
then
command1="$command1 -a $anchor"
fi
if [[ -n "${mismatch}" ]] ;
then
command1="$command1 -N $mismatch"
fi
if [[ -n "${edit_dist}" ]] ;
then
command1="$command1 --read-edit-dist $edit_dist"
fi
if [[ -n "${max_intron}" ]] ;
then
command1="$command1 -I $max_intron"
fi
if [[ -n "${min_intron}" ]] ;
then
command1="$command1 -i $min_intron"
fi
if [[ -n "${max_hits}" ]] ;
then
command1="$command1 -g $max_hits"
fi
if [[ -n "${speed}" ]] ;
then
command1="$command1 $speedy"
fi
if [[ -n "${annotate}" ]] ;
then
command1="$command1 -G $annotate"
fi
if [[ -n "${segment}" ]] ;
then
command1="$command1 --segment-length $segment"
fi
if [[ -n "${option1}" ]] ;
then
command1="$command1 $option1"
fi
if [[ -n "${option2}" ]] ;
then
command1="$command1 $option2"
fi

if [ -e HTProcess_Reads_T1 ];
then 
mv HTProcess_Reads_T1 HTProcess_Reads
fi
if [ -e HTProcess_Reads_T2 ];
then 
mv HTProcess_Reads_T2 HTProcess_Reads
fi
cp HTProcess_Reads/manifest_file.txt ./
#mv HTProcess_Reads HTProcess_Reads1
mkdir HTProcess_BAM
mkdir intermediate_files
cp manifest_file.txt HTProcess_BAM/
cp HTProcess_Reads/HTProcess.log HTProcess_BAM/
echo "......................................................" >>HTProcess_BAM/HTProcess.log
echo "......................................................" >> HTProcess_BAM/manifest_file.txt
echo "" >> HTProcess_BAM/manifest_file.txt
echo "" >> HTProcess_BAM/manifest_file.txt
if [[ -r $ref ]] ;
then
echo "......................................................" >> HTProcess_BAM/manifest_file.txt
echo "!!!Reference-Sequence-is-Defined!!!" >> HTProcess_BAM/manifest_file.txt
echo "!RRR $reference" >> HTProcess_BAM/manifest_file.txt
echo "......................................................" >> HTProcess_Reads/manifest_file.txt
index=`echo $ref | sed 's/.fa//'`
bowtie2-build $ref $index
wait
fi
echo "" >> HTProcess_BAM/manifest_file.txt
echo "!!!Tophat Output BAM files!!!" >> HTProcess_BAM/manifest_file.txt
echo "......................................................" >> HTProcess_BAM/manifest_file.txt
echo "HTPROCESS Tophat is starting `date`" >> HTProcess_BAM/HTProcess.log


fred=`grep -m 1 'encoding' manifest_file.txt | sed s/encoding.*\=//`
if [[ $fred == 1.5 ]];
then
Fred='--phred64-quals' 
fi
if [[ $fred == 1.9 ]];
then
Fred=''
fi
command1="$command1 $Fred"

pr_space=`grep 'pair_spacing' manifest_file.txt | sed s/pair_spacing\=//`
readlen=`grep 'library_max' manifest_file.txt | sed s/library_max\=//`
read2x="$(expr 2 \* $readlen)"
inner_space="$(expr $pr_space \- $read2x)"
command2="$command1 -r $inner_space"

pair_sd=`grep 'pair_sd' manifest_file.txt | sed s/pair_sd\=//`
command2="$command2 --mate-std-dev $pair_sd"

echo "Tophat alignment of paired reads is starting `date`" >> HTProcess_BAM/HTProcess.log
count=`grep -c '!TRIMMED_Pr' manifest_file.txt`
Library_name=`grep 'Library_name' manifest_file.txt | sed 's/Library_name//' | sed 's/\=//'`
condition=`grep 'condition' manifest_file.txt | sed 's/condition//' | sed 's/\=//'`
#let twocount="2 * $count"
array=(`grep '!TRIMMED_Pr' manifest_file.txt | sed 's/!TRIMMED_Pr//'`);

for ((i = 0; i < "$count"; i += 1));
do
#let j="$i + 1"
read1=`echo "${array[$i]}" | sed 's/,.*//'`
read2=`echo "${array[$i]}" | sed 's/.*,//'`
bamoutp=`echo $read1`
newname="$bamoutp"'.bam'
pr_output="$bamoutp"'_pr_output'
command3="$command2 -o $pr_output"
echo "read1 equals $read1" >> HTProcess_BAM/HTProcess.log
echo "read2 equals $read2" >> HTProcess_BAM/HTProcess.log
tophat2 -p 8 $command3 $index HTProcess_Reads/$read1 HTProcess_Reads/$read2
#tophat --mate-inner-dist 50 --library-type fr-unstranded --min-anchor-length 8 --splice-mismatches 0 --min-intron-length 70 
#--max-intron-length 50000 --min-isoform-fraction 0.15 --max-multihits 20 --min-segment-intron 50 --max-segment-intron 500000 
#--segment-mismatches 2 --segment-length 20 --num-threads 6 --b2-sensitive genome HTProcess_Reads/TrmPr1_SRR071794_1.fastq 
#HTProcess_Reads/TrmPr2_SRR071794_2.fastq
#>prep_reads:
echo "command: tophat2 -p 8 $command2 $index HTProcess_Reads/$read1 HTProcess_Reads/$read2" >> HTProcess_BAM/HTProcess.log
wait
mv $pr_output/accepted_hits.bam HTProcess_BAM/$newname
mv $pr_output intermediate_files/
echo "!!BAM_file $newname" >> HTProcess_BAM/manifest_file.txt
done
echo "Finished aligning paired reads files." >> HTProcess_BAM/HTProcess.log

#SINGLES

echo "Tophat alignment of single reads is starting `date`" >> HTProcess_BAM/HTProcess.log
#arrayS=(`grep '!TRIMMED_Pr' manifest_file.txt | sed 's/!TRIMMED_Pr//'`);

#readS=`echo "${arrayz[$j]}" | sed 's/,.*//'`
singlename='TrmS_'"$Library_name"
bamsingle="$singlename"'.bam'
outsingle="$singlename"'_s_output'
echo "readS equals 'TrmS_'$Library_name'.fastq'" >> HTProcess_BAM/HTProcess.log
commandS="$command1 -o $outsingle"
tophat2 -p 8 $commandS $index HTProcess_Reads/'TrmS_'"$Library_name"'.fastq'
echo "command: ""tophat2 -p 8 $commandS $index HTProcess_Reads/"'TrmS_'"$Library_name"'.fastq'>> HTProcess_BAM/HTProcess.log
wait
mv $outsingle/accepted_hits.bam HTProcess_BAM/$bamsingle
mv $outsingle intermediate_files/
echo "!!BAM_file $bamsingle" >> HTProcess_BAM/manifest_file.txt
header_bam=`ls HTProcess_BAM/* | grep .bam -m 1`
#cp $header_bam 'header.bam'
bam_count=`ls HTProcess_BAM/ | grep -c bam -`
if [[ $bam_count > 1 ]]; 
cp $header_bam 'header.bam'
then
samtools view -H -o header.sam header.bam
samtools cat -h "header.sam" -o "$Library_name"'_cat.bam' HTProcess_BAM/*.bam
fi
if [[ $bam_count == 1 ]];
then
cp HTProcess_BAM/$bamsingle "$Library_name"'_cat.bam'
fi
samtools sort -m 2G "$Library_name"'_cat.bam' "$Library_name"'_cat_srt'
rm "$Library_name"'_cat.bam'
#samtools view -h "$Library_name"'_cat_srt.bam' >> "$Library_name"'_cat_srt.sam'
rm header.bam
echo "" >> HTProcess_BAM/manifest_file.txt
echo "......................................................" >> HTProcess_BAM/manifest_file.txt
echo "!!! Concatenated BAM File !!!" >> HTProcess_BAM/manifest_file.txt
echo "......................................................" >> HTProcess_BAM/manifest_file.txt
echo "!!!MergedBAM $Library_name"'_cat_srt.bam' >> HTProcess_BAM/manifest_file.txt
#echo "!!!Merged-SAM $Library_name"'_cat.sam' >> HTProcess_BAM/manifest_file.txt
echo "The concatenated BAM files have been created." >> HTProcess_BAM/HTProcess.log
mv "$Library_name"'_cat_srt.bam' HTProcess_BAM/
#mv "$Library_name"'_cat_srt.sam' HTProcess_BAM/

#Orphans

echo "......................................................" >> HTProcess_BAM/manifest_file.txt
echo "" >> HTProcess_BAM/manifest_file.txt
echo "" >> HTProcess_BAM/manifest_file.txt
echo "......................................................" >> HTProcess_BAM/manifest_file.txt
echo "!!!BAM Files for ORPHAN AND INDIVIDUAL SINGLES!!!" >> HTProcess_BAM/manifest_file.txt
echo "......................................................" >> HTProcess_BAM/manifest_file.txt
echo "The orphan and separate single read files are being mapped with Tophat in case you want to use the individual BAM 
files." >> HTProcess_BAM/HTProcess.log
cnt=`grep -c '!TRIMMED_OS' manifest_file.txt`
arrayz=(`grep '!TRIMMED_OS' manifest_file.txt | sed 's/!TRIMMED_OS//'`);
for ((i = 0; i < "$cnt"; i += 1));
do
readOS=`echo "${arrayz[$i]}"`
Osinglename="$readOS"
Obamsingle="$Osinglename"'.bam'
Outsingle="$Osinglename"'_s_output'
echo "readOS equals $readOS" >> HTProcess_Reads/HTProcess.log
commandOS="$command1 -o $Outsingle"
tophat2 -p 8 $commandOS $index HTProcess_Reads/$readOS
echo "command: tophat2 -p 8 $commandOS $index HTProcess_BAM/$readOS" >> HTProcess_BAM/HTProcess.log
wait
mv $Outsingle/accepted_hits.bam HTProcess_BAM/$Obamsingle
mv $Outsingle intermediate_files/
echo "!!OSBAM-file $Obamsingle" >> HTProcess_BAM/manifest_file.txt
done
echo "Finished aligning unpaired reads files." >> HTProcess_BAM/HTProcess.log

mv header.sam intermediate_files/
rm -r HTProcess_Reads
rm -r bowtie2-2.2.4
rm -r tophat-2.0.13.Linux_x86_64
rm $annotate
rm $ref
rm manifest_file.txt
echo "HTProcess Tophat is finished `date`" >> HTProcess_BAM/HTProcess.log
mv HTProcess_BAM HTProcess_BAM'_'"$condition"
mv *.bt2 intermediate_files
