#!/bin/bash

source servers.properties

PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH
export CLASSPATH JAVA_HOME PATH

echo $CLASSPATH
echo $PATH
echo $JAVA_HOME



for server in server01 server02 server03 server04 server05 server06 server07 server08 ; do
    # Check if server variable is null
    if [ -z "${!server}" ]
    then
        echo "Server variable $server is empty, skipping."
        continue
    fi

    # Get server directory and start script name
    deploy_dir="$(echo ${!server} | cut -d ',' -f1)"
	server_port="$(echo ${!server} | cut -d ',' -f2)"
	target_server="$(echo ${!server} | cut -d ',' -f3)"
	
	DEPLOYER="java weblogic.Deployer -url t3://$SERVER_DOMAIN:$server_port -user $ADMIN_USER -password $ADMIN_PASSWORD"

    echo "Undeployment starts"
    echo "..............................................................................................."
    $DEPLOYER -name nur -undeploy
    $DEPLOYER -name MSS_WebService -undeploy
    $DEPLOYER -name ASR65 -undeploy
    $DEPLOYER -name ASR66 -undeploy

	MODIFIEDDATE=`date +%Y%b%d-%H%M%S`
        cd $deploy_dir
	mv nur.ear nur.ear_$MODIFIEDDATE
	mv ASR65.ear ASR65.ear_$MODIFIEDDATE
	mv ASR66.ear ASR66.ear_$MODIFIEDDATE
	mv MSS_WebService.ear MSS_WebService.ear_$MODIFIEDDATE

	cp $CUSTOMIZED_EAR/* .
	
	
    DEPLOYER="java weblogic.Deployer -url t3://$SERVER_DOMAIN:$server_port -user $ADMIN_USER -password $ADMIN_PASSWORD -targets $target_server -usenonexclusivelock -verbose"

    $DEPLOYER -name nur -source $deploy_dir/nur.ear -deploy
    $DEPLOYER -name ASR65 -source $deploy_dir/ASR65.ear -deploy
    $DEPLOYER -name ASR66 -source $deploy_dir/ASR66.ear -deploy
    $DEPLOYER -name MSS_WebService -source $deploy_dir/MSS_WebService.ear -deploy

done
