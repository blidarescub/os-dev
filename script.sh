#!/bin/bash

for f in *.bin; do mv "$f" "${f/.bin/.img}";done
