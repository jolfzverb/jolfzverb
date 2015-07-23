#!/bin/sed -f
# Sort list of values, separated by space
# be careful, two numbers will be compared algebraically, two words, number and
# word - alpanumerically

# return value is sorted list

# consult calc.sed for more details on how everything works, here I used same
# approach
# comparison functions taken from compare.sed with small changes

/^\([a-zA-Z0-9]\+ \?\)\+$/!{
  s/.*/not alnum, use letters and numbers/
  b _sort_end
}
s/$/_sort:/

s/^\(.*\)_sort:/_sort:::<>\1::/
:_sort_sort1
s/ :/:/g
s/: /:/g
s/ </</g
s/> />/g
/_sort:::<>[^:]* [^:]*:/!{
  # one last number
  s/.*_sort:::<>\([^:]*\):\([^:]*\):/\2 \1_sort:/
  s/^ *//
  s/ *_sort:/_sort:/
  b _sort_return
}
# take first number - first element
s/_sort:::<>\([^ :]\+\) \([^:]\+\):/_sort:\1::<>\2:/
# take second number - first element
s/_sort:\([^:]*\)::<>\([^ :]\+\) \?\([^:]*\):/_sort:\1:\2:<>\3:/

:_sort_sort3
s/ :/:/g
s/: /:/g
s/ </</g
s/> />/g
# prepare arguments for compare
s/_sort:\([^:]*\):\([^:]*\):/\1 \2&/
s/_sort:/&sort2:/
b _sort_compare
:_sort_sort2
/<>:/{
  /^gt_sort:/{
    s/.*_sort:\([^:]*\):\([^:]*\):\([^:]*\)<>:\([^:]*\):/_sort:::<>\1 \3:\4 \2:/
    b _sort_sort1
  }
  s/.*_sort:\([^:]*\):\([^:]*\):\([^:]*\)<>:\([^:]*\):/_sort:::<>\2 \3:\4 \1:/
  b _sort_sort1
}


/^gt_sort:/{
  s/.*_sort:\([^:]*\):\([^:]*\):\([^:]*\)<>\([^:]*\):/_sort:\2::\3 \1<>\4:/
  s/_sort:\([^:]*\)::\([^:]*\)<>\([^: ]*\) \?\([^:]*\):/_sort:\1:\3:\2<>\4:/
  b _sort_sort3
}
s/.*_sort:\([^:]*\):\([^:]*\):\([^:]*\)<>\([^:]*\):/_sort:\1::\3 \2<>\4:/
s/_sort:\([^:]*\)::\([^:]*\)<>\([^: ]*\) \?\([^:]*\):/_sort:\1:\3:\2<>\4:/
b _sort_sort3



b _sort_return


:_sort_compare
/^[0-9]\+ [0-9]\+_sort:/{
  # numeric
  b numeric
}
b lexic

# return function
:_sort_return
# we assume pattern space of form:
# .*_sort:X:.*
# where X is second part of :_sort_X label

# to create new return address we need to copy following pattern:
#  /_sort:X:/{
#  # remove return address
#    s/_sort:X:/_sort:/
#  # jump to return address
#    b _sort_X
#  }

/_sort:num1:/{
  s/_sort:num1:/_sort:/
  b _sort_num1
}
/_sort:num2:/{
  s/_sort:num2:/_sort:/
  b _sort_num2
}
/_sort:val2:/{
  s/_sort:val2:/_sort:/
  b _sort_val2
}
/_sort:lex2:/{
  s/_sort:lex2:/_sort:/
  b _sort_lex2
}
/_sort:sort2:/{
  s/_sort:sort2:/_sort:/
  b _sort_sort2
}
# we are not jumping anywhere - remove everything and exit
s/_sort://
b _sort_end

:numeric
s/^0*//
s/ 0*\(.*_sort:\)/ \1/
s/^ /0 /
s/ _sort:/ 0_sort:/
s/_sort:/_sort:num1:/
b _sort_len
:_sort_num1
/^[0-9]\+ [0-9]\+_sort:/!{
  # we already found answer - return it
  b _sort_return
}
s/_sort:/_sort:num2:/
b _sort_val
:_sort_num2

b _sort_return


b

