#!/bin/bash

# Set the LC_CTYPE environment variable to en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# Initialize totalCount variable
totalCount=0

# Make the initial request to get the totalCount
initialResponse=$(curl -X "POST" "https://api.reliefweb.int/v1/reports?appname=apidoc&limit=1")
totalCount=$(echo "$initialResponse" | jq -r '.totalCount')

# Calculate the number of iterations
numIterations=$((totalCount / 1000))
if [ $((totalCount % 1000)) -ne 0 ]; then
  numIterations=$((numIterations + 1))
fi

# Create the output directory if it doesn't exist
mkdir -p data/disaster_jsons

# Initialize offset
OFFSET=0

# Iterate for the calculated number of iterations or until all data is extracted
for ((ITERATION=1; ITERATION<=numIterations; ITERATION++)); do
    # Make the curl request and append the results to a file
    response=$(curl -X "POST" "https://api.reliefweb.int/v1/reports?appname=apidoc&limit=1000&offset=$OFFSET" \
        -H 'Content-Type: text/plain; charset=utf-8' \
        -d $'{
            "fields": {
                "include": [
                    "source.shortname",
                    "source.name",
                    "date",
                    "disaster.id",
                    "disaster.name",
                    "disaster.glide",
                    "country.name",
                    "country.iso3",
                    "country.id",
                    "primary_country.name",
                    "primary_country.iso3",
                    "primary_country.id",
                    "disaster_type.name",
                    "disaster_type.id",
                    "theme.name",
                    "theme.id",
                    "format.name",
                    "format.id",
                    "url",
                    "title",
                    "language.name", 
                    "language.code",
                    "language.id",
                    "body"
                ]
            },
            "filter": {
                "field": "disaster.id"
            }
        }')

    # Check if response is empty or null
    if [ -z "$response" ]; then
        echo "Empty response received from the API. Stopping iteration."
        break
    fi

    # Write the response to a file only if there is data
    if [ $(echo "$response" | jq '.data | length') -gt 0 ]; then
        # Write the response to a file
        filename=$(printf "disaster_articles_%03d.json" "$ITERATION")
        echo "$response" > "data/disaster_jsons/$filename"

        # Print the iteration count to the output file
        echo "Iteration: $ITERATION" >> output.txt
    else
        echo "Empty data field received. Stopping iteration."
        break
    fi

    # Increase the offset by 1000 for the next request
    OFFSET=$((OFFSET + 1000))
done
