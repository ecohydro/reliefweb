# ReliefWeb API Data Collection

To use the shell script, `get_all_disasters.sh`, you will need to have the following installed:

jq - https://stedolan.github.io/jq/. jq is a lightweight and flexible command-line JSON processor.

curl - https://curl.haxx.se/. curl is a command line tool and library for transferring data with URL syntax.

To install jq on Ubuntu, run the following command:

`sudo apt-get install jq`

To install curl on Ubuntu, run the following command:

`sudo apt-get install curl`

You will need to change the permissions of the shell script to make it executable. To do this, run the following command:

`chmod +x get_all_disasters.sh`

To run the shell script, run the following command:

`./get_all_disasters.sh`    

The script will take a long time to run, so in order to run it in the background, run the following command:

`nohup ./get_all_disasters.sh &`

If you want the progress of the script (the output of the CURL commands) to be saved to a file, run the following command:

`nohup ./get_all_disasters.sh > output.txt &`

