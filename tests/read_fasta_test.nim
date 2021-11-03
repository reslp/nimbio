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

echo("Check FASTQ handling")
let input2 = open("testdata/subset.fastq")
var readall: FQSeqRecordArray = ReadFastQ(input2)
check readall.len == 1000

echo("Check printing of FASTQ")
echo("Single sequence")
echo(readall[1])
echo("Whole array")
echo(readall)
