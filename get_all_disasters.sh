#!/bin/bash
# This code will fetch all disasters from the ReliefWeb API
# and save them to a JSON file called all_data.json



# Initialize offset
OFFSET=0

# Initialize an empty JSON array to store the results
echo "[" > all_data.json

# While loop to make requests until all records are fetched
while [ $OFFSET -lt 300588 ]; do

    # Make the curl request and append the results to the file
    curl -X "POST" "https://api.reliefweb.int/v1/reports?appname=apidoc&limit=1000&offset=$OFFSET" \
    -H 'Content-Type: text/plain; charset=utf-8' \
    -d $'{
        "fields": {
            "include": [
                "source.shortname",
                "date",
                "disaster.id",
                "disaster.name",
                "disaster.type.name",
                "country",
                "primary_country.iso3",
                "primary_country.id",
                "primary_type.name",
                "disaster_type.id",
                "file.url",
                "theme.name",
                "theme.id",
            ]
        },
        "filter": {
            "field": "disaster.id"
        }
    }' | jq -c '.data[]' >> all_data.json

    # Print a comma to separate the data, but not after the last request
    if [ $OFFSET -lt 299588 ]; then
        echo "," >> all_data.json
    fi

    # Increase the offset by 1000 for the next request
    OFFSET=$((OFFSET + 1000))

done

# Close the JSON array
echo "]" >> all_data.json
