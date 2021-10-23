import strutils
import SeqTypes

iterator ReadFastQ*(file: File): FQSeqRecord =
    var whichline = 1
    var id = ""
    var seq = ""
    var internal_id = ""
    var phred = "" 
    for line in file.lines:
        if whichline == 1:
             id = strip(line)
             whichline += 1
             continue
        if whichline == 2:
             seq = strip(line)
             whichline += 1
             continue
        if whichline == 3:
             internal_id = strip(line)
             whichline += 1
             continue
        if whichline == 4:
             phred = strip(line)
             yield FQSeqRecord(id: id, seq: seq, internal_id: internal_id, phred: phred, len: seq.len)
             id = ""
             seq = ""
             internal_id = ""
             phred = ""
             whichline = 1
             continue 
    yield FQSeqRecord(id: id, seq: seq, internal_id: internal_id, phred: phred, len: seq.len)
