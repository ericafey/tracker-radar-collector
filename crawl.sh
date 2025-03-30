#!/usr/bin/bash
# USAGE: ./crawl.sh [nr of urls] [optional size of parts]
# and uncomment whichever function you want to at the bottom

# Parameters
amount=$1
dt=$(date '+%d%m%Y_%H:%M:%S')
collectors="requests,cookies,targets,apis,screenshots"
outDir="data/$amount-urls/"  

# Functions
crawl_tranco_parts(){
    partSize=$2
    logFile="data/log/crawl-$amount-urls-$partSize-parts-$dt.sh"
    counter=0

    for inputFile in tranco/$amount-urls-$partSize-parts/*; do
        counter=$((counter + 1 ))
        outDir="data/$amount-urls/$counter/"
        
        echo "\n PART $counter HERE \n" >> $logFile
        npm run crawl -- -v -f -3 -i $inputFile  -o $outDir -d $collectors >> $logFile
    done
}

crawl_tranco_no_parts(){
    logFile="data/log/crawl-$amount-urls-$dt.sh"
    inputFile="tranco/top-$amount.txt"

    npm run crawl -- -v -f -3 -i $inputFile -o $outDir -d $collectors  > $logFile
}

crawl_my_pages(){
    tools=("clarity" "fullstory" "posthog" "logrocket" "mouseflow")
    for tool in "${tools[@]}"; do
        inputUrl="https://ericafey.github.io/recordingToolPages/$tool.html"
        outDir="data/mypages/$tool"
        logFile="data/log/crawl-mypages-$dt.sh"
        npm run crawl -- -v -f -u $inputUrl  -o $outDir -d $collectors >> $logFile
    done
}

# Running
# crawl_my_pages
# crawl_tranco_parts
# crawl_tranco_no_parts