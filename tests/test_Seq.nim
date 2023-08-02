import ../src/nimbio/Seq
import unittest

suite "Seq":
  echo("Several tests for the Seq datatype:\n")
  echo("Test first sequence:")
  var seq1: Seq
  seq1 = newSeq("ATCGTCA")
  echo(seq1)
  check(seq1.len == 7)

  echo("\nTest functions:")
  var seq2: Seq
  seq2 = newSeq("A---T--CG-TCA")
  echo("Sequence with gaps:")
  echo(seq2)
  echo("Ungapped sequence:")
  echo(seq2.ungap)
  check seq2.ungap.len == 7
  echo("Check if sequences are equal:")
  seq2 = seq2.ungap
  check(seq2 == seq1)
  echo("Adding two sequences:")
  echo(seq1 + seq2)
  echo(seq1 + "ATG")
  echo("Create hash from sequence")
  echo(seq1.hash())
  
