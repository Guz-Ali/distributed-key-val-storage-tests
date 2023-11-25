#!/bin/bash

echo "Input the number of values to generate: $1"
of='values.txt'

cat /dev/urandom | tr -dc '0-9a-zA-Z' | fold -w 90 | head -n $1 > $of;
