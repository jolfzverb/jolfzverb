#!/bin/sed -f
# Compare two values:
# if they are of form
# [0-9]\+ [0-9]\+ - use numeric comparison
# else - lexicographical
# return value is of form "lt|eq|gt"
# consult calc.sed for more details on how everything works, here I used same 
# approach

/^[0-9]\+ [0-9]\+$/{
  # numeric
  b numeric
}
b lexic

# return function
:_comp_return
# we assume pattern space of form:
# .*_comp:X:.*
# where X is second part of :_comp_X label

# to create new return address we need to copy following pattern:
#  /_comp:X:/{
#  # remove return address
#    s/_comp:X:/_comp:/
#  # jump to return address
#    b _comp_X
#  }

/_comp:num1:/{
  s/_comp:num1:/_comp:/
  b _comp_num1
}
/_comp:num2:/{
  s/_comp:num2:/_comp:/
  b _comp_num2
}
/_comp:val2:/{
  s/_comp:val2:/_comp:/
  b _comp_val2
}
/_comp:lex2:/{
  s/_comp:lex2:/_comp:/
  b _comp_lex2
}
# we are not jumping anywhere - remove everything and exit
s/_comp://
b _comp_end

:numeric
s/$/_comp:num1:/
s/^0*//
s/ 0*.*_comp://
s/^ /0 /
s/ _comp:/ 0_comp:/
b _comp_len
:_comp_num1
/^[0-9]\+ [0-9]\+_comp:/!{
  # we already found answer - return it
  b _comp_return
}
s/_comp:/_comp:num2:/
b _comp_val
:_comp_num2
b _comp_return


b

# compare integers based on length
# return either lt or gt or not leave input unchanged
:_comp_len
s/^\([0-9]\+\) \([0-9]\+\)_comp:/&\1:\2:/
:_comp_len1
/^ _comp:/{
  s/.*_comp:\([0-9]\+\):\([0-9]\+\):/\1 \2_comp:/
  b _comp_return
}
/^ /{
  s/.*_comp:[0-9]\+:[0-9]\+:/lt_comp:/
  b _comp_return
}
/ _comp:/{
  s/.*_comp:[0-9]\+:[0-9]\+:/gt_comp:/
  b _comp_return
}
s/^[0-9]//
s/ [0-9]\(.*_comp:\)/ \1/
b _comp_len1

# unreachable
b_comp_return

# compare two integers by value
:_comp_val
# we can assume they are of same length
s/^\([0-9]\+\) \([0-9]\+\)_comp:/_comp:\1:\2:/
:_comp_val1
/^_comp:::/{
  s/^_comp:::/eq_comp:/
  b _comp_return
}
s/_comp:\([0-9]\)\([^:]*\):\([0-9]\)\([^:]*\):/\1 \3_comp:val2:\2:\4:/
b _comp_2duz
:_comp_val2
/^0 0_comp:/{
  s/.*_comp:/_comp:/
  b _comp_val1
}
/^0 .*_comp:/{
  s/.*_comp:[^:]*:[^:]*:/lt_comp:/
  b _comp_return
}
/^.* 0_comp:/{
  s/.*_comp:[^:]*:[^:]*:/gt_comp:/
  b _comp_return
}

b_comp_return

