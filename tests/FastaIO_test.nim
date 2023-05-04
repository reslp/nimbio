import nimbio/FastaIO
import unittest

suite "Test FASTA handling":
  # this is where the file is opened
  echo("Several tests for FASTA handling")
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
    echo(sequence)