# compare integers based on length
# return either lt or gt or not leave input unchanged
:_sort_len
s/^\([0-9]\+\) \([0-9]\+\)_sort:/&\1:\2:/
:_sort_len1
/^ _sort:/{
  s/.*_sort:\([0-9]\+\):\([0-9]\+\):/\1 \2_sort:/
  b _sort_return
}
/^ /{
  s/.*_sort:[0-9]\+:[0-9]\+:/lt_sort:/
  b _sort_return
}
/ _sort:/{
  s/.*_sort:[0-9]\+:[0-9]\+:/gt_sort:/
  b _sort_return
}
s/^[0-9]//
s/ [0-9]\(.*_sort:\)/ \1/
b _sort_len1

# unreachable
b_sort_return

# compare two integers by value
:_sort_val
# we can assume they are of same length
s/^\([0-9]\+\) \([0-9]\+\)_sort:/_sort:\1:\2:/
:_sort_val1
/^_sort:::/{
  s/^_sort:::/eq_sort:/
  b _sort_return
}
s/_sort:\([0-9]\)\([^:]*\):\([0-9]\)\([^:]*\):/\1 \3_sort:val2:\2:\4:/
b _sort_2duz
:_sort_val2
/^0 0_sort:/{
  s/.*_sort:/_sort:/
  b _sort_val1
}
/^0 .*_sort:/{
  s/.*_sort:[^:]*:[^:]*:/lt_sort:/
  b _sort_return
}
/^.* 0_sort:/{
  s/.*_sort:[^:]*:[^:]*:/gt_sort:/
  b _sort_return
}

b_sort_return

