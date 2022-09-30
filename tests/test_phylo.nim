import ../src/nimbio.TreeIO

var tree: Phylo

tree = readtree("((AAA,BBB),(CCC,DDD));")
echo(tree)
echo(tree.edge)
echo(tree.edge[1].len)
tree.edges()
