#!/bin/bash

# Script to check current VM status and Instana Agent status

# 1. Check VM CPU, memory, and disk usage
echo "===== VM Resource Usage ====="
echo "CPU Usage:"
top -bn1 | grep 'Cpu(s)'
echo
echo "Memory Usage:"
free -h
echo
echo "Disk Usage:"
df -h /

echo

# 2. Check Instana Agent service status
AGENT_SERVICE_NAME="instana-agent"
echo "===== Instana Agent Service Status ====="

# Check if systemctl is available and show service status
if command -v systemctl &> /dev/null
then
    systemctl is-active --quiet $AGENT_SERVICE_NAME
    if [ $? -eq 0 ]; then
        echo "$AGENT_SERVICE_NAME service is active."
    else
        echo "$AGENT_SERVICE_NAME service is not active."
    fi
else
    # If systemctl is not available, check the process directly
    pgrep $AGENT_SERVICE_NAME > /dev/null
    if [ $? -eq 0 ]; then
        echo "$AGENT_SERVICE_NAME process is running."
    else
        echo "$AGENT_SERVICE_NAME process is not running."
    fi
fi

# 3. Show last 10 lines of Instana Agent log
LOG_PATH="/var/log/instana/agent.log"
if [ -f "$LOG_PATH" ]; then
    echo
    echo "===== Latest Instana Agent Log ====="
    tail -n 10 $LOG_PATH
else
    echo
    echo "Instana Agent log file not found: $LOG_PATH"
fi
