import src/nimbio.FastaIO

# this is where the file is opened
let input = open("tests/test_data/sequences.fasta")
var i = 0
for sequence in ReadFasta(input):
     echo "Original sequence:"
     echo sequence.toString()
     echo "Sequence as upper case:"
     echo sequence.toUpper.toString
     echo "Sequence as lower case"
     echo sequence.toLower().toString()
     echo "Reverse Complement of sequence"
     echo sequence.reverse_complement().toString()

import nimbio/FastQIO
echo("Check FASTQ handling")

