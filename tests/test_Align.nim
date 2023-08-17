import nimbio/AlignIO

let input = open("tests/test_data/OG0002993-aligned.fa")
var sequences = ReadFasta(input)
var alignment = newMultipleSeqAlignment(sequences)
echo("Alignment as MultipleSeqAlignment object")
echo(alignment)
echo("Alignment as Fasta")
echo(alignment.format(to="fasta"))
echo("Alignment as PhylipSequential")
echo(alignment.format(to="phylip-sequential"))
echo(alignment[1 .. 5])
