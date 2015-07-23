# This script is taken from
# http://unix.stackexchange.com/questions/36949/addition-with-sed
# as example of addition/substraction
s/[0-9]/<&/g
s/0//gp
s/1/|/gp
s/2/||/gp
s/3/|||/gp
s/4/||||/gp
s/5/|||||/gp
s/6/||||||/gp
s/7/|||||||/gp
s/8/||||||||/gp
s/9/|||||||||/gp
: tens
s/|</<||||||||||/gp
t tens
s/<//gp
s/+//gp
: minus
s/|-|/-/gp
t minus
s/-$//
: back
s/||||||||||/</gp
s/<\([0-9]*\)$/<0\1/
s/|||||||||/9/; s/||||||||/8/; s/|||||||/7/; s/||||||/6/; s/|||||/5/; s/||||/4/
s/|||/3/; s/||/2/; s/|/1/
s/</|/gp
t back
