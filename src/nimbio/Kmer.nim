import strutils
import SeqTypes
import std/tables
import sequtils


let base_for = "ACGT"
let base_rev = "TGCA"

proc translate*(s: string): string =
  case s:
    of "A":
      return "T"
    of "T":
      return "A"
    of "G":
      return "C"
    of "C":
      return "G"
    else:
      return ""

proc count_kmer*(k: int, sequence: string): Table[string, int] = 
  var kdict = initTable[string, int]()
  var length = len(sequence)  
  var kmer_for = ""
  var kmer_rev = ""
  var kmer = ""
  if length < k: return
  for i in countup(0, (length - k + 1)):
    if (i+k-1) >= length: break
    kmer_for = sequence[i .. (i+k-1)] 
    if "N" in kmer_for: continue
    kmer_rev = sequence[i .. (i+k-1)].multiReplace(replacements=[("A","T"), ("T","A"), ("G","C"), ("C","G")])
    #echo(kmer_for, " ", kmer_rev)
    if kmer_for < kmer_rev:
      kmer = kmer_for
    else:
      kmer = kmer_rev
    if kmer in kdict:
      kdict[kmer] += 1
    else:
      kdict[kmer] = 1
  return kdict