# decrement 2 symbols untill we have at least one 0
:_sort_2duz
/|.*_sort:/b _sort_return
/0.*_sort:/b _sort_return
s/1 \(.*_sort:\)/0 \1/
s/ 1\(.*_sort:\)/ 0\1/
s/2 \(.*_sort:\)/1 \1/
s/ 2\(.*_sort:\)/ 1\1/
s/3 \(.*_sort:\)/2 \1/
s/ 3\(.*_sort:\)/ 2\1/
s/4 \(.*_sort:\)/3 \1/
s/ 4\(.*_sort:\)/ 3\1/
s/5 \(.*_sort:\)/4 \1/
s/ 5\(.*_sort:\)/ 4\1/
s/6 \(.*_sort:\)/5 \1/
s/ 6\(.*_sort:\)/ 5\1/
s/7 \(.*_sort:\)/6 \1/
s/ 7\(.*_sort:\)/ 6\1/
s/8 \(.*_sort:\)/7 \1/
s/ 8\(.*_sort:\)/ 7\1/
s/9 \(.*_sort:\)/8 \1/
s/ 9\(.*_sort:\)/ 8\1/
s/A \(.*_sort:\)/9 \1/
s/ A\(.*_sort:\)/ 9\1/
s/B \(.*_sort:\)/A \1/
s/ B\(.*_sort:\)/ A\1/
s/C \(.*_sort:\)/B \1/
s/ C\(.*_sort:\)/ B\1/
s/D \(.*_sort:\)/C \1/
s/ D\(.*_sort:\)/ C\1/
s/E \(.*_sort:\)/D \1/
s/ E\(.*_sort:\)/ D\1/
s/F \(.*_sort:\)/E \1/
s/ F\(.*_sort:\)/ E\1/
s/G \(.*_sort:\)/F \1/
s/ G\(.*_sort:\)/ F\1/
s/H \(.*_sort:\)/G \1/
s/ H\(.*_sort:\)/ G\1/
s/I \(.*_sort:\)/H \1/
s/ I\(.*_sort:\)/ H\1/
s/J \(.*_sort:\)/I \1/
s/ J\(.*_sort:\)/ I\1/
s/K \(.*_sort:\)/J \1/
s/ K\(.*_sort:\)/ J\1/
s/L \(.*_sort:\)/K \1/
s/ L\(.*_sort:\)/ K\1/
s/M \(.*_sort:\)/L \1/
s/ M\(.*_sort:\)/ L\1/
s/N \(.*_sort:\)/M \1/
s/ N\(.*_sort:\)/ M\1/
s/O \(.*_sort:\)/N \1/
s/ O\(.*_sort:\)/ N\1/
s/P \(.*_sort:\)/O \1/
s/ P\(.*_sort:\)/ O\1/
s/Q \(.*_sort:\)/P \1/
s/ Q\(.*_sort:\)/ P\1/
s/R \(.*_sort:\)/Q \1/
s/ R\(.*_sort:\)/ Q\1/
s/S \(.*_sort:\)/R \1/
s/ S\(.*_sort:\)/ R\1/
s/T \(.*_sort:\)/S \1/
s/ T\(.*_sort:\)/ S\1/
s/U \(.*_sort:\)/T \1/
s/ U\(.*_sort:\)/ T\1/
s/V \(.*_sort:\)/U \1/
s/ V\(.*_sort:\)/ U\1/
s/W \(.*_sort:\)/V \1/
s/ W\(.*_sort:\)/ V\1/
s/X \(.*_sort:\)/W \1/
s/ X\(.*_sort:\)/ W\1/
s/Y \(.*_sort:\)/X \1/
s/ Y\(.*_sort:\)/ X\1/
s/Z \(.*_sort:\)/Y \1/
s/ Z\(.*_sort:\)/ Y\1/
s/a \(.*_sort:\)/Z \1/
s/ a\(.*_sort:\)/ Z\1/
s/b \(.*_sort:\)/a \1/
s/ b\(.*_sort:\)/ a\1/
s/c \(.*_sort:\)/b \1/
s/ c\(.*_sort:\)/ b\1/
s/d \(.*_sort:\)/c \1/
s/ d\(.*_sort:\)/ c\1/
s/e \(.*_sort:\)/d \1/
s/ e\(.*_sort:\)/ d\1/
s/f \(.*_sort:\)/e \1/
s/ f\(.*_sort:\)/ e\1/
s/g \(.*_sort:\)/f \1/
s/ g\(.*_sort:\)/ f\1/
s/h \(.*_sort:\)/g \1/
s/ h\(.*_sort:\)/ g\1/
s/i \(.*_sort:\)/h \1/
s/ i\(.*_sort:\)/ h\1/
s/j \(.*_sort:\)/i \1/
s/ j\(.*_sort:\)/ i\1/
s/k \(.*_sort:\)/j \1/
s/ k\(.*_sort:\)/ j\1/
s/l \(.*_sort:\)/k \1/
s/ l\(.*_sort:\)/ k\1/
s/m \(.*_sort:\)/l \1/
s/ m\(.*_sort:\)/ l\1/
s/n \(.*_sort:\)/m \1/
s/ n\(.*_sort:\)/ m\1/
s/o \(.*_sort:\)/n \1/
s/ o\(.*_sort:\)/ n\1/
s/p \(.*_sort:\)/o \1/
s/ p\(.*_sort:\)/ o\1/
s/q \(.*_sort:\)/p \1/
s/ q\(.*_sort:\)/ p\1/
s/r \(.*_sort:\)/q \1/
s/ r\(.*_sort:\)/ q\1/
s/s \(.*_sort:\)/r \1/
s/ s\(.*_sort:\)/ r\1/
s/t \(.*_sort:\)/s \1/
s/ t\(.*_sort:\)/ s\1/
s/u \(.*_sort:\)/t \1/
s/ u\(.*_sort:\)/ t\1/
s/v \(.*_sort:\)/u \1/
s/ v\(.*_sort:\)/ u\1/
s/w \(.*_sort:\)/v \1/
s/ w\(.*_sort:\)/ v\1/
s/x \(.*_sort:\)/w \1/
s/ x\(.*_sort:\)/ w\1/
s/y \(.*_sort:\)/x \1/
s/ y\(.*_sort:\)/ x\1/
s/z \(.*_sort:\)/y \1/
s/ z\(.*_sort:\)/ y\1/
b _sort_2duz

b _sort_return
:lexic
s/^\(.*\) \(.*\)_sort:/_sort:\1:\2:/
:_sort_lex1

/^_sort:::/{
  s/^_sort:::/eq_sort:/
  b _sort_return
}

s/_sort:\([^:]\?\)\([^:]*\):\([^:]\?\)\([^:]*\):/\1 \3_sort:lex2:\2:\4:/
s/^ /| /
s/ _sort:/ |_sort:/
b _sort_2duz
:_sort_lex2
/^| |_sort:/{
  s/.*_sort:/_sort:/
  b _sort_lex1
}
/^| .*_sort:/{
  s/.*_sort:[^:]*:[^:]*:/lt_sort:/
  b _sort_return
}
/^.* |_sort:/{
  s/.*_sort:[^:]*:[^:]*:/gt_sort:/
  b _sort_return
}

/^0 0_sort:/{
  s/.*_sort:/_sort:/
  b _sort_lex1
}
/^0 .*_sort:/{
  s/.*_sort:[^:]*:[^:]*:/lt_sort:/
  b _sort_return
}
/^.* 0_sort:/{
  s/.*_sort:[^:]*:[^:]*:/gt_sort:/
  b _sort_return
}

b_sort_return




:_sort_end
