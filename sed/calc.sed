#!/bin/sed -f
# writing calculator in sed

# To use calculator routines you should place arguments in pattern space and 
# jump to appropriate routine:
# $ echo "15" sed -f calc.sed "b calc_inc"
# will print out 16

# $ echo "15 16" sed -f calc.sed "b calc_add"
# will print out 31

# increment and decrement does not use hold space, add and sub in current 
# implementation does clobber hold space.

# parse expression
# we will know about + - * / ()
s/$/_calc:/


:_calc_parse
# no paren
/[\*\/].*_calc:/{
  s/^\([^\*\/]*[+-]\)\?\([0-9]\+[\*\/][0-9]\+\)\(.*\)\(_calc:\)/\2\4\1VAL\3:/
  /\*.*_calc:/{
    s/\*/ /
    s/_calc:/&parse1:/
    b calc_mul
  }
  /\/.*_calc:/{
    s/\// /
    s/_calc:/&parse1:/
    b calc_div
  }
  :_calc_parse1
  s/\(.*\)\(_calc:\)\([^:]*\)VAL\([^:]*\):/\3\1\4\2/
  b _calc_parse
}
/[+-].*_calc:/{
  s/^\([0-9]\+[+-][0-9]\+\)\(.*\)\(_calc:\)/\1\3VAL\2:/
  /+.*_calc:/{
    s/+/ /
    s/_calc:/&parse2:/
    b calc_add
  }
  /-.*_calc:/{
    s/-/ /
    s/_calc:/&parse2:/
    b calc_sub
  }
  :_calc_parse2
  s/\(.*\)\(_calc:\)VAL\([^:]*\):/\1\3\2/
  b _calc_parse
}



b calc_return
:calc_return
# we assume pattern space of form:
# .*_calc:X:.*
# where X is second part of :_calc_X label

# to create new return address we need to copy following pattern:
#  /_calc:X:/{
#  # remove return address
#    s/_calc:X:/_calc:/
#  # jump to return address
#    b _calc_X
#  }

/_calc:add1:/{
# remove return address
  s/_calc:add1:/_calc:/
# jump to return address
  b _calc_add1
}
/_calc:add2:/{
# remove return address
  s/_calc:add2:/_calc:/
# jump to return address
  b _calc_add2
}
/_calc:sub1:/{
# remove return subress
  s/_calc:sub1:/_calc:/
# jump to return subress
  b _calc_sub1
}
/_calc:sub2:/{
# remove return subress
  s/_calc:sub2:/_calc:/
# jump to return subress
  b _calc_sub2
}
/_calc:parse1:/{
# remove return parseress
  s/_calc:parse1:/_calc:/
# jump to return parseress
  b _calc_parse1
}
/_calc:parse2:/{
# remove return parseress
  s/_calc:parse2:/_calc:/
# jump to return parseress
  b _calc_parse2
}
s/_calc://
b calc_end

# increment
: calc_inc
# we assume pattern space of form:
# \d+_calc:.*
# remove leading zeroes
s/^0*//
# make sure number is non-empty
s/^\(_calc:\)/0\1/
/^0_calc:/{
s/0/1/
b calc_return
}
# clear test condition
t _inc_b
: _inc_b
# if we have 9 - move it
/9_calc:/{
  # remove from end
  s/9\(_calc:\)/\1/
  # append to begin
  s/^/0/
}
# if substitution was made - continue cycle
t _inc_b
# now we have nonzero at the end, decrement it
s/8\(_calc:\)/9\1/
s/7\(_calc:\)/8\1/
s/6\(_calc:\)/7\1/
s/5\(_calc:\)/6\1/
s/4\(_calc:\)/5\1/
s/3\(_calc:\)/4\1/
s/2\(_calc:\)/3\1/
s/1\(_calc:\)/2\1/
s/0\(_calc:\)/1\1/

/^0*1_calc:/s/^/0/

t _inc_e
: _inc_e
/^0/{
  # remove from beginning
  s/^0//
  # add to end
  s/\(_calc:\)/0\1/
}
t _inc_e

s/^\(_calc:\)/0\1/
b calc_return


# decrement
: calc_dec
# we assume pattern space of form:
# \d+_calc:.*
# remove leading zeroes
s/^0*//
# make sure number is non-empty
s/^\(_calc:\)/0\1/
/^0_calc:/b calc_return
# clear test condition
t _dec_b
: _dec_b
# if we have zero - move it
/0_calc:/{
  # remove from end
  s/0\(_calc:\)/\1/
  # append to begin
  s/^/0/
}
# if substitution was made - continue cycle
t _dec_b

# now we have nonzero at the end, decrement it
s/1\(_calc:\)/0\1/
s/2\(_calc:\)/1\1/
s/3\(_calc:\)/2\1/
s/4\(_calc:\)/3\1/
s/5\(_calc:\)/4\1/
s/6\(_calc:\)/5\1/
s/7\(_calc:\)/6\1/
s/8\(_calc:\)/7\1/
s/9\(_calc:\)/8\1/

# here we change number of digits in our number, this needs to be done only 
# when number was of type 10*, in that case after all our permutations it is 
# represented as line of all zeroes - just remove one.
/^0*_calc:/s/0//

# another cycle to put zeroes back at end
t _dec_e
: _dec_e
/^0/{
  # remove from beginning
  s/^0//
  # add to end, as 9
  s/_calc:/9&/
}
t _dec_e
s/^\(_calc:\)/0\1/
b calc_return

:calc_add
# we assume pattern space of form:
# \d+ \d+_calc:.*
# we will be incrementing one number and decrementing the other one
s/ \(.*\)_calc:/_calc:\1:/
:_calc_addn
# set return address
s/_calc:/_calc:add1:/
b calc_inc
: _calc_add1
# swap numbers
s/\(.*\)_calc:\([^:]*\):/\2_calc:\1:/
# set return address
s/_calc:/_calc:add2:/
b calc_dec
: _calc_add2
/^0_calc:/!{
  s/\(.*\)_calc:\([^:]*\):/\2_calc:\1:/
  b _calc_addn
}
s/\(.*\)_calc:\([^:]*\):/\2_calc:/

b calc_return





:calc_sub
# we assume pattern space of form:
# \d+ \d+_calc:.*

# we will be incrementing one number and decrementing the other one
s/ \(.*\)_calc:/_calc:\1:/
:_calc_subn
# set return address
s/_calc:/_calc:sub1:/
b calc_dec
: _calc_sub1
# swap numbers
s/\(.*\)_calc:\([^:]*\):/\2_calc:\1:/
# set return address
s/_calc:/_calc:sub2:/
b calc_dec
: _calc_sub2
/^0_calc:/!{
  s/\(.*\)_calc:\([^:]*\):/\2_calc:\1:/
  b _calc_subn
}
s/\(.*\)_calc:\([^:]*\):/\2_calc:/

b calc_return
:calc_mul
# we assume pattern space of form:
# \d+ \d+_calc:.*
# for now - just remove second number
s/ .*_calc:/_calc:/
b calc_return

:calc_div
# we assume pattern space of form:
# \d+ \d+_calc:.*
# for now - just remove second number
s/ .*_calc:/_calc:/
b calc_return

:calc_end
