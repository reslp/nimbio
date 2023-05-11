import strutils
import sequtils
#import nimly # needed for lexer style
#import patty # needed for lexer style

#variant Tokens:
#  OPENB
#  CLOSEB
#  COMMA
#  TIP(tip: string)
#  END
#
#niml Lexer[Tokens]:
#  r"\(":
#    return OPENB()
#  r"\)":
#    return CLOSEB()
#  r",":
#    return COMMA()
#  r"\w+":
#    return TIP(token.token)
#  r"\);":
#    return END()

type
  Phylo* = object
    newick*: string
    edge*: seq[seq[int]]
    tips*: seq[string]
    nodelabel*: seq[string]
    edgelength*: seq[string]
    nnodes*: int
  MultiPhylo* = seq[Phylo]
    
  
proc readtree*(nwkstr: string): Phylo =
  var tips = nwkstr.replace("(", "").replace(")","").replace(";")
  var mytips: seq[string]
  var ntips = len(tips.split(","))
  #echo("Number of tips: ", ntips)
  var nintnodes = nwkstr.count(")")
  #echo("Number of internal nodes: ", nintnodes)
  var nedges = nintnodes + ntips - 1
  #echo("Number of edges: ", nedges)
  var left = repeat(0, nedges)
  var right = repeat(0, nedges)
  # setting things up:
  var currnode = ntips + 1
  var nodecount = currnode
  var nodelabels: seq[string]
  var edgelengths: seq[string]
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
    elif nwkstr[i] in "0123456789:.": #value is node label or branch length
      temp = ""
      while(nwkstr[i] != ',' and nwkstr[i] != ')'):
        temp.add(nwkstr[i])
        i += 1
      if ':' in temp:
        if temp.split(":")[0] == "": #values will be treated as edgelengths
          edgelengths.add(temp.split(":")[1])
        else:
          edgelengths.add(temp.split(":")[1])
          nodelabels.add(temp.split(":")[0])
    else:
      echo("Charater not parsable:", nwkstr[i])
  result.newick = nwkstr
  result.edge = @[left,right]
  result.tips = mytips
  result.nnodes = currnode
  if len(nodelabels) > 0: # only add node labels if they are present
    result.nodelabel = @[""] & nodelabels
  if len(edgelengths) > 0: #== len(left) and len(edgelengths) == len(right):
    result.edgelength = @[""] & edgelengths
    #echo("Length of edgelengths:", len(edgelengths))
    #echo("Length of nodelabels:", len(nodelabels))
    #echo("Length of left:", len(left))
    #echo("Length of right:", len(right))

proc readtree*(file: File): MultiPhylo =
  for line in file.lines:
      if line.strip() == "":
        continue
      result.add(readtree(line.strip()))


proc echo*(phylo: Phylo) =
  echo(phylo.newick)

proc edges*(phylo: Phylo) =
  echo("   1,  2,")
  for i in 0 .. phylo.edge[1].len - 1 :
    echo(i+1,",  ", phylo.edge[0][i],"  ", phylo.edge[1][i])

proc summary*(phylo: Phylo) =
  echo("Tree Summary:")
  echo(len(phylo.tips), " terminal Nodes (Tips)")
  echo(phylo.nnodes, " internal Nodes")
  if len(phylo.nodelabel) == 0:
    echo("No nodelabels found")
  else:
    echo(len(phylo.nodelabel), " Nodelabels")
  if len(phylo.edgelength) == 0:
    echo("No branchlengths found")
  else:
    echo(len(phylo.edgelength), " Branchlength values")
  echo(" ")
# currently not functional:
#proc readtreelex*(nwkstr: string): Phylo =
#  # this is a work in progress and not working yet
#  var tree = Lexer.newWithString(nwkstr)
#  var tips = nwkstr.replace("(", "").replace(")","").replace(";")
#  var alltips = tips.split(",")
#  var ntips = alltips.len
#  echo("Number of tips: ", ntips)
#  var rootnode = ntips + 1 
#  var nintnodes = nwkstr.count(")")
#  echo("Number of internal nodes: ", nintnodes)
#  var nedges = nintnodes + ntips - 1
#  echo("Number of edges: ", nedges)
#  #var left = repeat(0, nedges)
#  var left: seq[int] = @[0]
#  var right: seq[int] = @[0]
#  #var right = repeat(0, nedges)
#  # setting things up:
#  var lcurrnode = ntips + 1
#  var rcurrnode = ntips + 1
#  var nodecount = lcurrnode
#  var whichtip = 1
#  var second = 0
#  #left[0] = currnode
#  var stack: seq[string]
#  var i = 1
#  var last_token = TokensKind.OPENB # initialize last_token with a non existing token
#  for token in tree.lexIter:
#    echo("Iteration:", i)
#    case token.kind:
#      of TokensKind.OPENB:
#        left.add(lcurrnode)
#        lcurrnode += 1
#
#        rcurrnode += 1
#        right.add(rcurrnode)
#  
#        echo("OPENB")
#      of TokensKind.CLOSEB:
#        lcurrnode -= 1
#        left.add(lcurrnode)
#        echo("CLOSEB")
#      of TokensKind.COMMA:
#        if last_token == TokensKind.TIP:
#          lcurrnode -= 1
#          echo("last was tip")
#          left.add(lcurrnode)
#        if last_token == TokensKind.CLOSEB:
#          right.add(rcurrnode)
#          rcurrnode += 1
#          lcurrnode += 1
#        echo("COMMA")
#      of TokensKind.TIP:
#        if last_token == TokensKind.OPENB:
#          right.delete(right.len - 1)
#          right.add(whichtip)
#          whichtip += 1
#        if last_token == TokensKind.COMMA:
#          right.add(whichtip)
#          whichtip += 1 
#        echo("TIP")
#      of TokensKind.END:
#        echo("END")
#        break
#    echo(left)
#    echo(right)
#    last_token = token.kind
#    i += 1
#  echo(left)
#  echo(right)
