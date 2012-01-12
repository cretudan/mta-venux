--[[
---			|\-/| Roleplay VX Version one |\-/|  ---
---		     Developer: AeroXbird & Lukkaz	     ---
--]]


function savePlayer(player)
	if ( getElementType( player ) == "player" ) then
		if ( getElementData(player, "loggedin") == true ) then

			local characterID = getElementData(player, "characterID")
			if ( exports.account:getCharacterExists( tonumber( characterID ) ) ) then
				local x, y, z = getElementPosition( player )
				local interior = getElementInterior( player )
				local dimension = getElementDimension( player )
				local health = getElementHealth( player )
				local armor = getPedArmor( player ) 
				local cash = exports.money:getMoney( characterID ) -- note, we check for money hacks too now!

				local result, error = exports.sql:query_free( "UPDATE `characters` SET `savedX` = '".. x .."', savedY = '".. y .."', savedZ = '".. z .."', dimension = '".. dimension .."', interior = '".. interior .."',  health = '".. health .."', cash = '".. cash .."' WHERE charid = '".. characterID .."' ")
					
					if ( result ) then
						return true
					else 
						return outputDebugString(error)
					end
			else
				return outputDebugString("Character does not exist.")
			end
		else
			return outputDebugString("Not Logged in!")
		end
	else
		return outputDebugString("Missing an argument, or argument is not of proper value.")
	end
end

function saveAll()
		outputChatBox("[WORLD] Saving the world status, lagspike inbound!",  _root, 0, 229, 238)
	for k, v in ipairs( getElementsByType( "player" ) ) do
		savePlayer( v )
	end
end

setTimer(saveAll, 1800000, 0)
addCommandHandler("saveAll", saveAll)