import strutils
import SeqTypes

proc find(seq: SeqRecord, str: string): int =
    return seq.seq.find(str)

# in-place removal of gaps in sequence
proc remove_gaps*(self: SeqRecord): SeqRecord =
    var newseq = ""
    for ch in self.seq:
        if ch == '-':
             continue
        else:
             newseq = newseq & ch
    SeqRecord(id: self.id, seq: newseq, len: newseq.len)

# output sequence as string incl. the sequence id
proc toString*(rec: SeqRecord): string =
    return rec.id & "\n" & rec.seq

proc toUpper*(self: SeqRecord): SeqRecord =
    var newseq: Seq =  ""
    for c in self.seq:
        newseq = newseq & toUpperAscii(c)
    SeqRecord(id: self.id, seq: newseq, len: newseq.len)

proc toLower*(self: SeqRecord): SeqRecord =
    var newseq: Seq =  ""
    for c in self.seq:
        newseq = newseq & toLowerAscii(c)
    SeqRecord(id: self.id, seq: newseq, len: newseq.len)


iterator ReadFasta*(file: File): SeqRecord =
    var id = ""
    for line in file.lines:
        if line.startswith(">") == true:
            id = strip(line)
            break
    var sequence = ""
    for line in file.lines:
        if line.startswith(">") == true:
             yield SeqRecord(id: id, seq: sequence, len: sequence.len)
             id = strip(line)
             sequence = ""
             continue
        sequence = sequence & strip(line)

    yield SeqRecord(id: id, seq: sequence, len: sequence.len)

# read fasta file to SeqRecordArray
proc ReadFasta*(file: File): SeqRecordArray =
    var id = ""
    var recs: seq[SeqRecord] = @[]
    for line in file.lines:
        if line.startswith(">") == true:
            id = strip(line)
            break
    var sequence = ""
    for line in file.lines:
        if line.startswith(">") == true:
             recs.add(SeqRecord(id: id, seq: sequence, len: sequence.len))
             id = strip(line)
             sequence = ""
             continue
        sequence = sequence & strip(line)
    recs.add(SeqRecord(id: id, seq: sequence, len: sequence.len))
    return recs

# reverse complement a sequence and return a copy
# Todo: check sequence type
proc reverse_complement*(rec: SeqRecord): SeqRecord =
    var revcomseq = ""
    for i in countdown(rec.seq.len-1, 0):
         if rec.seq[i] == 'A' or rec.seq[i] == 'a':
              revcomseq = revcomseq & "T"
         elif rec.seq[i] == 'G' or rec.seq[i] == 'g':
              revcomseq = revcomseq & "C"
         elif rec.seq[i] == 'C' or rec.seq[i] == 'c':
              revcomseq = revcomseq & "G"
         elif rec.seq[i] == 'T' or rec.seq[i] == 't':
              revcomseq = revcomseq & "A"
         else:
              revcomseq = revcomseq & rec.seq[i]
    SeqRecord(id: rec.id, seq: revcomseq, len: revcomseq.len)

# complement a seqeunce and return a copy
# todo: check sequence type
proc complement*(rec: SeqRecord): SeqRecord =
    var revcomseq = ""
    for i in countup(0, rec.seq.len-1):
         if rec.seq[i] == 'A' or rec.seq[i] == 'a':
              revcomseq = revcomseq & "T"
         elif rec.seq[i] == 'G' or rec.seq[i] == 'g':
              revcomseq = revcomseq & "C"
         elif rec.seq[i] == 'C' or rec.seq[i] == 'c':
              revcomseq = revcomseq & "G"
         elif rec.seq[i] == 'T' or rec.seq[i] == 't':
              revcomseq = revcomseq & "A"
         else:
              revcomseq = revcomseq & rec.seq[i]
    SeqRecord(id: rec.id, seq: revcomseq, len: revcomseq.len)

