#!/bin/bash

echo "Generate how many keys? $1"
of="$(pwd)/data/keys.txt";

cat /dev/urandom | tr -dc '0-9a-zA-Z' | fold -w 10 | head -n $1 > $of;
