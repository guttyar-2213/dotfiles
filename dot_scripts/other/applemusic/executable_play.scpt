#!/usr/bin/osascript
on run argv
	tell application "Music"
		delete tracks in playlist "CLI"
		repeat with arg in argv
			duplicate track id arg to playlist "CLI"
		end repeat
		play the playlist "CLI"
	end tell
end run

-- duplicate (tracks 2 thru (count of tracks)) to playlist "CLI"
-- duplicate (tracks 1 thru (2 - 1)) to playlist "CLI"