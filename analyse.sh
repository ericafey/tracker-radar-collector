#!/usr/bin/bash
outputFile="data/output.txt"
> $outputFile

for i in data/100/*; do
  if [[ $(file --extension -b $i)!="jpeg/jpg/jpe/jfif" && $i != "metadata.json" ]]; then
    #check file for "getSelection" and get the name of the file printed to output   
    if [[ $(grep -o "getSelection" $i | wc -l) -gt 1 ]]; then
        echo $i >> $outputFile
    fi 
  fi
done

