#!/bin/bash

#SBATCH -N 3
#SBATCH -n 48

tar xvzf jellyfish-2.0.0.tar.gz
jellyfish-2.0.0/configure
make

#PATH=$PATH:./jellyfish-2.0.0/bin
#chmod a+x ./jellyfish-2.0.0/bin/*
#chmod a+x ./jellyfish-2.0.0/*

INPUTS=$(basename ${Input_Dir})
kmer1="${kmer1}"
kmer2="${kmer2}"
kmer3="${kmer3}"

y=''

rm "${INPUTS}"/manifest_file.txt
mv "${INPUTS}"/HTProcess.log ./

bin/jellyfish count -m "${kmer1}" -s 1000000000 -t 45 -o 'jelly'"${kmer1}" "${INPUTS}"/*
bin/jellyfish histo 'jelly'"${kmer1}"* -t 45 -o 'jellyhistoA'

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
	bin/jellyfish count -m "${kmer2}" -s 1000000000 -t 45 -o 'jelly'"${kmer2}" "${INPUTS}"/*
	bin/jellyfish histo 'jelly'"${kmer2}"* -t 45 -o 'jellyhistoB'
	
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
	bin/jellyfish count -m "${kmer3}" -s 1000000000 -t 45 -o 'jelly'"${kmer3}" "${INPUTS}"/*
	bin/jellyfish histo 'jelly'"${kmer3}"* -t 45 -o 'jellyhistoC'
	
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

rm -r bin  config.h  config.log  config.status  jellyfish  jellyfish-2.0.0  jellyfish-2.0.0.tar.gz  jellyfish-2.0.pc	lib  libjellyfish-2.0.la  libtool  Makefile  stamp-h1  sub_commands  tests  unit_tests
	


echo "Starting creation of summary file for Jellyfish Results"

	echo '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Strict//EN">' > jellyfish_summary.html
	echo '<html' >> jellyfish_summary.html
	echo '<head><title>Summary of Jellyfish Reports</title>' >> jellyfish_summary.html
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
	echo "Jellyfish has been run on all input sequencing files." >> HTProcess.log
	
	mkdir intermediate_files
	mv jelly* intermediate_files/
	mv rplot* intermediate_files/
	mv intermediate_files/jellyfish_summary.html ./
	rm -r -d .libs

