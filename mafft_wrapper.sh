#!/bin/bash


input_seq="${input_seq}"

mafft --thread -8 "$input_seq" > mafft_out.fa

rm "$input_seq"
