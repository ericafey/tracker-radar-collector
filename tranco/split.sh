#!/usr/bin/bash
partSizes=(250 500 1000)
amount=10000
amountPretty="10k"

# create single file with 'amount' nr of urls
sed 's/^[0-9]*,/https:\/\/www./' "top-1m.csv" | head -n $amount > "top-$amountPretty.txt"

# create multiple files with 'partSize' amount urls
for partSize in "${partSizes[@]}"; do
    outputDirectory="$amountPretty-urls-$partSize-parts"

    if [[ ! -d $outputDirectory ]]; then
        mkdir $outputDirectory
        split -l "$partSize" -d "top-$amountPretty.txt" $outputDirectory/part_
    else
        echo "$outputDirectory already exists"
    fi
done


