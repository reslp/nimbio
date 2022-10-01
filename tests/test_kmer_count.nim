#import ../src/nimbio.Kmer
import ../src/nimbio
#import ../src/nimbio.SeqTypes
import unittest
import std/tables
# This implementation of a simple k-mer counter works, but is slow (~600s to analyze 31mers in 5M 100bp reads) 


echo("Several tests for kmer counting")
let input = open("tests/test_data/M_abscessus_HiSeq_10M.fa")
var i = 1
var kmers = initTable[string, int]()
var allkmers = initTable[string, int]()

proc print(args: varargs[string, `$`], en: string = "\n") =
  for arg in args:
    stdout.write(arg)
  stdout.write(en)

for sequence in ReadFasta(input):
  print("Sequence ", i, en="\r")
  kmers = count_kmer(31, sequence.toString())
  for k in kmers.keys():
    if k in allkmers:
      allkmers[k] += 1
    else:
      allkmers[k] = 1
