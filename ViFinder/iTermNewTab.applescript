if application "iTerm" is running then
	tell application "iTerm"
		try
			tell the first terminal
				launch session "Default Session"
				tell the last session
					write text "cd %@"
				end tell
			end tell
		on error
			set myterm to (make new terminal)
			tell myterm
				launch session "Default Session"
				tell the last session
					write text "cd %@"
				end tell
			end tell
		end try
	end tell
else
	tell application "iTerm"
		activate
		tell the first terminal
			tell the first session
				write text "cd %@"
			end tell
		end tell
	end tell
end if
