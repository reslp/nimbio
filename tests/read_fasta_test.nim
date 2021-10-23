import nimbio/src/nimbio/SeqIO
# this is where the file is opened
let input = open("sequences.fasta")
var i = 0
for sequence in ReadFasta(input):
     echo "Original sequence:"
     echo sequence.toString()
     echo "Sequence as upper case:"
     echo sequence.toUpper().toString()
     echo "Sequence as lower case"
     echo sequence.toLower().toString()
     echo "Reverse Complement of sequence"
     echo sequence.reverse_complement().toString()
