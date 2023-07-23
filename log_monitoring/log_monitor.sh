#############################################################################################################################
#  Script Description: Monitor and Send Email if the MASAQUAL had any issue													#
#																															#
#  Author : Dhilipkumar G																									#
#																															#
#  Date of Creation: 01/26/2019																								#
#																															#
#  Script Name:log_monitor.sh 																							#
#############################################################################################################################
#!/bin/ksh 
body="$(find logpath/logs -type f -exec grep -l "ORA-" {} \;)" &&
localHostName=`hostname`; 

if [[ -n $body ]];then

 echo "Dear All, 
\n\n Please find the Log files from Machine $localHostName which is having ORA error During MASS Qual job execution as of `date` 
\n\n  $body 
\n
\n\n Best Regards, 
\n NGMSS Support Team." | /usr/bin/mailx -~ -s "MASQUAL monitoring status" "abc@gmail.coms"
fi
