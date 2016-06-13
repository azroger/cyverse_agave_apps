#!/bin/bash

#$ -V                    #Inherit the submission environment

#$ -cwd                  # Start job in submission directory

#$ -N jellytest2       # Job Name

#$ -A iPlant-Collabs

#$ -j y                  # Combine stderr and stdout

#$ -o $JOB_NAME.o$JOB_ID # Name of the output file (eg. myMPI.oJobID)

#$ -pe 12way 24          # Requests 12 tasks/node, 24 cores total (16 now)

#$ -q development                  # Queue name "normal"

#$ -l h_rt=1:00:00      # Run time (hh:mm:ss) - 1.5 hours (8 hrs now)

#$ -M rogerab@email.arizona.edu                   # Use email notification address

#$ -m be                 # Email at Begin and End of job

set -x                   # Echo commands, use "set echo" with csh



#source ~/.profile_user
module swap intel gcc/4.4.5
module load iRODS
module load R

iget /iplant/home/rogerab/applications/jellyfish2/bin/jellyfish

Input_Dir="/iplant/home/rogerab/testfiles/BAreads"
iget -r "${Input_Dir}"
INPUTS=$(basename ${Input_Dir})
kmer1="25"
kmer2="29"
kmer3="35"

# Input_Dir="${Input_files}"
# kmer1="${kmer1}"
# kmer2="${kmer2}"
# kmer3="${kmer3}"

y=''

