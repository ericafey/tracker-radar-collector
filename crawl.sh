#!/usr/bin/bash
# USAGE: ./crawl.sh [nr of urls] [optional size of parts]
# and uncomment whichever function you want to at the bottom

# parameters
amountPretty=$1
dt=$(date '+%d%m%Y_%H:%M:%S')
collectors="requests,cookies,targets,apis,screenshots"
outDir="data/$amountPretty-urls/"  

# functions
crawl_tranco_parts(){
    partSize=$2
    logFile="data/log/crawl-$amountPretty-urls-$partSize-parts-$dt.sh"
    counter=0

    for inputFile in tranco/$amountPretty-urls-$partSize-parts/*; do
        counter=$((counter + 1 ))
        outDir="data/$amountPretty-urls/$counter/"
        
        echo "\n PART $counter HERE \n" >> $logFile
        npm run crawl -- -v -f -3 -i $inputFile  -o $outDir -d $collectors >> $logFile
    done
}

crawl_tranco_no_parts(){
    logFile="data/log/crawl-$amountPretty-urls-$dt.sh"
    inputFile="tranco/top-$amountPretty.txt"

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

# running
# crawl_my_pages
# crawl_tranco_parts
# crawl_tranco_no_parts