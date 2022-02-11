import src/nimbio.FastQIO

# this is where the file is opened
let input = open("tests/test_data/subset.fastq")
for sequence in ReadFastQ(input):
  echo(sequence.toString)
