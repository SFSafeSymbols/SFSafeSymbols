activate application "SF Symbols"

tell application "System Events"
	tell process "SF Symbols"
		
		-- Click the "list" radio button.
		click radio button 2 of radio group 1 of group 3 of toolbar 1 of window 0
		
		tell outline 1 of scroll area 1 of splitter group 1 of window 0
			-- Change for each category name. (it will be very slow if we loop on "All")
			select (row 1 where value of static text 1 of UI element 1 starts with "Multicolor")
		end tell
		
		set myResult to ""
		set rowCounter to (1 as integer)
		repeat with tableRow in rows of table 0 of scroll area 2 of splitter group 1 of window 0
			log rowCounter
			set sfSymbolName to value of static text 1 of UI element 2 of tableRow as string
			
			log sfSymbolName
			set btnCount to (0 as integer)
			repeat with btn in buttons of UI element 2 of tableRow
				set btnCount to btnCount + (1 as integer)
			end repeat
			if btnCount > 0 then
				select tableRow
				set allViewsInRightPane to entire contents of scroll area 3 of splitter group 1 of window 0 as list
				set textIndex to (count allViewsInRightPane) - 1 as integer
				set thisText to item textIndex of allViewsInRightPane
				set reasonText to value of thisText as string
				set myResult to myResult & "\"" & sfSymbolName & "\" = \"" & reasonText & "\";
"
			end if
			set rowCounter to rowCounter + (1 as integer)
		end repeat
		log myResult
		set the clipboard to {text:(myResult as string), Unicode text:myResult}
	end tell
end tell
