import strutils
import SeqTypes
import Seq

type MultipleSeqAlignment* = ref object of RootObj
  ## | Basic datatype to create a multiple sequence alignment.    
  ## | Examples: 
  ## ```
  ## var seq = "AATCGTC".newSeq()
  ## var seq2 = newSeq("GGTTGN")
  ## var mas = newMultipleSeqAlignmen(@[seq, seq2])
  ## ```
  len*: int
  records: SeqRecordArray

type UnequalSeqLengthsException* = object of Exception
type UnkownAlignmentFormatException* = object of Exception

proc newMultipleSeqAlignment*(data: SeqRecordArray): MultipleSeqAlignment =
  for el in data:
    if el.len != data[0].len:
      raise newException(UnequalSeqLengthsException, "Sequences in alignment have different lengths.")
  return MultipleSeqAlignment(len: data.len, records: data)

proc newMultipleSeqAlignment*(data: seq[Seq]): MultipleSeqAlignment =
  var records: seq[SeqRecord] = @[]
  for el in data:
    records.add(SeqRecord(id: "", seq: el.seq, len: el.len))
  for el in records:
    if el.len != data[0].len:
      raise newException(UnequalSeqLengthsException, "Sequences in alignment have different lengths.")
  return MultipleSeqAlignment(len: data.len, records: records)

proc echo*(self: MultipleSeqAlignment) =
  echo("MultipleSeqAlignment with ", self.len, " rows and ", self.records[0].seq.len , " columns.")
  var maxiter = self.len - 1
  if self.len >= 10:
    maxiter = 9
  for sequence in self.records[0..maxiter]:
    if sequence.len <= 9:
      echo(sequence.seq[0..sequence.len-1])
    elif sequence.len <= 19:
      echo(sequence.seq[0..9] & " " & sequence.seq[10..19])
    elif sequence.len >= 29:
      echo(sequence.seq[0..9] & " " & sequence.seq[10..19] & " " & sequence.seq[20..29] & "   " & sequence.id)

proc format*(self: MultipleSeqAlignment, to: string): string =
  var result = ""
  if to == "fasta":
    for sequence in self.records:
      result &= ">" & sequence.id & "\n" & sequence.seq & "\n"
  elif to == "phylip-sequential":
    var outstring: string
    result = $self.len & " " & $self.records[0].seq.len
    for sequence in self.records:
      if len(sequence.id) < 10:
        outstring = "\n" & sequence.id & " ".repeat(10-len(sequence.id))
      else:
        outstring = "\n" & sequence.id[0 .. 9]
      for part in countup(0, len(sequence.seq), 10):
        if part + 10 < len(sequence.seq):
          outstring = outstring & sequence.seq[part .. part + 9] & " "
        else:
          outstring = outstring & sequence.seq[part .. len(sequence.seq)-1] & " "
      result &= outstring.strip(chars={' '}, leading=false)
  else:
    raise newException(UnkownAlignmentFormatException, "Alignment format " & to & " not recognized.")
  result 

#proc `[]`(a: MultipleSeqAlignment, r: HSlice[int, int]): MultipleSeqAlignment =
#  return a
