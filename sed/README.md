# sed
Experiments with sed

## calc.sed
simple expression parser, unsigned integer math is supported
implemented operators: \*/+-()

### example:
$ echo "(60/(4\*5)+34\*(2+3)/((3)\*2))" | sed -f calc.sed
31


## compare.sed
simple comparison function, string and numerical comparison is supported,
two numbers are compared mumerically, other combinations - as strings

### example:
$ echo "b00 b000" | sed -f compare.sed
lt
$ echo "1222 1222" | sed -f compare.sed
eq
#### integer:
$ echo "1222 432" | sed -f compare.sed
gt
#### string:
$ echo "1222 43s" | sed -f compare.sed
lt


## sort.sed
Sort list of values, separated by space. It was written on top of comparison.
WARNING: Two numbers will be compared numerically, two words, number and 
word - as strings, this can break sorting sometimes. So make sure you are using 
either strings or numbers, not both.
Returns sorted list

### example:
$ echo "b00 b000 asd 12 asdf ca 000" | sed -f sort.sed                                                                                                                                    
000 12 asd asdf b00 b000 ca


## countdown.sed
This script was written as proof of concept for writing a for cycle in sed.
Initial counter is passed in pattern space and cycle continues untill it 
reaches 0 decrementing the counter by one on each iteration.


## decrement.sed
This script was written as reply to stackoverflow question and contains 
decrement example


## graph\_cycle.sed
Script for finding cycle in graph


