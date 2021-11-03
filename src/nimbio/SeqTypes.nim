import strutils
 
# TODO: definition of the DNA and AA alphabets

# definition of the Sequence type
type
    Seq* = string

type
    SeqRecord* = ref object of RootObj
        len*: int
        id*: string
        seq*: Seq
    FQSeqRecord* = ref object of SeqRecord
        phred*: string
        internal_id*: string

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
        val = val & rec.id & "\n" & rec.seq & "\n" & rec.internal_id & "\n" & rec.phred & "\n"
    return val
