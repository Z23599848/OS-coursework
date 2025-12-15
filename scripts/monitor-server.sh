#!/bin/bash

# monitor-server.sh
# Collects performance metrics from the server.
# Usage: ./monitor-server.sh <user>@<host>

if [ -z "$1" ]; then
    echo "Usage: $0 <user>@<host>"
    exit 1
fi

TARGET=$1

echo "Connecting to $TARGET to collect metrics..."
echo "----------------------------------------"

ssh -t "$TARGET" "
    echo '--- CPU Usage ---'
    top -bn1 | grep 'Cpu(s)'
    
    echo ''
    echo '--- Memory Usage ---'
    free -h
    
    echo ''
    echo '--- Disk Usage ---'
    df -h /
    
    echo ''
    echo '--- Network Statistics ---'
    ip -s link
"

echo "----------------------------------------"
echo "Monitoring Complete."
