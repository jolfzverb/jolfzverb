#!/bin/sed -f
# input is in form of
# \([0-9]\+ [0-9]\+\)\+
# where each number is node in directed graph and each pair is connection in 
# that graph
# target is to find and print any cycle from that graph

# separate pairs
s/\([0-9]\+ [0-9]\+\) \?/\1;/g
s/;$//

s/^/</
s/$/>/
h

# first, we want to remove all non-circular parts of graph
:remove
/^<>$/{
  s/.*/NO CYCLE/
  b
}
#check if we need to break
/<>/{
  s/;$//
  G
  /^<>\(.*\)\n<\1>$/{
    s/<>//
    s/\n.*//
    b remove_finished
  }
  s/<>//
  s/\n.*//
  s/^/</
  s/$/>/
  h
}

s/<\([0-9]\+ [0-9]\+\);\?/\1</g

/ \([0-9]\+\)<.*\1 /!{
  s/.*</</
  b remove
}
s/\(.*\)\(<.*\)/\2\1;/
b remove

:remove_finished

# now everything we have is cycles
# select random one

s/^/</

s/<\([0-9]\+ [0-9]\+\);/\1</g

:move
/^\([0-9]\+\) .* \1</b found
s/\(.* \([0-9]\+\)\)\(<.*\)\(\2 [0-9]\+\);\?\(.*\)/\1;\4\3\5/
b move


:found
s/<.*//
s/ \([0-9]\+\);\1/ \1/g



