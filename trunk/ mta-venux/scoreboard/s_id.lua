---			|\-/| Roleplay VX Version one |\-/|  ---
---				Original Script by ryden
---				Edited by: Lukkaz				 ---
--]]


local ids = { } --creates a table for all your ids

---Simple function loops through available ids assigning them to players
function playerJoin()
	local slot = nil
	for i = 1, 1000 do --how many players can you have?
		if (ids[i]==nil) then
			slot = i
			break
		end
	end
	
	ids[slot] = source
	setElementData(source, "playerid", slot)
end
addEventHandler("onPlayerJoin", getRootElement(), playerJoin)



function playerQuit()
	local slot = getElementData(source, "playerid")
	
	if (slot) then
		ids[slot] = nil
	end
end
addEventHandler("onPlayerQuit", getRootElement(), playerQuit)

function resourceStart()
	local players = getElementsByType("player")
	for key, value in ipairs(players) do
		ids[key] = value
		setElementData(value, "playerid", key)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), resourceStart)
