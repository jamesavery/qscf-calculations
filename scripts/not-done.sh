#!/bin/bash

 grep "Total pot" */*.out | sed -e "s/\.out\:Total.*//" > /tmp/DONE
 ls */*.in | sed -e "s/.in$//" > /tmp/ALL
 diff /tmp/DONE /tmp/ALL | grep ">" | sed -e "s/> //"
