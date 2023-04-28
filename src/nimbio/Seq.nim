# implementation of a Seq class holding biological sequence data
import hashes

type
  Seq* = object
    data*: string

# proc hash
# proc tomutable
# proc encode
 
proc newSeq*(s: string): Seq =
  var sequence: Seq
  sequence.data = s
  return sequence

proc echo*(self: Seq) =
  echo("Seq('",self.data,"')")

proc len*(self: Seq): int =
  return self.data.len 

proc ungap*(self: Seq): Seq =
  var ungapped: Seq
  for element in self.data:
    if element != '-':
      ungapped.data = ungapped.data & element
  return ungapped

proc `==`*(s1, s2: Seq): bool =
  if s1.data == s2.data:
    return true
  else:
    return false

proc `!=`*(s1, s2: Seq): bool =
  if s1.data != s2.data:
    return true
  else:
    return false

proc `+`*(s1, s2: Seq): Seq =
  newSeq(s1.data & s2.data)

proc `+`*(s1: Seq, s2: string): Seq =
  newSeq(s1.data & s2)

proc `&`*(s1, s2: Seq): Seq =
  newSeq(s1.data & s2.data)

proc `&`*(s1: Seq, s2: string): Seq =
  newSeq(s1.data & s2)

proc hash*(self: Seq): Hash =
  hash(self.data)
