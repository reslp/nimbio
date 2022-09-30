import strutils
import sequtils
import nimly
import patty

variant Tokens:
  OPENB
  CLOSEB
  COMMA
  TIP(tip: string)
  END

niml Lexer[Tokens]:
  r"\(":
    return OPENB()
  r"\)":
    return CLOSEB()
  r",":
    return COMMA()
  r"\w+":
    return TIP(token.token)
  r";":
    return END()

type
  Phylo* = object
    newick*: string
    edge*: seq[seq[int]] 
    tips*: seq[string]

proc readtree*(file: File): Phylo = 
  var line: string
  for line in file.lines:
    for ch in line:
      if ch == '(':
        echo("node left")

proc readtree*(nwkstr: string): Phylo =
  var tips = nwkstr.replace("(", "").replace(")","").replace(";")
  var mytips: seq[string]
  var ntips = len(tips.split(","))
  echo("Number of tips: ", ntips)
  var rootnode = ntips + 1 
  var nintnodes = nwkstr.count(")")
  echo("Number of internal nodes: ", nintnodes)
  var nedges = nintnodes + ntips - 1
  echo("Number of edges: ", nedges)
  var left = repeat(0, nedges)
  var right = repeat(0, nedges)
  # setting things up:
  var currnode = ntips + 1
  var nodecount = currnode
  var whichtip = 1
  var i = 0
  var j = 0
  var temp = ""
  while(nwkstr[i] != ';'):
    #echo(j)
    #echo(currnode)
    if nwkstr[i] == '(':
      #echo("open braket")
      left[j] = currnode
      i += 1
      if nwkstr[i] != '(' and nwkstr[i] != ')' and nwkstr[i] != ',' and nwkstr[i] != ':' and nwkstr[i] != ';':
        #echo("tip")
        temp = ""
        while(nwkstr[i] != ',' and nwkstr[i] != ':' and nwkstr[i] != ')'):
          temp.add(nwkstr[i])
          i += 1
        mytips.add(temp)
        right[j] = mytips.len
      elif nwkstr[i] == '(':
        nodecount += 1
        currnode = nodecount
        right[j] = currnode
      j += 1   
    elif nwkstr[i] == ')':
      #echo("closing braket")
      currnode = left[left.find(currnode)] - 1
      i += 1
    elif nwkstr[i] == ',':
      #echo("comma")
      left[j] = currnode
      i += 1
      if nwkstr[i] != '(' and  nwkstr[i] != ')' and nwkstr[i] != ',' and nwkstr[i] != ':' and nwkstr[i] != ';':
        #echo("tip after comma")
        temp = ""
        while(nwkstr[i] != ',' and nwkstr[i] != ':' and nwkstr[i] != ')'):
          temp.add(nwkstr[i])
          i += 1
        mytips.add(temp)
        right[j] = mytips.len
      elif nwkstr[i] == '(':
        nodecount += 1
        currnode = nodecount
        right[j] = currnode
      j += 1  
  var tree: Phylo
  tree.newick = nwkstr
  tree.edge = @[left,right]
  tree.tips = mytips
  #echo(left)
  #echo(right)
  #echo(mytips)
  return tree

proc echo*(phylo: Phylo) =
  echo(phylo.newick)

proc edges*(phylo: Phylo) =
  echo("   1,  2,")
  for i in 0 .. phylo.edge[1].len - 1 :
    echo(i+1,",  ", phylo.edge[0][i],"  ", phylo.edge[1][i])

proc readtreelex*(nwkstr: string) =
  # this is a work in progress and not working yet
  var tree = Lexer.newWithString(nwkstr)
  var tips = nwkstr.replace("(", "").replace(")","").replace(";")
  var alltips = tips.split(",")
  var ntips = alltips.len
  echo("Number of tips: ", ntips)
  var rootnode = ntips + 1 
  var nintnodes = nwkstr.count(")")
  echo("Number of internal nodes: ", nintnodes)
  var nedges = nintnodes + ntips - 1
  echo("Number of edges: ", nedges)
  var left = repeat(0, nedges)
  var right = repeat(0, nedges)
  # setting things up:
  var currnode = ntips + 1
  var nodecount = currnode
  var whichtip = 1
  var li = 0
  var ri = 0
  var second = 0
  left[0] = currnode
  for token in tree.lexIter:
    case token.kind: # how is this matched correctly?
      of TokensKind.OPENB:
        left[li] = currnode
        li += 1
        echo("OPENB")
      of TokensKind.CLOSEB:
        currnode = right[li] 
        echo("CLOSEB")
      of TokensKind.COMMA:
        left[li] = currnode
        echo("COMMA")
      of TokensKind.TIP:
        right[li] = whichtip
        whichtip += 1
        echo("TIP")
      of TokensKind.END:
        echo("END")
        break
    echo(left)
    echo(right) 
