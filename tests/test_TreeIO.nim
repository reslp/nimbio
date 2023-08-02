import nimbio/TreeIO

var tree: Phylo

#test minimal tree
tree = readtree("(A,B);")
tree.edges()

#test first tree
tree = readtree("((AAA,BBB),(CCC,DDD));")
echo(tree)
assert tree.edge[0] == @[5, 6, 6, 5, 7, 7]
assert tree.edge[1] == @[6, 1, 2, 7, 3, 4]
tree.edges()
echo(tree.tips)
echo()

# test second tree
tree = readtree("(((Human,Chimp),Gorilla),Monkey);")
echo(tree)
assert tree.edge[0] == @[5, 6, 7, 7, 6, 5]
assert tree.edge[1] == @[6, 7, 1, 2, 3, 4]
tree.edges()
echo(tree.tips)
echo()

# test tree with polytomy
tree = readtree("(((A,B,C),D),E);")
echo(tree)
assert tree.edge[0] == @[6, 7, 8, 8, 8, 7, 6]
assert tree.edge[1] == @[7, 8, 1, 2, 3, 4, 5]
tree.edges() # show APE style representation
echo(tree.tips)
echo()


# test tree with support values
tree = readtree("(((Human,Chimp)1,Gorilla)1,Monkey);")
echo(tree)
assert tree.edge[0] == @[5, 6, 7, 7, 6, 5]
assert tree.edge[1] == @[6, 7, 1, 2, 3, 4]
tree.edges()
echo(tree.tips)
echo(tree.nodelabel)
echo()

# test tree with branch lengths
tree = readtree("(((Human:1,Chimp:1):1,Gorilla:1):1,Monkey:1);")
echo(tree)
assert tree.edge[0] == @[5, 6, 7, 7, 6, 5]
assert tree.edge[1] == @[6, 7, 1, 2, 3, 4]
tree.edges()
echo(tree.tips)
echo(tree.edgelength)
echo()

# test tree with branch lengths and node support
tree = readtree("(((Human:1,Chimp:1)100:1,Gorilla:1)100:1,Monkey:1);")
echo(tree)
assert tree.edge[0] == @[5, 6, 7, 7, 6, 5]
assert tree.edge[1] == @[6, 7, 1, 2, 3, 4]
tree.edges()
echo(tree.tips)
echo("Edge lengths: ", tree.edgelength)
echo("Node labels: ", tree.nodelabel)
echo()

echo("Read trees from file now:")
let f = open("tests/test_data/phylo.tre")
for tree in readtree(f):
  tree.summary()
  echo("Edgelabels", tree.edgelength)
  echo("Nodelabels", tree.nodelabel)
