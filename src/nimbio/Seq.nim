# implementation of a Seq class holding biological sequence data
import hashes

type ## \
## *Basic datatype for biological sequence data.* 
##
## This contains only a singel field named data.
  Seq* = object
    data*: string

# proc hash
# proc tomutable
# proc encode
 
proc newSeq*(s: string): Seq =
  ## | Procedure to create new sequence from a string.    
  ## | Examples: 
  ## ```
  ## var seq = "AATCGTC".newSeq()
  ## var seq2 = newSeq("GGTTGN")
  ## ```

  var sequence: Seq
  sequence.data = s
  return sequence

proc echo*(self: Seq) =
  ## | Print a representation of a Seq object on screen.
  ## | Return value: nothing. 
  echo("Seq('",self.data,"')")

proc len*(self: Seq): int =
  ## | Returns the length of a Seq objects stored sequence.
  ## | Return value: int.
  return self.data.len 

proc ungap*(self: Seq): Seq =
  ## | Remove gaps encoded by - in a Seq object.
  ## | Return value: Seq
  var ungapped: Seq
  for element in self.data:
    if element != '-':
      ungapped.data = ungapped.data & element
  return ungapped

proc `==`*(s1, s2: Seq): bool =
  ## | Operator to check if the sequences contained in two Seq objects are identical.
  ## | Returns true if sequences are identical and false if sequences are different.
  if s1.data == s2.data:
    return true
  else:
    return false

proc `!=`*(s1, s2: Seq): bool =
  ## | Operator to check if the sequences contained in two Seq objects are different.
  ## | Returns true if sequences are different and false if sequences are identical.
  if s1.data == s2.data:
  if s1.data != s2.data:
    return true
  else:
    return false

proc `+`*(s1, s2: Seq): Seq =
  ## | Operator to combine the sequences of two Seq objects.
  ## | Returns a Seq object.
  newSeq(s1.data & s2.data)

proc `+`*(s1: Seq, s2: string): Seq =
  ## | Operator to add a string to a Seq object.
  ## | Returns a Seq object.
  newSeq(s1.data & s2)

proc `&`*(s1, s2: Seq): Seq =
  ## | Nim style operator to combine the sequences of two Seq objects.
  ## | Returns a Seq object.
  newSeq(s1.data & s2.data)

proc `&`*(s1: Seq, s2: string): Seq =
  ## | Nim style operator to add a string to a Seq object.
  ## | Returns a Seq object.
  newSeq(s1.data & s2)

proc hash*(self: Seq): Hash =
  hash(self.data)
