#!/bin/ksh
#############################################################################################################################
#  Script Description: execute the script for every 6 hours for a day  														#
#																															#
#  Author : Dhilipkumar G																									#
#																															#
#  Date of Creation: 01/26/2019																								#
#																															#
#  Script Name:timeinterval.ksh 																							#
#############################################################################################################################
date

while [ 1 -gt 0 ]
do
  
		sh scriptpath/log_monitor.sh
		
		sleep 540
done

