#!/bin/bash

 grep "Total pot" */*.out | sed -e "s/\.out\:Total.*//"
