#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title New Finder Window
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📂

# Documentation:
# @raycast.author guttyar2213

tell application "Finder"
	make new Finder window to path to home folder
	do shell script "open " & quoted form of POSIX path of ((folder of the front Finder window) as alias)
end tell