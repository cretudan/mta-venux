--[[
---		|\-/| Roleplay VX Version one |\-/|      ---
---		  Developer: Lukkaz & AeroXbird	         ---
---					Chat System				     ---
--]]

--TODO: Add some way to check if the player is dead / dying or muted by an admin :p

_root = getRootElement()

function localMessage( sender, message, r, g, b, area, r2, g2, b2 )
	area = area or 20
	r2 = r2 or r
	g2 = g2 or g
	b2 = b2 or b
	
	for player, distance in pairs( getSurroundingPlayers( sender, area ) ) do
		outputChatBox( message, player, genColors( r, r2, g, g2, b, b2, distance, area ) )
	end
end

-- this is an exported function for mes, example: /me eats an apple
-- the server will display
-- *John Smith eats an apple 
function me( source, message, prefix )
	if isElement( source ) and getElementType( source ) == "player" and type( message ) == "string" then
		local message = ( prefix or "" ) .. " *" .. string.gsub(getPlayerName( source ), "_", " ") .. ( message:sub( 1, 2 ) == "'s" and "" or " " ) .. message
		localMessage( source, message, 240, 128, 128 )
		return true
	else
		return false
	end
end

-- this is an exported function for mes, example: /do there's a noise
-- the server will display
-- There's a noise ((John Smith)) 
function playerDos( thePlayer, commandName, ... )
		local message = table.concat( { ... }, " " )
			if #message > 0 then
				localMessage( thePlayer, " *" .. message .. "                ((" .. string.gsub(getPlayerName( thePlayer ), "_", " ") .. "))", 240, 128, 128 )
				return true
			else
				outputChatBox( "Usage: /" .. commandName .. " [IC Text]", thePlayer, 255, 255, 255 )
				return false
			end
end
addCommandHandler("do", playerDos)
	
function whispering ( thePlayer, commandName, ... )
		local message = table.concat( { ... }, " " )
			if #message > 0 then
				localMessage( thePlayer, " " .. string.gsub(getPlayerName( thePlayer ), "_", " ") .. " whispers: "..message.."", 255, 255, 255, 3 )
			else
				outputChatBox( "Usage: /" .. commandName .. " [local IC text]", thePlayer, 255, 255, 255 )
			end
end
addCommandHandler("w", whispering)

function shouting( thePlayer, commandName, ... )
		local message = table.concat( { ... }, " " )
			if #message > 0 then
				localMessage( thePlayer, " " .. string.gsub(getPlayerName( source ), "_", " ") .. " shouts: "..message.."!!", 255, 255, 255, 60 )
			else
				outputChatBox( "Usage: /" .. commandName .. " [local IC text]", thePlayer, 255, 255, 255 )
			end
end
addCommandHandler("s", shouting)

function mes(thePlayer, commandName, ... )
		local message = table.concat( { ... }, " " )
			if #message > 0 then
				me( thePlayer, " " .. message )
			else
				outputChatBox( "Usage: /" .. commandName .. " [IC text]", thePlayer, 255, 255, 255 )
			end
end
addCommandHandler("me", mes)

function localOOC( thePlayer, commandName, ... )
	if getElementData(thePlayer, "loggedin") == true then
		local message = table.concat( { ... }, " " )
		if #message > 0 then
			localMessage( thePlayer, "".. string.gsub(getPlayerName( thePlayer ), "_", " ") ..  " [LocalOOC]: " .. message .. "", 135, 206, 250 )
		else
			outputChatBox( "Usage: /" .. commandName .. " [local OOC text]", thePlayer, 255, 255, 255 )
		end
	end
end
addCommandHandler("b", localOOC)
addCommandHandler("LocalOOC", localOOC)

function globalOOC( thePlayer, commandName, ... )
	if getElementData(thePlayer, "loggedin") == true then
		if getElementData( thePlayer, "ooc" ) == 1 then
		local message = table.concat( { ... }, " " )
			if #message > 0 then
				outputChatBox( "" .. string.gsub(getPlayerName( thePlayer ), "_", " ") ..  " [GlobalOOC]: " .. message .. "", root, 0, 104, 139 )
			else
				outputChatBox( "Usage: /" .. commandName .. " [OOC text]", thePlayer, 255, 255, 255 )
			end
		end
	end
end
addCommandHandler("u", globalOOC)
addCommandHandler("GlobalOOC", globalOOC)

function distanceRendering( color, color2, distance, area )
	return color - math.floor( ( color - color2 ) * ( distance / area ) )
end

function genColors( r, r2, g, g2, b, b2, distance, area )
	if area <= 0 then
		area = 0.01
	end
	return distanceRendering( r, r2, distance, area ), distanceRendering( g, g2, distance, area ), distanceRendering( b, b2, distance, area )
end

function getSurroundingPlayers( sender, area ) ---As the title explains, gets all the players in an area around the speaking player
	local int = getElementInterior( sender )
	local dim = getElementDimension( sender )
	local x, y, z = getElementPosition( sender )
	
	local players = { }
	for key, value in ipairs( getElementsByType( "player" ) ) do
		if getElementDimension( value ) == dim and getElementInterior( value ) == int then
			local distance = getDistanceBetweenPoints3D( x, y, z, getElementPosition( value ) )
			if distance < area then
				players[ value ] = distance
			end
		end
	end
	if getElementType( sender ) == "player" then
		local vehicle = getPedOccupiedVehicle( sender )
		-- TODO: ADD CODE TO CHECK IF WINDOWS ARE OPEN, THEN SHOW MESSAGE FOR THOSE AROUND THE CAR TOO.
		if vehicle then -- if we have a vehicle, only show message to those in the car.
			local passengers = getVehicleMaxPassengers( vehicle )
			if type( passengers ) == 'number' then
				for seat = 0, passengers do
					local value = getVehicleOccupant( vehicle, seat )
					if value then
						players[ value ] = 0
					end
				end
			end
		end
	end
	return players
end


addEventHandler( "onPlayerChat", _root,
	function( message, type )
		cancelEvent()
			if type == 0 then
				localMessage( source, string.gsub(getPlayerName( source ), "_", " ") ..  " says: " .. message .. "", 230, 230, 230 )
			elseif type == 1 then
				me( source, message )
			end
	end
)


----------------------|| EXPORTED FUNCTIONS || --------------------------
-- FUNCTION: meAction ( player thePlayer, string message ) 
-- Description: Allows usage of /me actions to be run by the script, adding automated /me messages when performing certain actions.
function meAction( thePlayer, message )
	if ( getElementType( thePlayer ) == "player" and message ) then
		if ( me( thePlayer, message ) == true ) then -- prefix argument is for future use, so not using it here.
			return true
		else
			return false
		end
	else
		return MISSING_ARGUMENTS
	end
end

-- FUNCTION: doAction ( player thePlayer, string message )
-- Description: Allows usage of /me actions to be run by the script, adding automated /do messages when performing certain actions.
function doAction( thePlayer, message )
	if ( getElementType( thePlayer ) == "player" and message ) then
		if ( playerDos( thePlayer, "do", message ) ) then -- Please do not mind the "do", the function that is being triggered is actually command triggered by default, and i'm too lazy to rewrite it.
			return true
		else
			return false
		end
	else
		return MISSING_ARGUMENTS
	end
end

----------------------------------------------------------------------------------