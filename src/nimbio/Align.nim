import strutils
import SeqTypes

type MultipleSeqAlignment* = ref object of RootObj
  len*: int
  records: SeqRecordArray

type UnequalSeqLengthsException* = object of Exception
type UnkownAlignmentFormatException* = object of Exception

proc newMultipleSeqAlignment*(data: SeqRecordArray): MultipleSeqAlignment =
  for el in data:
    if el.len != data[0].len:
      raise newException(UnequalSeqLengthsException, "Sequences in alignment have different lengths.")
  return MultipleSeqAlignment(len: data.len, records: data)

proc echo*(self: MultipleSeqAlignment) =
  echo("MultipleSeqAlignment with ", self.len, " rows and ", self.records[0].seq.len , " columns.")
  var maxiter = self.len
  if self.len >= 10:
    maxiter = 9
  for sequence in self.records[0..maxiter]:
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

proc `[]`(a: MultipleSeqAlignment, r: HSlice[int, int]): MultipleSeqAlignment =
  return a
