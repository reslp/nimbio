import nimbio/AlignIO
import nimbio/Seq

let input = open("tests/test_data/OG0002993-aligned.fa")
var sequences = ReadFasta(input)
var alignment = newMultipleSeqAlignment(sequences)
echo("Alignment as MultipleSeqAlignment object")
echo(alignment)
echo("Alignment as Fasta")
echo(alignment.format(to="fasta"))
echo("Alignment as PhylipSequential")
echo(alignment.format(to="phylip-sequential"))
#echo(alignment[1 .. 5])

var seq1 = "ACGTCCGCTACGATGAG".newSeq()
var seq2 = newSeq("ACGTCCGCTACGATGAG")
var mas = newMultipleSeqAlignment(@[seq1, seq2])
echo(mas)
echo(mas[0..12])
