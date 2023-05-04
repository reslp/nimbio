import strutils
import Seq
import SeqTypes

iterator ReadFastQ*(file: File): FQSeqRecord =
    var whichline = 1
    var id = ""
    var seq_raw = ""
    var internal_id = ""
    var phred = "" 
    for line in file.lines:
        if whichline == 1:
              id = strip(line)
              if id.len() == 0:
                break
              whichline += 1
              continue
        if whichline == 2:
              seq_raw = strip(line)
              whichline += 1
              continue
        if whichline == 3:
              internal_id = strip(line)
              whichline += 1
              continue
        if whichline == 4:
              phred = strip(line)
              yield FQSeqRecord(id: id, seq: newSeq(seq_raw), internal_id: internal_id, phred: encode_quality(phred), len: seq_raw.len)
              id = ""
              seq_raw = ""
              internal_id = ""
              phred = ""
              whichline = 1
              continue 

proc ReadFastQ*(file: File): FQSeqRecordArray =
    var whichline = 1
    var id = ""
    var seq_raw = ""
    var internal_id = ""
    var phred = "" 
    var recs: seq[FQSeqRecord] = @[]
    for line in file.lines:
        if whichline == 1:
              id = line.strip()
              if id.len() == 0:
                break
              whichline += 1
              continue
        if whichline == 2:
              seq_raw = strip(line)
              whichline += 1
              continue
        if whichline == 3:
              internal_id = strip(line)
              whichline += 1
              continue
        if whichline == 4:
              phred = strip(line)
              recs.add(FQSeqRecord(id: id, seq: newSeq(seq_raw), internal_id: internal_id, phred: encode_quality(phred), len: seq_raw.len))
              id = ""
              seq_raw = ""
              internal_id = ""
              phred = ""
              whichline = 1
              continue 
    return recs

proc toString*(rec: FQSeqRecord, encoding: string = "Illumina 1.9+"): string =
    return rec.id & "\n" & rec.seq.data & "\n" & rec.internal_id & "\n" & decode_quality(rec.phred, encoding) & "\n" 
