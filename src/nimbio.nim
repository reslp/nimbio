## # nimbio - library for biological data analysis in Nim
## 
## ## Overview:
##
## The `nimbio` library provides datastructures and functions to work with various types of biological data.
## It takes inspiration from the python (biopython) and R (ape) ecosystem and tries to provide similar functionality.
##
## `nimbio` is organized into different modules which provide functionality for different data types.
##
## | [nimbio/SeqTypes](nimbio/SeqTypes.html) provides basic data structures for working with FASTA and FASTQ sequence data.  
## | [nimbio/FastaIO](nimbio/FastaIO.html) allows parsing and analysis of FASTA sequence data.     
## | [nimbio/FastqIO](nimbio/FastqIO.html) allows parsing and analysis of FASTQ sequence data.
## | [nimbio/TreeIO](nimbio/TreeIO.html) has data structures and functions for working with phylogenetic trees. 
## | [nimbio/Align](nimbio/Align.html) provides functions for working with multiple sequence alignments.
## | [nimbio/Kmer](nimbio/Kmer.html) provides functions for working with Kmers. 

import nimbio/SeqTypes
import nimbio/FastaIO
import nimbio/FastqIO
import nimbio/Kmer
import nimbio/TreeIO
import nimbio/Align

export SeqTypes, FastaIO, FastqIO, Kmer, TreeIO, Align
