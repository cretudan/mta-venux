--[[
--    <<< VENUX _ SWIFT >>>
--      DEV: AeroXbird
--]]

function playerPosition(playerSource)
	x, y, z = getElementPosition(playerSource)
	int = getElementInterior( playerSource )
	dim = getElementDimension( playerSource )
	outputChatBox("X,Y,Z = ".. tostring(x) ..",".. tostring(y) ..",".. tostring(z) .."", playerSource) 
	outputChatBox("Interior: ".. tostring(int) .. "  Dimension: ".. tostring(dim) .."", playerSource)
end

addCommandHandler("getpos", playerPosition)


function findPlayerByPartialNick(thePlayer, partialNick)
	if ( not partialNick and not isElement(thePlayer) and type( thePlayer ) == "string" ) then
		outputDebugString( "Incorrect Parameters in findPlayerByPartialNick" )
		partialNick = thePlayer
		thePlayer = nil
	end

	local candidates = {}
	local matchPlayer = nil
	local matchNick = nil
	local matchNickAccuracy = -1
	local partialNick = string.lower(partialNick)

	if ( thePlayer and partialNick == "*" ) then
		return thePlayer, getPlayerName(thePlayer):gsub("_", " ")
	elseif ( getPlayerFromName(partialNick) ) then
		return getPlayerFromName(partialNick), getPlayerName( getPlayerFromName(partialNick) ):gsub("_", " ")
	-- IDS
	elseif ( tonumber(partialNick) ) then
		matchPlayer = exports.pool:getElement("player", tonumber(partialNick))
		candidates = { matchPlayer }
	else -- Look for player nicks
		local players = exports.pool:getPoolElementsByType("player")
		for playerKey, arrayPlayer in ipairs(players) do
			if isElement(arrayPlayer) then
				local playerName = string.lower(getPlayerName(arrayPlayer))
				
				if(string.find(playerName, tostring(partialNick))) then
					local posStart, posEnd = string.find(playerName, tostring(partialNick))
					if posEnd - posStart > matchNickAccuracy then
						-- better match
						matchNickAccuracy = posEnd-posStart
						matchNick = playerName
						matchPlayer = arrayPlayer
						candidates = { arrayPlayer }
					elseif posEnd - posStart == matchNickAccuracy then
						-- found someone who matches up the same way, so pretend we didnt find any
						matchNick = nil
						matchPlayer = nil
						table.insert( candidates, arrayPlayer )
					end
				end
			end
		end
	end
	
	if ( not matchPlayer or not isElement(matchPlayer) ) then
		if ( isElement( thePlayer ) ) then
			if ( #candidates == 0 ) then
				outputChatBox("No such player found.", thePlayer, 255, 0, 0)
			else
				outputChatBox( #candidates .. " players matching:", thePlayer, 255, 194, 14)
				for  _, arrayPlayer in ipairs( candidates )  do
					outputChatBox("  (" .. tostring( getElementData( arrayPlayer, "playerid" ) ) .. ") " .. getPlayerName( arrayPlayer ), thePlayer, 255, 255, 0)
				end
			end
		end
		return false
	else
		return matchPlayer, getPlayerName( matchPlayer ):gsub("_", " ")
	end
end