# decrement 2 symbols untill we have at least one 0
:_comp_2duz
/|.*_comp:/b _comp_return
/0.*_comp:/b _comp_return
s/1 \(.*_comp:\)/0 \1/
s/ 1\(.*_comp:\)/ 0\1/
s/2 \(.*_comp:\)/1 \1/
s/ 2\(.*_comp:\)/ 1\1/
s/3 \(.*_comp:\)/2 \1/
s/ 3\(.*_comp:\)/ 2\1/
s/4 \(.*_comp:\)/3 \1/
s/ 4\(.*_comp:\)/ 3\1/
s/5 \(.*_comp:\)/4 \1/
s/ 5\(.*_comp:\)/ 4\1/
s/6 \(.*_comp:\)/5 \1/
s/ 6\(.*_comp:\)/ 5\1/
s/7 \(.*_comp:\)/6 \1/
s/ 7\(.*_comp:\)/ 6\1/
s/8 \(.*_comp:\)/7 \1/
s/ 8\(.*_comp:\)/ 7\1/
s/9 \(.*_comp:\)/8 \1/
s/ 9\(.*_comp:\)/ 8\1/
s/A \(.*_comp:\)/9 \1/
s/ A\(.*_comp:\)/ 9\1/
s/B \(.*_comp:\)/A \1/
s/ B\(.*_comp:\)/ A\1/
s/C \(.*_comp:\)/B \1/
s/ C\(.*_comp:\)/ B\1/
s/D \(.*_comp:\)/C \1/
s/ D\(.*_comp:\)/ C\1/
s/E \(.*_comp:\)/D \1/
s/ E\(.*_comp:\)/ D\1/
s/F \(.*_comp:\)/E \1/
s/ F\(.*_comp:\)/ E\1/
s/G \(.*_comp:\)/F \1/
s/ G\(.*_comp:\)/ F\1/
s/H \(.*_comp:\)/G \1/
s/ H\(.*_comp:\)/ G\1/
s/I \(.*_comp:\)/H \1/
s/ I\(.*_comp:\)/ H\1/
s/J \(.*_comp:\)/I \1/
s/ J\(.*_comp:\)/ I\1/
s/K \(.*_comp:\)/J \1/
s/ K\(.*_comp:\)/ J\1/
s/L \(.*_comp:\)/K \1/
s/ L\(.*_comp:\)/ K\1/
s/M \(.*_comp:\)/L \1/
s/ M\(.*_comp:\)/ L\1/
s/N \(.*_comp:\)/M \1/
s/ N\(.*_comp:\)/ M\1/
s/O \(.*_comp:\)/N \1/
s/ O\(.*_comp:\)/ N\1/
s/P \(.*_comp:\)/O \1/
s/ P\(.*_comp:\)/ O\1/
s/Q \(.*_comp:\)/P \1/
s/ Q\(.*_comp:\)/ P\1/
s/R \(.*_comp:\)/Q \1/
s/ R\(.*_comp:\)/ Q\1/
s/S \(.*_comp:\)/R \1/
s/ S\(.*_comp:\)/ R\1/
s/T \(.*_comp:\)/S \1/
s/ T\(.*_comp:\)/ S\1/
s/U \(.*_comp:\)/T \1/
s/ U\(.*_comp:\)/ T\1/
s/V \(.*_comp:\)/U \1/
s/ V\(.*_comp:\)/ U\1/
s/W \(.*_comp:\)/V \1/
s/ W\(.*_comp:\)/ V\1/
s/X \(.*_comp:\)/W \1/
s/ X\(.*_comp:\)/ W\1/
s/Y \(.*_comp:\)/X \1/
s/ Y\(.*_comp:\)/ X\1/
s/Z \(.*_comp:\)/Y \1/
s/ Z\(.*_comp:\)/ Y\1/
s/a \(.*_comp:\)/Z \1/
s/ a\(.*_comp:\)/ Z\1/
s/b \(.*_comp:\)/a \1/
s/ b\(.*_comp:\)/ a\1/
s/c \(.*_comp:\)/b \1/
s/ c\(.*_comp:\)/ b\1/
s/d \(.*_comp:\)/c \1/
s/ d\(.*_comp:\)/ c\1/
s/e \(.*_comp:\)/d \1/
s/ e\(.*_comp:\)/ d\1/
s/f \(.*_comp:\)/e \1/
s/ f\(.*_comp:\)/ e\1/
s/g \(.*_comp:\)/f \1/
s/ g\(.*_comp:\)/ f\1/
s/h \(.*_comp:\)/g \1/
s/ h\(.*_comp:\)/ g\1/
s/i \(.*_comp:\)/h \1/
s/ i\(.*_comp:\)/ h\1/
s/j \(.*_comp:\)/i \1/
s/ j\(.*_comp:\)/ i\1/
s/k \(.*_comp:\)/j \1/
s/ k\(.*_comp:\)/ j\1/
s/l \(.*_comp:\)/k \1/
s/ l\(.*_comp:\)/ k\1/
s/m \(.*_comp:\)/l \1/
s/ m\(.*_comp:\)/ l\1/
s/n \(.*_comp:\)/m \1/
s/ n\(.*_comp:\)/ m\1/
s/o \(.*_comp:\)/n \1/
s/ o\(.*_comp:\)/ n\1/
s/p \(.*_comp:\)/o \1/
s/ p\(.*_comp:\)/ o\1/
s/q \(.*_comp:\)/p \1/
s/ q\(.*_comp:\)/ p\1/
s/r \(.*_comp:\)/q \1/
s/ r\(.*_comp:\)/ q\1/
s/s \(.*_comp:\)/r \1/
s/ s\(.*_comp:\)/ r\1/
s/t \(.*_comp:\)/s \1/
s/ t\(.*_comp:\)/ s\1/
s/u \(.*_comp:\)/t \1/
s/ u\(.*_comp:\)/ t\1/
s/v \(.*_comp:\)/u \1/
s/ v\(.*_comp:\)/ u\1/
s/w \(.*_comp:\)/v \1/
s/ w\(.*_comp:\)/ v\1/
s/x \(.*_comp:\)/w \1/
s/ x\(.*_comp:\)/ w\1/
s/y \(.*_comp:\)/x \1/
s/ y\(.*_comp:\)/ x\1/
s/z \(.*_comp:\)/y \1/
s/ z\(.*_comp:\)/ y\1/
b _comp_2duz

b _comp_return
:lexic
/^[a-zA-Z0-9]\+ [a-zA-Z0-9]\+$/!{
  s/.*/not alnum, use letters and numbers/
  b _comp_end
}

s/^\(.*\) \(.*\)/_comp:\1:\2:/
:_comp_lex1

/^_comp:::/{
  s/^_comp:::/eq_comp:/
  b _comp_return
}

s/_comp:\([^:]\?\)\([^:]*\):\([^:]\?\)\([^:]*\):/\1 \3_comp:lex2:\2:\4:/
s/^ /| /
s/ _comp:/ |_comp:/
b _comp_2duz
:_comp_lex2
/^| |_comp:/{
  s/.*_comp:/_comp:/
  b _comp_lex1
}
/^| .*_comp:/{
  s/.*_comp:[^:]*:[^:]*:/lt_comp:/
  b _comp_return
}
/^.* |_comp:/{
  s/.*_comp:[^:]*:[^:]*:/gt_comp:/
  b _comp_return
}

/^0 0_comp:/{
  s/.*_comp:/_comp:/
  b _comp_lex1
}
/^0 .*_comp:/{
  s/.*_comp:[^:]*:[^:]*:/lt_comp:/
  b _comp_return
}
/^.* 0_comp:/{
  s/.*_comp:[^:]*:[^:]*:/gt_comp:/
  b _comp_return
}

b_comp_return

:_comp_end
