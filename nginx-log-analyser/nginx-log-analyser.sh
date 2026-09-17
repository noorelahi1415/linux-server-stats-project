#!/bin/bash
echo "Nginx Log Analyser"
LOG_FILE=$1
if [ -z "$LOG_FILE" ]; then
    echo "Error: Please provide a log file."
   echo "Usage: ./nginx-log-analyser.sh <log-file>"
    exit 1
fi
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: '$LOG_FILE' is not a valid file."
    exit 1
fi
echo "Analyzing: $LOG_FILE"

echo ""
echo "=============================="
echo "Top 5 IP addresses with the most requests"
echo "=============================="
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -5

####################################################################
echo ""
echo "=============================="
echo "Top 5 most requested paths"
echo "=============================="
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -5
##################################################################

echo ""
echo "=============================="
echo "Top 5 response status codes"
echo "=============================="
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -5
###################################################################
echo ""
echo "============================="
echo "Top 5 user agents shows"
echo "============================="
awk  -f '"'  '{print $6}' "$LOG_FILE"  |sort | uniq -c | sort -rn | head -5






