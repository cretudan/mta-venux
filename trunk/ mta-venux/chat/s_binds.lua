--[[
---			|\-/| Roleplay VX Version one |\-/|  ---
---			  Developer: AeroXbird & Lukkaz			 ---
--]]

_root = getRootElement()

function bindKeys()
for i, v in ipairs(getElementsByType("player")) do
bindKey ( v, "m", "down", 
	function(v, key, state) 
		if isCursorShowing(v) then
			showCursor(v, false)
		else
			showCursor(v, true)
		end
	end
	)

-- Local OOC bind
bindKey( v, "b", "down", "chatbox", "LocalOOC" )

-- Global OOC bind
bindKey( v, "u", "down", "chatbox", "GlobalOOC" )
end
end

addEventHandler("onResourceStart", _root, bindKeys)