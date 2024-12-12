#!/usr/bin/env bash

set -eou pipefail

# From https://heyfocus.com/enabling-do-not-disturb-mode and
# https://apple.stackexchange.com/questions/145487

COMMAND_NAME=${1:-toggle}

if [[ $COMMAND_NAME = "enable" || $(defaults -currentHost read ~/Library/Preferences/ByHost/com.apple.notificationcenterui doNotDisturb) -eq 0 ]]; then
  defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui doNotDisturb -boolean true
  defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui doNotDisturbDate -date "$(date -u +"%Y-%m-%d %H:%M:%S +000")"
  killall NotificationCenter
  echo "Do Not Disturb is enabled. Run $0 to turn it off (OS X will turn it off automatically tomorrow)."
else
  defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui doNotDisturb -boolean false
  killall NotificationCenter
  echo "Do Not Disturb is disabled. Run $0 to turn it on again."
fi
