#!/bin/sed -f
# This script was written as proof of concept for writing a for cycle in sed.
# Initial counter is passed in pattern space and cycle continues untill it
# reaches 0 decrementing the counter by one on each iteration.

# Here I just print counter on each iteration, but you can do whatever you
# want.
:a
  s/^0*//
  t b
  :b
    /0$/{
      s/0$//
      s/^/0/
    }
  t b
  s/1$/0/
  s/2$/1/
  s/3$/2/
  s/4$/3/
  s/5$/4/
  s/6$/5/
  s/7$/6/
  s/8$/7/
  s/9$/8/
  /^0*$/s/0//
  t e
  :e
    /^0/{
      s/^0//
      s/$/9/
    }
  t e
  /^$/s/$/0/
  p
/^0$/!b a
