#!/usr/bin/bash
current_path=$(pwd)
sed 's/^[0-9]*,/https:\/\/www./' "tranco/top-1m.csv" | head -n 100 > "tranco/top-$1.txt"