#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title New iTerm2 Window
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ⌨️

# Documentation:
# @raycast.author guttyar2213

try
	tell application "Finder"
		set this_folder to quoted form of POSIX path of ((folder of the front Finder window) as alias)
	end tell
on error
	-- no open folder windows
	set this_folder to ""
end try

tell application "iTerm"
	set newWindow to (create window with default profile)
	tell current session of newWindow
		write text "cd " & this_folder & "; clear"
	end tell
end tell

