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

b calc_route
:calc_route
# we assume "function" to return to is ":_calc_xxx" which is unambiguous and 
# stored in beginning of hold space.

x
/^_calc_add1/{
s/_calc_add1//
x
b _calc_add1
}
/^_calc_add2/{
s/_calc_add2//
x
b _calc_add2
}
/^_calc_sub1/{
s/_calc_sub1//
x
b _calc_sub1
}
/^_calc_sub2/{
s/_calc_sub2//
x
b _calc_sub2
}

x
b calc_end

# increment
: calc_inc
# remove leading zeroes
s/^0*//
# make sure number is non-empty
s/^$/0/
# clear test condition
/^0$/{
s/0/1/
b calc_route
}
t _inc_b
: _inc_b
# if we have zero - move it
/9$/{
  # remove from end
  s/9$//
  # append to begin
  s/^/0/
}
# if substitution was made - continue cycle
t _inc_b
# now we have nonzero at the end, decrement it
s/8$/9/
s/7$/8/
s/6$/7/
s/5$/6/
s/4$/5/
s/3$/4/
s/2$/3/
s/1$/2/
s/0$/1/

# here we change number of digits in our number, this needs to be done only 
# when number was of type 10*, in that case after all our permutations it is 
# represented as line of all zeroes - just remove one.
/^0*1$/s/^/0/

# another cycle to put zeroes back at end
t _inc_e
: _inc_e
/^0/{
  # remove from beginning
  s/^0//
  # add to end
  s/$/0/
}
t _inc_e

b calc_route


# decrement
: calc_dec
# remove leading zeroes
s/^0*//
# make sure number is non-empty
s/^$/0/
/^0$/b calc_route
# clear test condition
t _dec_b
: _dec_b
# if we have zero - move it
/0$/{
  # remove from end
  s/0$//
  # append to begin
  s/^/0/
}
# if substitution was made - continue cycle
t _dec_b

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
t _dec_e
: _dec_e
/^0/{
  # remove from beginning
  s/^0//
  # add to end, as 9
  s/$/9/
}
t _dec_e
s/^$/0/
b calc_route

:calc_add
h
s/ .*//
x
s/.* //
:_calc_add3
x
/^0$/!{
  x
  s/^/_calc_add1/
  x
  b calc_dec
  : _calc_add1
  s/^/_calc_add2/
  x
  b calc_inc
  : _calc_add2
  b _calc_add3
}
s/.*//
x
b calc_end

:calc_sub
h
s/ .*//
#a
x
#b
s/.* //
:_calc_sub3
/^0$/!{
#b
  s/^/_calc_sub1/
  x
#a
  # decrement first
  b calc_dec
  : _calc_sub1
  s/^/_calc_sub2/
  x
#b
  b calc_dec
  : _calc_sub2
  b _calc_sub3
}
s/.*//
x
b calc_end

:calc_end
