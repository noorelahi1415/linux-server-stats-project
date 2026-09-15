#!/bin/bash
echo "=== server performance Stats ==="
echo " "
echo "--- CPU Usage ---"
echo "---  T Total CPU Usage is  ---"
top -bn1  | grep "Cpu(s)" | awk '{ print "CPU Usage: " 100 - $8 "%"}'
echo "Hello Linux" | awk '{print $1, $2}'
echo ""
echo "--- Memory Usage ---"
free -m | awk  'NR==2{printf "Used: %sMB /  %sMB (%.2f%%) \n Free: %sMB (%.2f%%) \n", $3, $2, $3*100/$2, $4, $4*100/$2}'
#####################################################################################################################
echo ""
echo "--- Disk Usage ---"
df -h --total | grep "total" | awk '{printf "Used: %s / %s (%s)\nFree: %s\n", $3, $2, $5, $4}'
df  -h --total  | grep  "total" | awk  '{printf "Used: %s / %s (%s) \n Free: %s (%s) \n" , $3,$2,$5,$4,$5}'
####################################################################################################################
echo ""
echo "--- Top 5 Processes by CPU Usage ---"
#ps -eo pid,comm,%cpu --sort=-%cpu | head -6
#################################################################################################################
ps -eo pid,comm,%cpu --sort=-%cpu | head -6
################################################################################################################
echo ""
echo "--- Top 5 Processes by memomry Usage ---"
ps -eo pid,comm,%mem --sort=-%mem | head -6
###############################################################################################################
echo ""
echo "--- Uptime & Load Average ---"
uptime -p
uptime | awk -F'load average:' '{print "Load Average:" $2}'
################################################################################################################
echo ""
echo "--- OS Version ---"
cat /etc/os-release | grep "PRETTY_NAME" | cut -d '=' -f2 | tr -d '"'
cat /etc/os-release | grep "PRETTY_NAME"  | cut -d '=' -f2 | tr -d '"'
##################################################################################################################
echo ""
echo "--- Logged In Users ---"
who | wc -l
who
#################################################################################################################
echo ""
echo "--- Failed Login Attempts ---"
lastb 2>/dev/null | grep -v "^btmp" | wc -l
