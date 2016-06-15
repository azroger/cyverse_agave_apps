#!/bin/bash

# start a watch process on shmem so we know if we blow our RAM Disk capacity.
chmod +x shmem_watch.sh
./shmem_watch.sh &
SHMEM_WATCH_PID=$$

# Path stuff
export CWD=${PWD}

cd /dev/shm

# Empty args string
ARGS=""

LEFT_IN=${left}
RIGHT_IN=${right}
SINGLE_IN=${single}

# Trinity options
#
# Inputs
# Handle paired-end invocation
if [ -n "${LEFT_IN}" ] && [ -n "${RIGHT_IN}" ]
then

	LEFT_IN_F=$(basename ${LEFT_IN})
	RIGHT_IN_F=$(basename ${RIGHT_IN})
	LEFT_IN_F="$CWD/$LEFT_IN_F"
	RIGHT_IN_F="$CWD/$RIGHT_IN_F"
	ARGS="$ARGS --left ${LEFT_IN_F} --right ${RIGHT_IN_F}"
fi
# Handle single-end invocation
if [ -n "${SINGLE_IN}" ]
then
	SINGLE_IN_F=$(basename ${SINGLE_IN})
	SINGLE_IN_F="$CWD/$SINGLE_IN_F"
	ARGS="$ARGS --single ${SINGLE_IN_F}"
fi
# Params
# seqType
ARGS="$ARGS --seqType ${seqType} --JM 384G"


# Boolean jaccard_clip
if [ "${jaccard_clip}" == "1" ]; then ARGS="$ARGS --jaccard_clip"; fi
# Optional strand-specific type
if [ -n "${SS_lib_type}" ]; then ARGS="$ARGS --SS_lib_type ${SS_lib_type}"; fi
# CPUs
ARGS="$ARGS --CPU 30"

# Inchworm options
if [ -n "${min_kmer_cov}" ]; then ARGS="$ARGS --min_kmer_cov ${min_kmer_cov}"; fi
if [ -n "${min_contig_length}" ]; then ARGS="$ARGS --min_contig_length ${min_contig_length}"; fi
# meryl_opts  not supported yet

# Chrysalis options
if [ -n "${min_glue}" ]; then ARGS="$ARGS --min_glue ${min_glue}"; fi
if [ -n "${min_iso_ratio}" ]; then ARGS="$ARGS --min_iso_ratio ${min_iso_ratio}"; fi
if [ -n "${glue_factor}" ]; then ARGS="$ARGS --glue_factor ${glue_factor}"; fi
if [ -n "${max_reads_per_graph}" ]; then ARGS="$ARGS --max_reads_per_graph ${max_reads_per_graph}"; fi
if [ -n "${max_reads_per_loop}" ]; then ARGS="$ARGS --max_reads_per_loop  ${max_reads_per_loop}"; fi
if [ -n "${min_pct_read_mapping}" ]; then ARGS="$ARGS --min_pct_read_mapping ${min_pct_read_mapping}"; fi

# Butterfly options
if [ -n "${max_number_of_paths_per_node}" ]; then ARGS="$ARGS --max_number_of_paths_per_node ${max_number_of_paths_per_node}"; fi
if [ -n "${group_pairs_distance}" ]; then ARGS="$ARGS --group_pairs_distance ${group_pairs_distance}"; fi
if [ -n "${path_reinforcement_distance}" ]; then ARGS="$ARGS --path_reinforcement_distance ${path_reinforcement_distance}"; fi
if [ -n "${path_reinforcement_distance}" ]; then ARGS="$ARGS --path_reinforcement_distance ${path_reinforcement_distance}"; fi
if [ "${lenient_path_extension}" == "1" ]; then ARGS="$ARGS --lenient_path_extension"; fi
if [ "${no_triplet_lock}" == "0" ]; then ARGS="$ARGS --triplet_lock"; fi

# Learned this from IU NCGAS. /dev/shm on largemem has a sustained write of 1.4 GB/s
# as opposed to 250-300 MB/s for WORK or SCRATCH
# Since Trinity is IO bound, this should speed things up by quite a bit
#
OUTPUT=/dev/shm/trinity_out
#OUTPUT=$CWD/MYASSEMBLY/trinity_out
ARGS="$ARGS --output $OUTPUT --bflyHeapSpaceMax 36G --bflyHeapSpaceInit 4G --bflyCPU 30 --bflyGCThreads 16"

echo "**********************************************"
echo "Local environment before running Trinity.pl "
echo "**********************************************"
echo "original directory: $CWD"
echo ""
echo "listing trinity_out directory in pwd"
ls trinity_out
echo ""
echo "listing parent directory of trinity_out"
ls -l trinity_out/..
echo ""
echo "pwd: $(pwd)"
echo ""
echo "Disk utilization for /dev/shm"
df /dev/shm
echo ""
echo "Disk usage for /dev/shm:"
du -h --max-depth=1 /dev/shm
echo ""
echo ""
echo "**********************************************"

