#!/bin/bash
for file in ./*; do
    if [ -L "$file" ]; then
        actual_file=$(readlink -f "$file")
        cp -Lvf "$actual_file" "$file"
    fi
done
