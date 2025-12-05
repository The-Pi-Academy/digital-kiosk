#!/bin/bash

# Kiosk Startup Script with Delay and Error Logging
# This script ensures the desktop environment is fully loaded before starting the kiosk

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
KIOSK_FILE="$SCRIPT_DIR/kiosk.py"
LOG_FILE="$SCRIPT_DIR/kiosk_startup.log"

# Function to log messages with timestamps
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Start logging
log_message "========== Kiosk Startup Script Started =========="

# Wait for the desktop environment to fully load
log_message "Waiting 10 seconds for desktop environment to stabilize..."
sleep 10

# Check if the kiosk file exists
if [ ! -f "$KIOSK_FILE" ]; then
    log_message "ERROR: kiosk.py not found at $KIOSK_FILE"
    exit 1
fi
log_message "Found kiosk.py at $KIOSK_FILE"

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    log_message "ERROR: python3 command not found"
    exit 1
fi
log_message "Python 3 is available: $(which python3)"

# Check if DISPLAY is set (required for GUI)
if [ -z "$DISPLAY" ]; then
    log_message "WARNING: DISPLAY variable not set, setting to :0"
    export DISPLAY=:0
fi
log_message "DISPLAY is set to: $DISPLAY"

# Start the kiosk application
log_message "Starting kiosk application..."
python3 "$KIOSK_FILE" >> "$LOG_FILE" 2>&1 &
KIOSK_PID=$!

log_message "Kiosk started with PID: $KIOSK_PID"
log_message "========== Kiosk Startup Script Completed =========="

# Keep the script running to monitor the kiosk process
wait $KIOSK_PID
EXIT_CODE=$?
log_message "Kiosk exited with code: $EXIT_CODE"
