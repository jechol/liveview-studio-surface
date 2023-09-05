#!/usr/bin/env bash

rg -l '(data|prop|slot)\(.*\)$' | xargs sed -i '' -E 's/^( +)(prop|data|slot|attr)\((.*)\)$/\1\2 \3/g'
