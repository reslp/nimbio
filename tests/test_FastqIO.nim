import nimbio/FastqIO
import unittest

# this is where the file is opened
suite "Test handling of FASTQ files":
  echo("Several tests for FASTQ handling")
  let input = open("tests/test_data/subset.fastq")
  for sequence in ReadFastQ(input):
    echo("Read with original quality encoding:")
    echo(sequence.toString)
    echo("Read with Illumina 1.5 quality encoding:")
    echo(sequence.toString("Illumina 1.5"))
    echo("Read with Solexa quality encoding:")
    echo(sequence.toString("Solexaa"))
    echo(sequence.format("fasta"))
