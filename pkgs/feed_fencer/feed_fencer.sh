#!/usr/bin/env bash

usage_file="/tmp/feed_fencer.txt"

# Get today's date
today=$(date +"%Y-%m-%d")

# Get current date from the usage file
if [ -f "$usage_file" ]; then
    saved_date=$(head -n 1 "$usage_file")
else
    saved_date=""
fi
echo $saved_date

# If the saved date is not today, reset usage time
if [ "$saved_date" != "$today" ]; then
    echo "$today" > "$usage_file"
    echo "0" >> "$usage_file"
fi

# Get current usage time from file
usage_time=$(tail -n 1 "$usage_file")

# Check if usage time exceeds thirty minutes
if [ "$usage_time" -ge 30 ]; then
    echo "Thirty minutes elapsed. Shutting down."
    # Replace 'shutdown now' with the appropriate shutdown command for your system
    shutdown -h now
else
    # Increment usage time
    echo "New time " $usage_time
    new_usage_time=$((usage_time + 1))
    sed -i '$ d' "$usage_file"  # Remove last line (old usage time)
    echo "$new_usage_time" >> "$usage_file"  # Append new usage time
fi
