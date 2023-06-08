#!/bin/bash

# Set the LC_CTYPE environment variable to en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# Initialize offset
OFFSET=0

# Initialize iteration counter
ITERATION=0

# Initialize an empty array variable to store the results
result=()

# While loop to make requests until all iterations are completed
while [ $OFFSET -lt 999999 ]; do #originally 300588
    # Increment the iteration counter
    ITERATION=$((ITERATION + 1))

    # Make the curl request and append the results to the array
    response=$(curl -X "POST" "https://api.reliefweb.int/v1/reports?appname=apidoc&limit=1000&offset=$OFFSET" \
        -H 'Content-Type: text/plain; charset=utf-8' \
        -d $'{
            "fields": {
                "include": [
                    "source.shortname",
                    "date",
                    "disaster.id",
                    "disaster.name",
                    "disaster.type.name",
                    "country.name",
                    "country.iso3",
                    "country.id",
                    "primary_country.name",
                    "primary_country.iso3",
                    "primary_country.id",
                    "disaster_type.name",
                    "disaster_type.id",
                    "file.url",
                    "theme.name",
                    "theme.id",
                    "url",
                    "title"
                ]
            },
            "filter": {
                "field": "disaster.id"
            }
        }')

    # Check if response is empty or null
    if [[ -z $response ]]; then
        echo "Error: Empty response received from the API."
        exit 1
    fi

    # Append the response to the array
    result+=("$response")

    # Print the iteration count to the output file
    echo "Iteration: $ITERATION" > output.txt

    # Increase the offset by 1000 for the next request
    OFFSET=$((OFFSET + 1000))
done

# Join the array elements with commas and add the opening and closing square brackets
json_data=$(printf "%s\n" "${result[@]}" | jq -s '.')

# Write the JSON data to the file
echo "$json_data" > all_data.json
