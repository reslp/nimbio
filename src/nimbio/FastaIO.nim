import strutils
import Seq
import SeqTypes

proc find(self: SeqRecord, str: string): int =
    return self.seq.data.find(str)

# in-place removal of gaps in sequence
proc remove_gaps*(self: SeqRecord): SeqRecord =
    var newseq = ""
    for ch in self.seq.data:
        if ch == '-':
             continue
        else:
             newseq = newseq & ch
    SeqRecord(id: self.id, seq: newSeq(newseq), len: newseq.len)

# output sequence as string incl. the sequence id
proc toString*(rec: SeqRecord): string =
    return rec.seq.data

proc toUpper*(self: SeqRecord): SeqRecord =
    var newseq =  ""
    for c in self.seq.data:
        newseq = newseq & toUpperAscii(c)
    SeqRecord(id: self.id, seq: newSeq(newseq), len: newseq.len)

proc toLower*(self: SeqRecord): SeqRecord =
    var newseq = ""
    for c in self.seq.data:
        newseq = newseq & toLowerAscii(c)
    SeqRecord(id: self.id, seq: newSeq(newseq), len: newseq.len)


iterator ReadFasta*(file: File): SeqRecord =
    var id = ""
    for line in file.lines:
        if line.startswith(">") == true:
            id = strip(line).strip(chars={'>'})
            break
    var sequence = ""
    for line in file.lines:
        if line.startswith(">") == true:
             yield SeqRecord(id: id, seq: newSeq(sequence), len: sequence.len)
             id = strip(line).strip(chars={'>'})
             sequence = ""
             continue
        sequence = sequence & strip(line)

    yield SeqRecord(id: id, seq: newSeq(sequence), len: sequence.len)

# read fasta file to SeqRecordArray
proc ReadFasta*(file: File): SeqRecordArray =
    var id = ""
    var recs: seq[SeqRecord] = @[]
    for line in file.lines:
        if line.startswith(">") == true:
            id = strip(line).strip(chars={'>'})
            break
    var sequence = ""
    for line in file.lines:
        if line.startswith(">") == true:
             recs.add(SeqRecord(id: id, seq: newSeq(sequence), len: sequence.len))
             id = strip(line).strip(chars={'>'})
             sequence = ""
             continue
        sequence = sequence & strip(line)
    recs.add(SeqRecord(id: id, seq: newSeq(sequence), len: sequence.len))
    return recs

# reverse complement a sequence and return a copy
# Todo: check sequence type
proc reverse_complement*(rec: SeqRecord): SeqRecord =
    var revcomseq = ""
    for i in countdown(rec.seq.data.len-1, 0):
         if rec.seq.data[i] == 'A' or rec.seq.data[i] == 'a':
              revcomseq = revcomseq & "T"
         elif rec.seq.data[i] == 'G' or rec.seq.data[i] == 'g':
              revcomseq = revcomseq & "C"
         elif rec.seq.data[i] == 'C' or rec.seq.data[i] == 'c':
              revcomseq = revcomseq & "G"
         elif rec.seq.data[i] == 'T' or rec.seq.data[i] == 't':
              revcomseq = revcomseq & "A"
         else:
              revcomseq = revcomseq & rec.seq.data[i]
    SeqRecord(id: rec.id, seq: newSeq(revcomseq), len: revcomseq.len)

# complement a seqeunce and return a copy
# todo: check sequence type
proc complement*(rec: SeqRecord): SeqRecord =
    var revcomseq = ""
    for i in countup(0, rec.seq.data.len-1):
         if rec.seq.data[i] == 'A' or rec.seq.data[i] == 'a':
              revcomseq = revcomseq & "T"
         elif rec.seq.data[i] == 'G' or rec.seq.data[i] == 'g':
              revcomseq = revcomseq & "C"
         elif rec.seq.data[i] == 'C' or rec.seq.data[i] == 'c':
              revcomseq = revcomseq & "G"
         elif rec.seq.data[i] == 'T' or rec.seq.data[i] == 't':
              revcomseq = revcomseq & "A"
         else:
              revcomseq = revcomseq & rec.seq.data[i]
    SeqRecord(id: rec.id, seq: newSeq(revcomseq), len: revcomseq.len)

proc echo*(self: SeqRecord, format="fasta") =
  if format == "fasta":
    echo(">" & self.id & "\n" & self.seq.data)
  else:
    echo("Output format not yet supported")

proc echo*(self: SeqRecordArray, format="fasta") =
  if format == "fasta":
    for sequence in self:
      echo(sequence)
  elif format == "phylip-sequential":
    echo(len(self), " ", len(self[0].seq.data)) #this takes the length of the first sequence and thus assumes equal length of all sequences. if this is not the case phylip format will be vialoted
    for sequence in self:
      var outstring = ""
      if len(sequence.id) < 10:
        outstring = sequence.id & " ".repeat(10-len(sequence.id))
      else:
        outstring = sequence.id[0 .. 9]
      for part in countup(0, len(sequence.seq.data), 10):
        if part + 10 < len(sequence.seq.data):
          outstring = outstring & sequence.seq.data[part .. part + 9] & " "
        else:
          outstring = outstring & sequence.seq.data[part .. len(sequence.seq.data)-1] & " "
      echo(outstring.strip(chars={' '}, leading=false))
  else:
    echo("Output format not yet supported")
