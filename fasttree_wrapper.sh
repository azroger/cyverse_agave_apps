# no #!/bin/bash directive

# Constraints:
#	* must not use the single word 'c o m m a n d' (no spaces); post-processing substitutes token
# 	* must not exit(); post-processing statements are inserted
#	* must write all output files to "this" directory (no subdirectories)
#	* must set executable permissions on any executables copied via iget
#	* API does not support output ids

# run a cmd with 'arguments,' 'stdin,' 'stdout,' and 'stderr'
# and other variables passed in from the environment

# module loading is hard-coded here:

# modules should be preloaded
# module load irods
# there is no module for fasttree; it is a binary packaged as part of the deployed zip

# set the default program version
defaultVersion=2.1.4


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

main() {

	# tighten the environment
	set -f	# noglob: no filename expansion

	# set the version
	if [ -n "${version}" ]
	then
		filter "${version}" || return 1
		version="${version}"
	else
		version=$defaultVersion
	fi

	# set the command line
	case "$version" in
		2.1.4   ) cmd=fasttree ;;
	  *       ) { error "unsupported version: $version"; return 1; } ;;
	esac

	# set program name
	prog=`basename $cmd`

	# set the arguments
	if [ -n "${arguments}" ]
	then
		filter "${arguments}" || return 1
		arguments="${arguments}"
	fi

	# insert these options
	# should be set as default values in apps.json
	#arguments=""	# no default arguments
		
	# set the input
	if [ -n "${inFasta}" ]
	then
		filter "${inFasta}" || return 1

		# use irods to get the data from the source into "this" staging area;
		# file name must start with irods root: e.g., /iplant/home/ or ? /iplant/home/<login>/;
		# local copy has appended process id for corner case where input file
		# is same name as the output file name
		localInput="$(basename ${inFasta})"
#		iget -fIT "${inFasta}" "$localInput"

		# bail on failure to stage local copy of input file
		test -r "$localInput" || { error "Where's the input file?? Job failed!"; return 1; }
		stdinStr="$localInput"
	else
		error "$prog requires an input file; none specified"; return 1
	fi

	# set the output
	# not supported by API; hard-code and coord w/ RDG
	outTree=fasttree.nwk

	if [ -n "${outTree}" ]
	then
		filter "${outTree}" || return 1
		stdoutStr=">${outTree}"
	else
		stdoutStr=">$prog.$$.out"
	fi

	# set the error stream
	if [ -n "${stderr}" ]
	then
		filter "${stderr}" || return 1
		stderrStr="2>${stderr}"
	else
		stderrStr="2>$prog.$$.err"
	fi

	# set execute permissions because they are lost on staging local executable
	chmod a+x $cmd	# no glob, so no shell expansion
	
	# echo cmd string to this script's outTree (but not the program's redirection, if any)
	set -x	# xtrace: print expansions

	# execute the cmd
	eval $cmd "${model}" $arguments $stdinStr $stdoutStr $stderrStr
	return $?
}

main
