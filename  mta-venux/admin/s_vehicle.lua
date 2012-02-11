--[[
---			|\-/| Roleplay VX Version one |\-/|  ---
---		        Developer: AeroXbird 		     ---
--]]


function getVehicle( player, command, id )
	if (exports.global:isPlayerMod(player)) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. command .. " [id]", thePlayer, 255, 194, 14)
		else
			local vehicle = exports.vehicles:getVehicleByID( tonumber(id) )
			
			if ( vehicle ~= nil ) then
				local rot = getPedRotation( player )
				local x, y, z = getElementPosition( player )
				
				-- calculate position to be next to us.
				x = x + ( ( math.cos ( math.rad ( rot ) ) ) * 5 )
				y = y + ( ( math.sin ( math.rad ( rot ) ) ) * 5 )
			
				if	(getElementHealth(vehicle)==0) then
					spawnVehicle(vehicle, x, y, z, 0, 0, rot)
				else
					setElementPosition(vehicle, x, y, z)
					setVehicleRotation(vehicle, 0, 0, rot)
				end
				
			else
				outputChatBox("Could not find vehicle.", player, 200, 0, 0)
			end
		end
	end
end

addCommandHandler("getveh", getVehicle )