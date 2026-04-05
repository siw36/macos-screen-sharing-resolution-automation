#!/bin/bash

DELAY=3
DP_PATH="/opt/homebrew/bin/displayplacer"
DP_RES="res:3840x2160 hz:60 color_depth:4"
LOG_OUT="/tmp/macos-screen-sharing-resolution-automation.out.log"

# Use 'log stream' to watch for the remote authentication event in real-time
log stream --predicate 'processImagePath CONTAINS "screensharingd" AND eventMessage CONTAINS "Authentication: SUCCEEDED"' | while read -r line; do
    # Give the Screen Sharing session 3 seconds to fully initialize the display
    echo "$(date) ### Screen Sharing connection detected. Waiting (${DELAY}) for display initialization." >> "$LOG_OUT" 2>&1
    
    # Wait for the virtual display to fully mount
    sleep $DELAY
    
    # Apply 4K
    echo "$(date) ### Updating resolution to ${DP_RES}." >> "$LOG_OUT" 2>&1
    $DP_PATH "${DP_RES}" >> "$LOG_OUT" 2>&1
done

# Exit explicitly to tell launchd we are done
exit 0