jellyfish count -m "${kmer1}" -s 1000000000 -t 23 -o 'jelly'"${kmer1}" "${INPUTS}"/*
jellyfish histo 'jelly'"${kmer1}"* -t 23 -o 'jellyhistoA'

touch jellyfish.r
echo 'dat=read.table("jellyhistoA")' > jellyfish.r
name="$kmer1"_1
echo "png('rplot$name.png')" >> jellyfish.r
echo 'barplot(dat[,2], xlim=c(0,75), ylim=c(0,1e7), ylab="No of kmers", xlab="Counts of a k-mer", names.arg=dat[,1], cex.names=0.8)' >> jellyfish.r
echo 'dev.off()' >> jellyfish.r
echo 'q()' >> jellyfish.r
echo 'n' >> jellyfish.r
R --vanilla -q < jellyfish.r
openssl base64 -in rplot$name.png -out rplot$name.b64

echo 'dat=read.table("jellyhistoA")' > jellyfish.r
name="$kmer1"_2
echo "png('rplot$name.png')" >> jellyfish.r
echo 'barplot(dat[,2], xlim=c(0,75), ylim=c(0,5e8), ylab="No of kmers", xlab="Counts of a k-mer", names.arg=dat[,1], cex.names=0.8)' >> jellyfish.r
echo 'dev.off()' >> jellyfish.r
echo 'q()' >> jellyfish.r
echo 'n' >> jellyfish.r
R --vanilla -q < jellyfish.r
openssl base64 -in rplot$name.png -out rplot$name.b64

echo 'dat=read.table("jellyhistoA")' > jellyfish.r
name="$kmer1"_3
echo "png('rplot$name.png')" >> jellyfish.r
echo 'barplot(dat[,2], xlim=c(0,75), ylim=c(0,1e10), ylab="No of kmers", xlab="Counts of a k-mer", names.arg=dat[,1], cex.names=0.8)' >> jellyfish.r
echo 'dev.off()' >> jellyfish.r
echo 'q()' >> jellyfish.r
echo 'n' >> jellyfish.r
R --vanilla -q < jellyfish.r
openssl base64 -in rplot$name.png -out rplot$name.b64


	if [[ -n $kmer2 ]];
	then
	jellyfish count -m "${kmer2}" -s 1000000000 -t 23 -o 'jelly'"${kmer2}" "${INPUTS}"/*
	jellyfish histo 'jelly'"${kmer2}"* -t 23 -o 'jellyhistoB'
	
echo 'dat=read.table("jellyhistoB")' > jellyfish.r
name="$kmer2"_1
echo "png('rplot$name.png')" >> jellyfish.r
echo 'barplot(dat[,2], xlim=c(0,75), ylim=c(0,1e7), ylab="No of kmers", xlab="Counts of a k-mer", names.arg=dat[,1], cex.names=0.8)' >> jellyfish.r
echo 'dev.off()' >> jellyfish.r
echo 'q()' >> jellyfish.r
echo 'n' >> jellyfish.r
R --vanilla -q < jellyfish.r
openssl base64 -in rplot$name.png -out rplot$name.b64

echo 'dat=read.table("jellyhistoB")' > jellyfish.r
name="$kmer2"_2
echo "png('rplot$name.png')" >> jellyfish.r
echo 'barplot(dat[,2], xlim=c(0,75), ylim=c(0,5e8), ylab="No of kmers", xlab="Counts of a k-mer", names.arg=dat[,1], cex.names=0.8)' >> jellyfish.r
echo 'dev.off()' >> jellyfish.r
echo 'q()' >> jellyfish.r
echo 'n' >> jellyfish.r
R --vanilla -q < jellyfish.r
openssl base64 -in rplot$name.png -out rplot$name.b64

echo 'dat=read.table("jellyhistoB")' > jellyfish.r
name="$kmer2"_3
echo "png('rplot$name.png')" >> jellyfish.r
echo 'barplot(dat[,2], xlim=c(0,75), ylim=c(0,1e10), ylab="No of kmers", xlab="Counts of a k-mer", names.arg=dat[,1], cex.names=0.8)' >> jellyfish.r
echo 'dev.off()' >> jellyfish.r
echo 'q()' >> jellyfish.r
echo 'n' >> jellyfish.r
R --vanilla -q < jellyfish.r
openssl base64 -in rplot$name.png -out rplot$name.b64
fi

	if [[ -n $kmer3 ]];
	then
	jellyfish count -m "${kmer3}" -s 1000000000 -t 23 -o 'jelly'"${kmer3}" "${INPUTS}"/*
	jellyfish histo 'jelly'"${kmer3}"* -t 23 -o 'jellyhistoC'
	
echo 'dat=read.table("jellyhistoC")' > jellyfish.r
name="$kmer3"_1
echo "png('rplot$name.png')" >> jellyfish.r
echo 'barplot(dat[,2], xlim=c(0,75), ylim=c(0,1e7), ylab="No of kmers", xlab="Counts of a k-mer", names.arg=dat[,1], cex.names=0.8)' >> jellyfish.r
echo 'dev.off()' >> jellyfish.r
echo 'q()' >> jellyfish.r
echo 'n' >> jellyfish.r
R --vanilla -q < jellyfish.r
openssl base64 -in rplot$name.png -out rplot$name.b64

echo 'dat=read.table("jellyhistoC")' > jellyfish.r
name="$kmer3"_2
echo "png('rplot$name.png')" >> jellyfish.r
echo 'barplot(dat[,2], xlim=c(0,75), ylim=c(0,5e8), ylab="No of kmers", xlab="Counts of a k-mer", names.arg=dat[,1], cex.names=0.8)' >> jellyfish.r
echo 'dev.off()' >> jellyfish.r
echo 'q()' >> jellyfish.r
echo 'n' >> jellyfish.r
R --vanilla -q < jellyfish.r
openssl base64 -in rplot$name.png -out rplot$name.b64

echo 'dat=read.table("jellyhistoC")' > jellyfish.r
name="$kmer3"_3
echo "png('rplot$name.png')" >> jellyfish.r
echo 'barplot(dat[,2], xlim=c(0,75), ylim=c(0,1e10), ylab="No of kmers", xlab="Counts of a k-mer", names.arg=dat[,1], cex.names=0.8)' >> jellyfish.r
echo 'dev.off()' >> jellyfish.r
echo 'q()' >> jellyfish.r
echo 'n' >> jellyfish.r
R --vanilla -q < jellyfish.r
openssl base64 -in rplot$name.png -out rplot$name.b64
fi

echo "Starting creation of summary file for Jellyfish Results"

	echo '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Strict//EN">' > jellyfish_summary.html
	echo '<html' >> jellyfish_summary.html
	echo '<head><title>Summary of Fastqc Reports</title>' >> jellyfish_summary.html
	echo '<style type="text/css">' >> jellyfish_summary.html
	echo '	body { font-family: sans-serif; color: #0098aa; background-color: #FFF; font-size: 100%; border: 0; margin: 0; padding: 0; }' >> jellyfish_summary.html
	echo '	h1 { font-family: sans-serif; color: #0098aa; background-color: #FFF; font-size: 300%; font-weight: bold; border: 0; margin: 0; padding: 0; }' >> jellyfish_summary.html
	echo '	h2 { font-family: sans-serif; color: #0098aa; background-color: #FFF; font-size: 200%; font-weight: bold; border: 0; margin: 0; padding: 0; }' >> jellyfish_summary.html	
	echo '	h3 { font-family: sans-serif; color: #0098aa; background-color: #FFF; font-size: 40%; font-weight: bold; border: 0; margin: 0; padding: 0; }' >> jellyfish_summary.html
	echo '	.TFtable tr:nth-child(even){ background: #D2DADC; }' >> jellyfish_summary.html	
	echo '	</style>' >> jellyfish_summary.html
	echo '	</head>' >> jellyfish_summary.html
	echo '	<h1> Summary of Jellyfish Results </h1>' >> jellyfish_summary.html
	echo '	<br/>' >> jellyfish_summary.html
	echo '	<br/>' >> jellyfish_summary.html
	echo '	<br/>' >> jellyfish_summary.html
	echo '	<body> ' >> jellyfish_summary.html
	echo '	<table border="1" cellpadding="10" bgcolor="white" class="TFtable">' >> jellyfish_summary.html
	echo '	<tr>' >> jellyfish_summary.html
	echo '	<td><b>Kmer Value</b></td>' >> jellyfish_summary.html
	echo '    <td><b>Max = 1e7 </b></td>' >> jellyfish_summary.html
	echo '    <td><b>Max = 5e8 </b></td>' >> jellyfish_summary.html
	echo '    <td><b>Max = 1e10 </b></td>' >> jellyfish_summary.html
	echo ' </tr>' >> jellyfish_summary.html

 	echo ' <tr>' >> jellyfish_summary.html
 	echo ' <td><b>kmer='"$kmer1"' </b></td>' >> jellyfish_summary.html
 	
	for ((RR=1; RR < 4; RR += 1))
	do
	name="rplot""$kmer1"_"$RR"'.b64'
	image=`cat $name`
	graphcontent="<h3 id=$name >"'<li><img src="data:image/png;base64,'"$image"'"</li></h3>'
	echo "	<td><b>$graphcontent</b></td>" >> jellyfish_summary.html	
	done
	echo '	<br/>' >> jellyfish_summary.html
	echo ' </tr>' >> jellyfish_summary.html
		if [[ -n $kmer2 ]];
		then
		echo ' <tr>' >> jellyfish_summary.html
 		echo ' <td><b>kmer='"$kmer2"' </b></td>' >> jellyfish_summary.html
 	
		for ((SS=1; SS < 4; SS += 1))
		do
		name="rplot""$kmer2"_"$SS"'.b64'
	image=`cat $name`
	graphcontent="<h3 id=$name >"'<li><img src="data:image/png;base64,'"$image"'"</li></h3>'
		echo "	<td><b>$graphcontent</b></td>" >> jellyfish_summary.html	
		done
		echo '	<br/>' >> jellyfish_summary.html
		echo ' </tr>' >> jellyfish_summary.html
		fi
		if [[ -n $kmer3 ]];
		then
		echo ' <tr>' >> jellyfish_summary.html
 		echo ' <td><b>kmer='"$kmer3"' </b></td>' >> jellyfish_summary.html
 	
		for ((TT=1; TT < 4; TT += 1))
		do
		name="rplot""$kmer3"_"$TT"'.b64'
	image=`cat $name`
	graphcontent="<h3 id=$name >"'<li><img src="data:image/png;base64,'"$image"'"</li></h3>'
		echo "	<td><b>$graphcontent</b></td>" >> jellyfish_summary.html
		done
		echo '	<br/>' >> jellyfish_summary.html
		echo ' </tr>' >> jellyfish_summary.html
		fi
	echo '</table>' >> jellyfish_summary.html					
	echo '</body>' >> jellyfish_summary.html
	echo '</html' >> jellyfish_summary.html
	
	echo "The summary file for Jellyfish has been created."



