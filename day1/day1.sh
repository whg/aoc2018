#!/bin/bash

inputfile=$1

echo -n "part a: "
echo 0$(paste -s -d '' < $inputfile) | bc


looped="looped.txt"
prefix="total"

for _ in {1..1000}; do
    cat $inputfile >> $looped
done

nlines=$(wc -l $looped | cut -d ' ' -f 1)
duplicate="no duplicate found"

for i in $(seq 1 $nlines); do
    total="$(echo 0$(head -n $i $looped | paste -s -d '') | bc)"
    file="$prefix$total"
    if [ -f $file ]; then
        duplicate=$total
        break
    else
        touch $file
    fi
done

rm $looped
rm $prefix*

echo -n "part b: "
echo $duplicate
