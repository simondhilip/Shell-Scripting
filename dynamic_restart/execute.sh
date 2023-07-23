#!/bin/bash

# ------------------------------------------------------------------
# Author:       Dhilip kumar Ganasekar
# Description:  This script was created to restart the server 
#	        as part of server restart automation
# ------------------------------------------------------------------

# Load properties file
source servers.properties

# Loop through servers

for server in server1 server2 ; do
    # Check if server variable is null
    if [ -z "${!server}" ]
    then
        echo "Server variable $server is empty, skipping."
        continue
    fi

    # Get server directory and start script name
    server_dir="$(echo ${!server} | cut -d ',' -f1)"
    if [ "$1" = "start" ]
    then
        execute="$(echo ${!server} | cut -d ',' -f2)"
        sleepmin="2m"
    elif [ "$1" = "stop" ]
    then
        execute="$(echo ${!server} | cut -d ',' -f3)"
	sleepmin="0m"
    fi

    # Print message indicating server is being started or stopped
    if [ "$1" = "start" ]
    then
        echo "..............Starting $server .................."
    elif [ "$1" = "stop" ]
    then
        echo "..............Stopping $server .................."
    fi

    # Change to server directory and start or stop server
    cd "$server_dir"
    "./$execute" &

    # Wait for two minute before starting or stopping next server
    sleep "$sleepmin"
done

# Print message indicating all servers have been started or stopped
if [ "$1" = "start" ]
then
    echo "..............For Loop completed (servers started).................."
elif [ "$1" = "stop" ]
then
    echo "..............Giving 3 minutes for server to stop ................."

    seconds=180; date1=$((`date +%s` + $seconds)); 
    while [ "$date1" -ge `date +%s` ]; do 
      echo -ne "$(date -u --date @$(($date1 - `date +%s` )) +%H:%M:%S)\r"; 
    done

    Java_PROCESS_COUNT=$(ps -ef | grep java | wc -l)
    echo "Number of Java process running = $Java_PROCESS_COUNT"


    if [ $Java_PROCESS_COUNT -gt 1 ]
    then
     echo " **************Some process is still running... Kindly validate manually **************"
    else
     echo "**************All Servers are down now **************"
    fi
fi