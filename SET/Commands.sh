#!/bin/bash

makeinput(){
    target=$1;
    finaldE=$2;
    ./SET-input.pl $target 0 0 0 $finaldE > test/${target}.in
    ./SET-mesh.pl $target > test/${target}-set.geo
    cd test && gmsh -3 ${target}-set.geo && cd -
}
