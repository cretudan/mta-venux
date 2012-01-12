--[[
---			|\-/| Roleplay VX Version one |\-/|  ---
---				Developer: AeroXbird & Lukkaz			 ---
--]]

_root = getRootElement();
_thisresource = getResourceRootElement(getThisResource());


function bindCursor()
bindKey ( source, "m", "down", 
	function(source, key, state) 
		local currentState = isCursorShowing ( source )
		local oppositeState = not currentState
		showCursor ( source, oppositeState )
	end
	)
end

addEventHandler("onPlayerJoin", _root, bindCursor)