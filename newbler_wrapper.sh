INPUT="${inputSeqs}"
OUTNAME="NewblerOut"
CPU=12
MIN_CONTIG_SIZE="${min_contig_size}"
LARGE_CONTIG_SIZE="${large_contig_size}"
OTHER="${other}"

INPUT_F=$(basename ${INPUT})

chmod a+x ./*
runAssembly -o "${OUTNAME}" -m -force -large -cpu "${CPU}" "${OTHER}" "${INPUT_F}"

