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

# an array of sequence records for easier handling
type 
   SeqRecordArray* = seq[SeqRecord]
   FQSeqRecordArray* = seq[FQSeqRecord]
