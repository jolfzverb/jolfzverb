#!/bin/sed -f
# Simple calculator implementation in sed:
# Integer unsigned mathematics with 4 operations (*/+-) and parentheses

# example:
# $ echo "(60/(4*5)+34*(2+3)/((3)*2))" | sed -f calc.sed
# 31

# parse expression
s/[[:space:]]//g
s/$/_calc:/

# first parse parentheses:
:_calc_paren2
/(/{
  # assume we have valid parentheses
  # select one of innermost expressions and parse it
  s/\(.*\)(\([^()]*\))\(.*\)_calc:/\2_calc:paren1:\1VAL\3/
  b _calc_parse
  :_calc_paren1
  # replace result
  s/\(.*\)_calc:\(.*\)VAL\(.*\)/\2\1\3_calc:/
  # find next paren
  b _calc_paren2
}

# parse operators
:_calc_parse
# first - all * and /
/[\*\/].*_calc:/{
  # isolate operator with arguments
  s/^\([^\*\/]*[+-]\)\?\([0-9]\+[\*\/][0-9]\+\)\(.*\)\(_calc:\)/\2\4\1VAL\3:/
  /\*.*_calc:/{
    # prepare arguments for multiplication
    s/\*/ /
    # set return address
    s/_calc:/&parse1:/
    # call multiplication function
    b calc_mul
  }
  /\/.*_calc:/{
    # prepare arguments for division
    s/\// /
    # set return address
    s/_calc:/&parse1:/
    # call division function
    b calc_div
  }
  # after multiplication and division control will be transfered here:
  :_calc_parse1
  # put result into expression
  s/\(.*\)\(_calc:\)\([^:]*\)VAL\([^:]*\):/\3\1\4\2/
  # and start new cycle
  b _calc_parse
}
# now we have no * and /, and can parse + and -
/[+-].*_calc:/{
  # isolate operator with argiments
  s/^\([0-9]\+[+-][0-9]\+\)\(.*\)\(_calc:\)/\1\3VAL\2:/
  /+.*_calc:/{
    # prepare arguments for addition
    s/+/ /
    # set return address
    s/_calc:/&parse2:/
    # call add function
    b calc_add
  }
  /-.*_calc:/{
    # prepare arguments for substraction
    s/-/ /
    # set return address
    s/_calc:/&parse2:/
    # call add function
    b calc_sub
  }
  :_calc_parse2
  # place result into expression
  s/\(.*\)\(_calc:\)VAL\([^:]*\):/\1\3\2/
  # new cycle
  b _calc_parse
}

# return function
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
  s/_calc:add1:/_calc:/
  b _calc_add1
}
/_calc:add2:/{
  s/_calc:add2:/_calc:/
  b _calc_add2
}
/_calc:sub1:/{
  s/_calc:sub1:/_calc:/
  b _calc_sub1
}
/_calc:sub2:/{
  s/_calc:sub2:/_calc:/
  b _calc_sub2
}
/_calc:parse1:/{
  s/_calc:parse1:/_calc:/
  b _calc_parse1
}
/_calc:parse2:/{
  s/_calc:parse2:/_calc:/
  b _calc_parse2
}
/_calc:mul2:/{
  s/_calc:mul2:/_calc:/
  b _calc_mul2
}
/_calc:mul3:/{
  s/_calc:mul3:/_calc:/
  b _calc_mul3
}
/_calc:div1:/{
  s/_calc:div1:/_calc:/
  b _calc_div1
}
/_calc:div2:/{
  s/_calc:div2:/_calc:/
  b _calc_div2
}
/_calc:div3:/{
  s/_calc:div3:/_calc:/
  b _calc_div3
}
/_calc:paren1:/{
  s/_calc:paren1:/_calc:/
  b _calc_paren1
}
# we are not jumping anywhere - remove everything and exit
s/_calc://
b calc_end

# increment function
: calc_inc
# one of base functions for all computations
# takes one argument, increments it by 1 and returns

# we assume pattern space of form:
# \d+_calc:.*
# remove leading zeroes
s/^0*//
# make sure number is non-empty
s/^\(_calc:\)/0\1/
# we have to handle 0 separately
/^0_calc:/{
  s/0/1/
  b calc_return
}
: _inc_b
# last digit is '9' - move it to beginning of number
/9_calc:/{
  s/9\(_calc:\)/\1/
  s/^/0/
}
# continue while there is 9 at end
t _inc_b

# now we can safely increment last digit
s/8\(_calc:\)/9\1/
s/7\(_calc:\)/8\1/
s/6\(_calc:\)/7\1/
s/5\(_calc:\)/6\1/
s/4\(_calc:\)/5\1/
s/3\(_calc:\)/4\1/
s/2\(_calc:\)/3\1/
s/1\(_calc:\)/2\1/
s/0\(_calc:\)/1\1/

# if number was of form '99*' it is now of form '0*1'
# and we need to add one more '0' to it
/^0*1_calc:/s/^/0/

# put all '0' back
: _inc_e
/^0/{
  s/^0//
  s/\(_calc:\)/0\1/
}
t _inc_e

# make sure we dont return empty number
s/^\(_calc:\)/0\1/
# return
b calc_return


