import strutils
#import sequtils
import re
import math

type
  Phylo* = object
    newick*: string
    edge*: seq[int]
    tip_label*: seq[string]
    node_label*: seq[string]
    edge_length*: seq[string]
    Nnode*: int
  MultiPhylo* = seq[Phylo]

proc clean_nwk(nwk: string): string =
  # Newick files exist in many variants
  # this function tries to reduce it to a format
  # which can be parsed better
  if nwk.len == 0:
    echo("Empty NEWICK string")

  let pattern1 = re"(\[\[^\]]*\])" # get rid of all info in square brackets (eg. from BEAST)
  result = nwk.replace(pattern1, by="")
  let pattern2 = re"^_+|_+$"
  result = result.replace(pattern2, by="")
  let pattern3 = re"[ \t]"
  result = result.replace(pattern3, by="")
  return result

proc extract_portion_newick(nwk: ptr string, a: int, b: int, y: ptr string) =
  #echo("extract portion newick")
  for i in a .. b:
    y[].add(nwk[][i]) # this parses the tips

proc decode_terminal_edge(nwk: ptr string, a: int, b: int, tip: ptr string, w: ptr string) =
  #echo("decode terminal edge")
  var co = a
  var str = ""
  while nwk[][co] != ':' and co <= b:
    co.inc()

  extract_portion_newick(nwk, a, co - 1, tip)

  if co < b:
    extract_portion_newick(nwk, co + 1, b, addr str)
    w[] = str
  else:
    w[] = "NaN"

proc decode_internal_edge(nwk: ptr string, a: int, b: int, lab: ptr string, w: ptr string) =
  var co = a
  var str = ""
  while nwk[][co] != ':' and co <= b:
    co.inc()
  if a == co:
    lab[].add("")
  else:
    extract_portion_newick(nwk, a, co - 1, lab)
  if co < b:
    extract_portion_newick(nwk, co + 1, b, addr str)
    w[] = str
  else:
    w[] = "NaN"

template ADD_INTERNAL_EDGE() =
  e[j] = curnode
  node.inc()
  curnode = node
  e[j + nedge] = curnode
  stack_internal[k] = j
  k += 1
  j += 1
  
template ADD_TERMINAL_EDGE_TIPLABEL() =
  e[j] = curnode
  decode_terminal_edge(addr nwk, pr + 1, ps - 1, addr tip, addr tmpd)
  result.tip_label[curtip-1] = tip
  e[j + nedge] = curtip
  el[j] = tmpd
  curtip.inc()
  j.inc()

template GO_DOWN() =
  decode_internal_edge(addr nwk, ps + 1, pt - 1, addr lab, addr tmpd)
  result.node_label[curnode - 1 - ntip] = lab
  k -= 1
  l = stack_internal[k]
  el[l] = tmpd
  curnode = e[l]

proc readtree*(nwkstr: string): Phylo =
  # This proc and the templates above are basically a Nim reimplementation of the tree parsing functionality in the R package ape: https://github.com/emmanuelparadis/ape
  # This is to allow compatibility with how ape (which is the defacto standard for tree parsing in R) reads phylogenetic tree data.
  # However it is not 100% compatible due to how ape rounds numbers.
  # The original source code of the ape implementation is here: https://github.com/emmanuelparadis/ape/blob/master/src/tree_build.c
  # Thank you very much Emmanuel Paradis!
  
  var nwk = clean_nwk(nwkstr)
  var
    n, ntip: int = 1
    nleft, nright, nnode: int = 0
    nedge: int
    curnode, node, j: int
    ps, pr, pt, l, k: int = 0
    curtip: int = 1
  var lab = ""
  var tmpd = ""
  var nsk = 0
  var skeleton: seq[int]
  var stack_internal = newSeq[int](100000)

  # scan nwk string to determine some values:
  # this is what essentially what the INITIALIZE_SKELETON	macro is doing in the original C source code.
  n = nwk.len
  for i in 0 .. n-1:
    if nwk[i] == '(':
      skeleton.add(i)
      nsk += 1
      nleft += 1
      continue
    if nwk[i] == ',':
      skeleton.add(i)
      nsk += 1
      ntip += 1
      continue
    if nwk[i] == ')':
      skeleton.add(i)
      nsk += 1
      nright += 1
      nnode += 1

  if nleft != nright:
    echo("badly formated nwk string")
  nedge = ntip + nnode - 1

  # set some placeholder values for phylo object which will be populated later
  result.Nnode = nnode
  result.edge = newSeq[int](nedge*2)
  result.edge_length = newSeq[string](nedge)
  result.node_label = newSeq[string](nnode)
  result.tip_label = newSeq[string](ntip)
  
  curnode = ntip + 1
  node = ntip + 1
  k = 0 # position in stack_internal
  j = 0 # position in edge matrix
  var e = result.edge
  var el = result.edge_length
  var tip = "" 
  var xx = 0
  # now process nwk string again to build phylo object
  for i in 1 .. nsk-2:
    ps = skeleton[i]
    if nwk[ps] == '(':
      ADD_INTERNAL_EDGE()
      continue
    xx = i - 1
    pr = skeleton[xx]
    if nwk[ps] == ',':
      if nwk[pr] != ')':
        ADD_TERMINAL_EDGE_TIPLABEL()
        tip = ""
      continue
    if nwk[ps] == ')':
      xx = i + 1
      pt = skeleton[xx]
      if nwk[pr] == ',':
        ADD_TERMINAL_EDGE_TIPLABEL()
        tip = ""
        GO_DOWN()
        lab = ""
        continue
      if nwk[pr] == '(':
        ADD_TERMINAL_EDGE_TIPLABEL()
        tip = ""
        GO_DOWN()
        lab = ""
        continue
      if nwk[pr] == ')':
        GO_DOWN()
        lab = ""
  pr = skeleton[nsk - 2]
  ps = skeleton[nsk - 1]
  # is the last edge terminal?
  if nwk[pr] == ',' and nwk[ps] == ')':
    ADD_TERMINAL_EDGE_TIPLABEL()

  # TODO: Add functionality for root edge/label parsing according to:
  # https://github.com/emmanuelparadis/ape/blob/master/src/tree_build.c#L239


  # now populated Phylo object with real values
  result.edge = e
  result.edge_length = el
  result.Nnode = nnode
  result.newick = nwk


proc readtree*(file: File): MultiPhylo =
  for line in file.lines:
      if line.strip() == "":
        continue
      result.add(readtree(line.strip()))

proc echo*(phylo: Phylo) =
  echo(phylo.newick)

proc ape_edges*(phylo: Phylo) =
  # display Phylo.edge in the same way as in R -> tree.edge
  #doAssert floorMod(phylo.edge.len, 2) == 0
  if phylo.edge.len mod 2 == 0:
    echo("   1,  2,")
    for i in 0 .. (phylo.edge.len / 2).toInt - 1:
      echo(i + 1,",  ", phylo.edge[i],"  ", phylo.edge[(phylo.edge.len / 2).toInt + i])
  else:
    echo("phylo.edge seems to be wrongly formated. Please check")

proc summary*(phylo: Phylo) =
  echo("Tree Summary:")
  echo(len(phylo.tip_label), " terminal Nodes (Tips)")
  echo(phylo.Nnode, " internal Nodes")
  if len(phylo.node_label) == 0:
    echo("No nodelabels found")
  else:
    echo(len(phylo.node_label), " Nodelabels")
  if len(phylo.edge_length) == 0:
    echo("No branchlengths found")
  else:
    echo(len(phylo.edge_length), " Branchlength values")
  echo(" ")
