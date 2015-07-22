#!/bin/sed -f
# This script was written as reply to stackoverflow question

# Replace number XX from line
# "/data/2014/file300.data.20141231.MC.XX30.vgf.img"
# with decremented number (XX-1)
# zero is not changed

# copy filename to hold space
h
# remove everything that is not a number
s/.*MC\.//
s/30\.vgf.*//
# ensure that we don't have leading zeroes
s/^0*//
# here all the magic begins, decrementing

# we need to move all trailing zeroes to begin of number
# we do it using cycle:

# clear test condition
t b
: b
# if we have zero - move it
/0$/{
  # remove from end
  s/0$//
  # append to begin
  s/^/0/
}
# if substitution was made - continue cycle
t b

# now we have nonzero at the end, decrement it
s/1$/0/
s/2$/1/
s/3$/2/
s/4$/3/
s/5$/4/
s/6$/5/
s/7$/6/
s/8$/7/
s/9$/8/

# here we change number of digits in our number, this needs to be done only 
# when number was of type 10*, in that case after all our permutations it is 
# represented as line of all zeroes - just remove one.
/^0*$/s/0//

# another cycle to put zeroes back at end
t e
: e
/^0/{
  # remove from beginning
  s/^0//
  # add to end, as 9
  s/$/9/
}
t e
# Now we have decremented number in pattern space and original filename in hold
# format number as two-digit:
s/^$/00/
s/^.$/0&/
# append it to hold space
H
# switch hold and pattern 
x
# now we manipulate string like "$filename\nXX" where XX is our decremented
# number.
# Replace number in filename with decremented one
s/\(.*MC\.\)..\(30.*\).\(..\)/\1\3\2/
