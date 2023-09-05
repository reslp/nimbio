# TODO: definition of the DNA and AA alphabets

# definition of the Sequence type and PhredScore type
type
    PhredScore* = object
        encoding*: string
        quality: seq[int]

proc encode_quality*(phreds: string): PhredScore =
  var a: seq[int] = @[]
  for phred in phreds:
    a.add(int(phred))
  return PhredScore(encoding: "Illumina 1.8+", quality: a)

proc decode_quality*(quality: PhredScore, encoding: string): string =
  var qual = ""
  # the offset type conversion of phredscores does not include all possible combinations yet!!
  var offset = 0
  if encoding == "Solexa" and quality.encoding == "Illumina 1.8+":
    offset = 26 
  elif encoding == "Illumina 1.8+" and quality.encoding == "Solexa":
    offset = -26 
  elif encoding == "Illumina 1.3" and quality.encoding == "Illumina 1.8+":
    offset = 31 
  elif encoding == "Illumina 1.8+" and quality.encoding == "Illumina 1.3":
    offset = -31 
  elif encoding == "Illumina 1.5" and quality.encoding == "Illumina 1.8+":
    offset = 33 
  elif encoding == "Illumina 1.8+" and quality.encoding == "Illumina 1.5":
    offset = -33 
  else:
    offset = 0  
    
  for score in quality.quality:
    qual = qual & char(score+offset)
  return qual

type
    SeqRecord* = ref object of RootObj
        len*: int
        id*: string
        seq*: string
    FQSeqRecord* = ref object of SeqRecord
        phred*: PhredScore
        internal_id*: string 

proc newSeqRecord*(sequence: string, id: string): SeqRecord =
    var record: SeqRecord
    record.len = sequence.len
    record.id = id
    record.seq = sequence
    return record

proc `$`*(rec: SeqRecord): string =
    return rec.id & "\n" & rec.seq

# an array of sequence records for easier handling
type 
   SeqRecordArray* = seq[SeqRecord]
   FQSeqRecordArray* = seq[FQSeqRecord]

proc `$`*(arr: SeqRecordArray): string =
    var val = ""
    for rec in arr:
        val = val & rec.id & "\n" & rec.seq & "\n" 
    return val

proc `$`*(arr: FQSeqRecordArray): string =
    var val = ""
    for rec in arr:
        val = val & rec.id & "\n" & rec.seq & "\n" & rec.internal_id & "\n" & decode_quality(rec.phred, rec.phred.encoding) & "\n"
    return val