time Trinity.pl $ARGS

echo "**********************************************"
echo "Local environment after running Trinity.pl "
echo "**********************************************"
echo "original directory: $CWD"
echo ""
echo "listing trinity_out directory in pwd"
ls trinity_out
echo ""
echo "listing parent directory of trinity_out"
ls -l trinity_out/..
echo ""
echo "pwd: $(pwd)"
echo ""
echo "Disk utilization for /dev/shm"
df /dev/shm
echo ""
echo "Disk usage for /dev/shm:"
du -h --max-depth=1 /dev/shm
echo ""
echo ""
echo "**********************************************"

# The $OUTPUT directory contains literally
# tens of thousands of files. This is good
# because it contains checkpointing data
# and a lot of data that can be mined. But
# it's terrible for transmitting back to the
# mothership iRODS store. So, I make a small
# concession. Copy Trinity.fasta out of that
# directory, then tar up $OUTPUT and send it
# instead of the directory. User can untar the
# result and operate on it as expected

echo "**********************************************"
echo "Copying fasta file to $CWD:"
echo "**********************************************"
if [[ -e trinity_out/Trinity.fasta ]]; then
	echo "Found file in relative trinity_out folder"
	cp trinity_out/Trinity.fasta $CWD/
	echo ""
elif [[ -e /dev/shm/trinity_out/Trinity.fasta ]]; then
	echo "could not find file in relative trinity_out folder. specifying /dev/shm/trinity_out/Trinity.fasta"
	cp /dev/shm/trinity_out/Trinity.fasta $CWD/
	echo ""
else
	echo "Cannot find the trinity_out/Trinity.fasta file in pwd or in /dev/shm"
	echo "original directory: $CWD"
	echo ""
	echo "listing trinity_out directory in pwd"
	ls trinity_out
	echo ""
	echo "listing parent directory of trinity_out"
	ls -l trinity_out/..
	echo ""
	echo "pwd: $(pwd)"
	echo ""
	echo "Disk utilization for /dev/shm"
	df /dev/shm
	echo ""
	echo "Disk usage for /dev/shm:"
	du -h --max-depth=1 /dev/shm
	echo ""
	echo ""
fi

echo "**********************************************"
echo "Compressing the output folder:"
echo "**********************************************"
# why is the fasta file being included in the tarball and the output directory
# seems like we can just exclude it from the tarball
if [[ -e trinity_out ]]; then
	echo "Found trinity_out folder in pwd"
	#tar --exclude=Trinity.fasta -cvzf $CWD/trinity_out.tar.gz trinity_out
	tar -cvzf $CWD/trinity_out.tar.gz trinity_out
	echo ""
elif [[ -e /dev/shm/trinity_out ]]; then
	echo "Cound not find trinity_out in pwd. Using /dev/shm/trinity_out instead."
	#tar --exclude=Trinity.fasta -cvzf $CWD/trinity_out.tar.gz /dev/shm/trinity_out
	tar -czf $CWD/trinity_out.tar.gz /dev/shm/trinity_out
	echo ""
else
	echo "Cannot find the trinity_out folder in pwd or in /dev/shm"
	echo "original directory: $CWD"
	echo ""
	echo "listing trinity_out directory in pwd"
	ls trinity_out
	echo ""
	echo "listing parent directory of trinity_out"
	ls -l trinity_out/..
	echo ""
	echo "pwd: $(pwd)"
	echo ""
	echo "Disk utilization for /dev/shm"
	df /dev/shm
	echo ""
	echo "Disk usage for /dev/shm:"
	du -h --max-depth=1 /dev/shm
	echo ""
	echo ""
fi
echo "**********************************************"

echo ""
echo ""
echo "**********************************************"
echo "Killing shmem watch process"
echo "**********************************************"
echo "Killing pid $SHMEM_WATCH_PID"
# kill the background memory watch process
kill $SHMEM_WATCH_PID
echo "**********************************************"

# what are you waiting for? There are no background or pending processes, so this
# does nothing
#wait

echo ""
echo ""
echo "**********************************************"
echo "Cleaning up work directory"
echo "**********************************************"
echo "Deleting shmem directory ${OUTPUT} "
# clean up
rm -rf ${OUTPUT}
cd $CWD
echo "Done cleaning up"
ls -al
date
echo "**********************************************"

# Agave will clean up during archive. If the job isn't archived, you will want
# these inputs left in place to debug.
#rm -f ${LEFT_IN_F}  ${RIGHT_IN_F}  ${SINGLE_IN_F}

# Matthew W. Vaughn, Ph.D.,
# Manager, Life Sciences Computing Group
# Texas Advanced Computing Center
# Austin, TX
# vaughn@tacc.utexas.edu | (949) 436-6642
# Ported to iPlant Agave API by Roger Barthelson rogerab@email.arizona.edu
