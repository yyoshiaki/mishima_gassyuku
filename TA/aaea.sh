#!/bin/sh
# shell script to run align_and_estimate_abundance.pl in Trinity
# Hidemasa Bono <bonohu@gmail.com>
#
# number of thread to use 
threads=4
# location of Trinity output FASTA
transcript=trinity_out_dir/Trinity.fasta
# original FASTQ files for the assembly 
left=DRR092257_1.fq.gz
right=DRR092257_2.fq.gz

# parameters to run above
time /usr/local/Cellar/trinity/2.8.3/libexec/util/align_and_estimate_abundance.pl \
--thread_count $threads \
--transcripts $transcript \
--seqType fq \
--left  $left \
--right $right \
--est_method kallisto \
--kallisto_add_opts "-t $threads" \
--prep_reference --output_dir kallisto_out