# decrement function
: calc_dec
# same as increment - second base function for all computations

# we assume pattern space of form:
# \d+_calc:.*
# remove leading zeroes
s/^0*//
# make sure number is non-empty
s/^\(_calc:\)/0\1/
# again handle zero separately - dont change it as we have only unsigned math
/^0_calc:/b calc_return

# move trailing '0'
: _dec_b
/0_calc:/{
  s/0\(_calc:\)/\1/
  s/^/0/
}
t _dec_b

# decrement last digit
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
# represented as line of all zeroes - so just remove one.
/^0*_calc:/s/0//

# put all '0' back, but change it to 9
: _dec_e
/^0/{
  s/^0//
  s/_calc:/9&/
}
t _dec_e

# make sure we dont return empty number
s/^\(_calc:\)/0\1/
# return
b calc_return

# addition function
:calc_add
# we assume pattern space of form:
# \d+ \d+_calc:.*

# we will be incrementing one number and decrementing the other one
s/ \(.*\)_calc:/_calc:\1:/
:_calc_addn
  # set return address
  s/_calc:/_calc:add1:/
  # call increment
  b calc_inc
  : _calc_add1
  # swap numbers
  s/\(.*\)_calc:\([^:]*\):/\2_calc:\1:/
  # set return address
  s/_calc:/_calc:add2:/
  # call decrement
  b calc_dec
  : _calc_add2
  # if not zero - continue
  /^0_calc:/!{
    # swap numbers
    s/\(.*\)_calc:\([^:]*\):/\2_calc:\1:/
    b _calc_addn
  }
# set returned value
s/\(.*\)_calc:\([^:]*\):/\2_calc:/

# return
b calc_return

# substract function
:calc_sub
# we assume pattern space of form:
# \d+ \d+_calc:.*

# we will be decrementing both numbers untill second one is zero
s/ \(.*\)_calc:/_calc:\1:/
:_calc_subn
  # set return address
  s/_calc:/_calc:sub1:/
  # call decrement
  b calc_dec
  : _calc_sub1
  # swap numbers
  s/\(.*\)_calc:\([^:]*\):/\2_calc:\1:/
  # set return address
  s/_calc:/_calc:sub2:/
  # call decrement
  b calc_dec
  : _calc_sub2
  # if not zero - continue
  /^0_calc:/!{
    s/\(.*\)_calc:\([^:]*\):/\2_calc:\1:/
    b _calc_subn
  }
# set returned value
s/\(.*\)_calc:\([^:]*\):/\2_calc:/

# return
b calc_return

# multiplication function
:calc_mul
# we assume pattern space of form:
# \d+ \d+_calc:.*

# initial state:
# a b_calc:
# initialaze sum as 0
# on each iteration:
# sum a_calc:b:a === call add
# b_calc:sum:a   === call dec
# if b != 0 continue

# initial setup
s/\([0-9]\+\) \([0-9]\+\)_calc:/0_calc:\2:\1:/
:_calc_mul1
# if b == 0
/_calc:0:/{
  # cleanup for return
  s/_calc:[0-9]\+:[0-9]\+:/_calc:/
  b calc_return
}
# prepare arguments and return address for addition
s/^\([0-9]\+\)_calc:\([0-9]\+\):\([0-9]\+\):/\1 \3_calc:mul2:\2:\3:/

b calc_add
:_calc_mul2

# prepare argument and return address for decrement
s/^\([0-9]\+\)_calc:\([0-9]\+\):\([0-9]\+\):/\2_calc:mul3:\1:\3:/
b calc_dec
:_calc_mul3

# back to initial setup
s/^\([0-9]\+\)_calc:\([0-9]\+\):\([0-9]\+\):/\2_calc:\1:\3:/
b _calc_mul1

# cannot be reached
b calc_return

# division function
:calc_div
# we assume pattern space of form:
# \d+ \d+_calc:.*

# initial configuration:
# a b_calc:

# on each iteration:
# a b_calc:counter(0):b: === call sub
# counter_calc:a:b:      === call increment
# until a nonzero

# workaround for correct calculations, increment a:
s/\([0-9]\+\) \([0-9]\+\)_calc:/\1_calc:div3:\1:\2:/
b calc_inc
:_calc_div3

# place counter and numbers:
s/^\([0-9]\+\)_calc:\([0-9]\+\):\([0-9]\+\):/0_calc:\1:\3:/


:_calc_div1
# prepare substraction arguments
s/^\([0-9]\+\)_calc:\([0-9]\+\):\([0-9]\+\):/\2 \3_calc:div2:\1:\3:/
b calc_sub
:_calc_div2

# if a reached 0 - return
/^0_calc:/{
  # place return value in right spot
  s/^\([0-9]\+\)_calc:\([0-9]\+\):\([0-9]\+\):/\2_calc:/
  # return
  b calc_return
}
# a is nonzero - increment counter and return to beginning of cycle
s/^\([0-9]\+\)_calc:\([0-9]\+\):\([0-9]\+\):/\2_calc:div1:\1:\3:/
b calc_inc

# unreachable
b calc_return

# finised
:calc_end
