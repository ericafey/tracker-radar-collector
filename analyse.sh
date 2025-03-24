#!/usr/bin/bash

# Output directories: for all pages with a script calling getSelection > without null (my own) scripts > without recaptcha scripts
mkdir "analysis/all"
mkdir "analysis/no-nulls" 
mkdir "analysis/no_nulls_recaptcha" 

# Count the number of pages successfully crawled
count_successful_crawls(){
  total=0
  for d in data/10k-urls/*; do
      nr=0
      for f in $d/*; do 
          if [[ $f == $d"/metadata.json" ]]; then
              nr=$(grep -o '"successes": [0-9]*' $f | sed 's/"successes": //')
          fi
      done
      total=$((total+nr))
  done
  echo $total
}

# Check if a file contains getSelection
contains_getSelection(){
  file=$1
  # skip screenshots or metadata
  if [[ $(file --extension -b $file)!="jpeg/jpg/jpe/jfif" && $file != "metadata.json" ]]; then
    if [[ $(grep -o "getSelection" $file | wc -l) -gt 0 ]]; then
      echo "True"
    fi 
  fi
}

# Finds all pages that use getSelection
collect_10k_results(){
  output_name=$1

  # Iterate over crawl output
  for i in {1..20}; do
    for f in data/10k-urls/$i/*; do
      if [[ $(contains_getSelection $f) == "True" ]]; then
        echo $f >> "$output_name-urls.txt"
        cp $f $output_name
      fi
    done
  done

}

# Copies the file to a directory and prints its apis (per page) to a text file
store_file_data(){
  occurrences=$1
  name=$2
  apis=$3
  file=$4

  if [[ $occurrences -gt 0 ]]; then
    cp $file "analysis/$name/"
    echo $file >> "analysis/$name-urls.txt"
    printf "%s\n" $apis >> "analysis/$name-apis.txt"
    printf "\nFor %s the following API calls use getSelection:\n%s\n" "$file" "$apis" >> "analysis/$name-per-url.txt"
  fi
}

# Runs analysis on crawl output: counts successful crawls and collects pages and third parties calling getSelection
analyse(){
  # Count successful crawls
  echo $(count_successful_crawls) >> analysis/successful_crawls.txt

  # Collect all pages calling getSelection
  collect_10k_results "analysis/all"

  # Iterate over these
  for f in "analysis/all"/*; do
    # Collect apis calling getSelection
    apis=$(perl -0777 -ne 'while (/(\S+)\s+\{[^{]*getSelection":/g) { print "$1\n"; }' "$f") 

    # Filter based on api
    nr_no_nulls=$(printf "$apis" | grep -v '/null"' | wc -l ) # exclude our own script
    nr_no_nulls_recaptcha=$(printf "$apis" | grep -v -E '/null"|recaptcha' | wc -l ) # exclude our own script and recaptcha scripts

    # Stores and prints collected analysis data
    printf "%s\n" "$apis" >> "analysis/all-apis.txt"
    store_file_data $nr_no_nulls "no-nulls" "$apis" $f
    store_file_data $nr_no_nulls_recaptcha "no_nulls_recaptcha" "$apis" $f
  done
}

analyse