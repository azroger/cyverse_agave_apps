#!/bin/bash

export OMP_NUM_THREADS=64

 Species="${Species}"
 libfname="${libfname}"
 genomeFormat="${genomeFormat}"
 EstFormat="${EstFormat}"			#>gi| vs >name, d or D
 estSeq="${estSeq}"
 wsize="${wsize}"					#word size
 minqHSP="${minqHSP}"                 #minimum quality for HSP, HSP is highest-scoring segment pair
 minqHSPc="${minqHSPc}"				#minimum quality for HSP chains
 maxnest="${maxnest}"				#max num est alignments per genomic DNA input

minESTc="${minESTc}"	
htmlOut="${htmlOut}"				#' ' or '-h', yes or no
sgmntsze="${sgmntsze}"				#process sequence in what length segments, default is 300000+np*20000
nthreads="${nthreads}"
outPutFile=Geneseqer_Out
gffOption="${gffOption}"
##
#processors=`expr "$nthreads" / 8`
MRNASIZE=30
M=
G=
offsetA=
offsetB=
############################
# Species=Arabidopsis
# libfname=genome.fa
# EstFormat=D
# genomeFormat=L
# estSeq=transcripts.fa
# wsize="22"
# minqHSP="33"
# minqHSPc="44"
# minESTc="0.8"
# maxnest="10000"
# nthreads=32
# outPutFile=GSQTest
# gffOption=GFF
processors=`expr "$nthreads" / 8`

chmod a+x * ;

Options=''
if [ -n "${htmlOut}" ]; then Options="$Options '-h' "; fi
if [ -n "${wsize}" ]; then Options="$Options '-x' ${wsize}"; fi
if [ -n "${minqHSP}" ]; then Options="$Options '-y' ${minqHSP}"; fi
if [ -n "${minqHSPc}" ]; then Options="$Options '-z' ${minqHSPc}"; fi
if [ -n "${minESTc}" ]; then Options="$Options '-w' ${minESTc}"; fi
if [ -n "${maxnest}" ]; then Options="$Options '-m' ${maxnest}"; fi
if [ -n "${sgmntsze}" ]; then Options="$Options '-M' ${sgmntsze}"; fi

#iget -fT "${estSeq}"
INPUT_F1=$(basename ${estSeq})
mkdir MRNADIR
mv "${INPUT_F1}" MRNADIR/
cd MRNADIR
../fastasplit.pl -i "${INPUT_F1}" -s "${MRNASIZE}"
nbmrnafiles=`ls -1 "$INPUT_F1"?* | wc -l`
M=$nbmrnafiles
##########
XYMRNA="-""${EstFormat}"
n=1
while (( $n <= $M ));
do 
XYMRNA="$XYMRNA ../../MRNADIR/$INPUT_F1$n"
 n=`expr $n + 1`
done
#############
for file in ./"$INPUT_F1"?* 
do ../MakeArray $file
done
cd ..
################
gOPTX="-""${genomeFormat}"
#iget -fT "${libfname}"
INPUT_L1=$(basename ${libfname})
GDNANUMBER=`expr "$nthreads" / 8`
#GDNANUMBER=`expr "$GDNANUMBER" - 1`
echo $GDNANUMBER
mkdir GENOME
mv "${INPUT_L1}" GENOME/
genomesize=`ls -lG GENOME/"${INPUT_L1}" | grep -oP '\d\d\d\d\d+' "-"`
#echo $genomesize
./fastasplit.pl -i GENOME/"${INPUT_L1}" -n "${GDNANUMBER}"
genomelarge=`ls -lGS GENOME/"${INPUT_L1}"?* | grep -oPm 1 '\d\d\d\d\d+'`
#echo $genomelarge
#max=$(( $genomesize x 1.005 ))
# max=$(( $genomesize / $GDNANUMBER ))
# #echo $max
# if (( $genomelarge >= $max )); 
# then
# #echo "too big"
# ERASE="rm GENOME/"${INPUT_L1}?*" ";
# $ERASE ;
# GDNANUMBER=`expr $GDNANUMBER - 2`;
# ./fastasplit.pl -i GENOME/"${INPUT_L1}" -n "${GDNANUMBER}";
# #echo $G
# fi
nbgdnafiles=`ls -1 GENOME/"$INPUT_L1"?* | wc -l`;
if (( $nbgdnafiles > $GDNANUMBER ));
then
min1=`ls -lGSr GENOME | grep -oPm 1 "${INPUT_L1}"[0-9]`
min2=`ls -lGSr GENOME | grep -v $min1 | grep -oPm 1 "${INPUT_L1}[0-9]"`
cat GENOME/$min2 > GENOME/$min1
rm GENOME/$min2
l=1
for x in GENOME/$INPUT_L1?*
do
mv -f $x GENOME/$INPUT_L1"$l"
l=`expr $l + 1`
done
fi
nbgdnafiles=`ls -1 GENOME/"$INPUT_L1"?* | wc -l`;
G="$nbgdnafiles"
offsetA=0
offsetB=8
i=1
############
mkdir GSQOUTPUT
cd GSQOUTPUT
#################
while (( $i <= $processors ));
do
#########
	GDNAFILEA="$INPUT_L1"$i
	echo "$GDNAFILEA"
	mkdir GSQOUTPUT"$i"
	cd GSQOUTPUT$i
	pwd
if (( $i <= $G ));
then
MPIRUNLINEA="ibrun -n 8 -o $offsetA ../../GeneSeqerMPI $Options -s $Species $XYMRNA -O ../"$outPutFile"_"$i" $gOPTX ../../GENOME/$GDNAFILEA"
$MPIRUNLINEA &
fi
	cd ..
	j=`expr $i + 1`
	echo $j
	mkdir GSQOUTPUT$j
	cd GSQOUTPUT$j
	pwd
	GDNAFILEB="$INPUT_L1"$j
if (( $j <= $G ));
then
MPIRUNLINEB="ibrun -n 8 -o $offsetB ../../GeneSeqerMPI $Options -s $Species $XYMRNA -O ../"$outPutFile"_"$j" $gOPTX ../../GENOME/$GDNAFILEB";
$MPIRUNLINEB &
fi
cd ..
##########################
i=`expr $i + 2`
offsetA=`expr $offsetA + 16`
offsetB=`expr $offsetB + 16`
done
wait
########################

cat "$outPutFile"_* >> $outPutFile
wait 
########################
if [ -n "${gffOption}" ]; 
then 
outputXML=""${outPutFile}"".xml"";
outputGFF=""${outPutFile}"".gff"";

perl ../GSQ2XML.pl -E -S "${outPutFile}" > "${outputXML}";

python ../gthxmlToGFF.py -t EST -i "${outputXML}" -o "${outputGFF}";
fi

 rm -r GSQOUTPUT*
 rm -r "$outPutFile"_*
 rm -r ../GENOME
 rm -r ../MRNADIR
 
