# no #!/bin/bash directive

# Constraints:
#	* must not use the single word 'c o m m a n d' (no spaces); post-processing substitutes token
# 	* must not exit(); post-processing statements are inserted
#	* must write all output files to "this" directory (no subdirectories)
#	* must set executable permissions on any executables copied via iget
#	* API does not support output ids

# run a cmd with 'arguments,' 'stdin,' 'stdout,' and 'stderr'
# and other variables passed in from the environment

# the cmd and module loading is hard-coded here:
cmd=clustalw2
prog=`basename $cmd`
# modules should be preloaded
# module load irods
# module load clustalw2/2.1

error() {
	echo "$0: $1" >&2
	return 1
}

filter() {

	# we'll not allow certain characters
	# this is not offered as tight security; just a catch on disallowed chars

	# must contain at least one of these chars ...
	expr "$1" : '.*[[:alnum:]_./=+-].*' >/dev/null || { error "input does not contain a single valid character; job rejected"; return 1; }

	# ... and only these chars
	expr "$1" : '.*[^[:alnum:][:space:]_./=+-].*' >/dev/null && { error "invalid characters in input; job rejected"; return 1; }

	return 0
}
format="${format}"
T="${T}"
outname="${outname}"
arguments="${arguments}"
options="-OUTPUT=${format} -TYPE=$T -OUTFILE=${outname}" 
main() {

	# tighten the environment
	set -f	# noglob: no filename expansion

	# set the arguments
	if [ -n "$arguments" ]
	then
		filter "$arguments" || return 1
		arguments="${arguments}"
	fi
#arguments="$arguments $format $T $outname"

 
	# insert these options
	# should be set as default values in apps.json
	#arguments="-OUTPUT=FASTA -OUTORDER=ALIGNED $arguments"

	# set the input
	if [ -n "${inputFasta}" ]
	then
		filter "${inputFasta}" || return 1

		# use irods to get the data from the source into "this" staging area;
		# file name must start with irods root: e.g., /iplant/home/;
		# local copy has appended process id for corner case where input file
		# is same name as the output file name
		localInput="$(basename ${inputFasta})"
		
    #		iget -fIT "${stdin}" "$localInput"

		# bail on failure to stage local copy of input file
		test -r "$localInput" || { error "no input file in staging area; job failed"; return 1; }
		stdinStr="-INFILE=$localInput"
	else
		error "$prog requires an input file; none specified"; return 1
	fi

	# set the output
	# not supported by API; hard-code and coord w/ RDG
#	stdout=clustalw2.fa

# 	if [ -n "${stdout}" ]
# 	then
# 		filter "${stdout}" || return 1
# 		stdoutStr="-OUTFILE=${stdout} >$prog.$$.out"
# 	else
# 		stdoutStr="-OUTFILE=clustalw2.fa >$prog.$$.out"
# 	fi

	# set the error stream
	if [ -n "${stderr}" ]
	then
		filter "${stderr}" || return 1
		stderrStr="2>${stderr}"
	else
		stderrStr="2>$prog.$$.err"
	fi

	# echo cmd string to this script's stdout (but not the program's redirection, if any)
	set -x	# xtrace: print expansions

	# execute the cmd
	eval $cmd $stdinStr $options $arguments $stderrStr
	return $?
}

main
