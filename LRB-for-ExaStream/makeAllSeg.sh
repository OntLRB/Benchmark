#!/bin/bash
# 2 Highways with 2 directions
for i in {0..99}; do echo "0,0,$i"; done > $1 
for i in {0..99}; do echo "0,1,$i"; done >> $1 
for i in {0..99}; do echo "1,0,$i"; done >> $1 
for i in {0..99}; do echo "1,1,$i"; done >> $1 