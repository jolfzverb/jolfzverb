#!/bin/sed -f
# This sed script translates expedite output to table that can be imported to org mode
/^$/,${
  /evas speed/!d
  s/:/ |/
  b exit
}
s/^\(.*\) , \(.*\)$/\2 | \1/
:exit
