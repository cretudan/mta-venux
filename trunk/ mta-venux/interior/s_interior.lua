--[[
--    <<< VENUX _ SWIFT >>>
--      DEV: AeroXbird
--]]
-- hope you liek it.

_root = getRootElement()

interiors = {}
colshapes = {}
p = {}

function _constructInteriors()
	local result = exports.sql:query_assoc("SELECT * FROM `interiors` ORDER BY id ASC")

	for k, v in ipairs( result ) do

		interiors[ v.id ] = {}

		interiors[ v.id ].interior = v.interior
		interiors[ v.id ].dimension = v.dimension
		interiors[ v.id ].owner = v.owner
		interiors[ v.id ].locked = v.locked
		interiors[ v.id ].x = v.x
		interiors[ v.id ].y = v.y
		interiors[ v.id ].z = v.z
		interiors[ v.id ].type = v.type
		interiors[ v.id ].cost = v.cost
		interiors[ v.id ].name = tostring( v.name )
		interiors[ v.id ].interiorx = v.intx
		interiors[ v.id ].interiory = v.inty
		interiors[ v.id ].interiorz = v.intz
		interiors[ v.id ].rented = v.rented
		interiors[ v.id ].renter = v.renter
		
		createInteriorMarker( v.id ) -- do it faggot
	end
end

function createInteriorMarker( interiorID )
	if ( type( interiorID ) == "number" ) then
		-- outside marker
		interiors[ interiorID ].marker = createMarker( interiors[ interiorID ].x, interiors[ interiorID ].y, interiors[ interiorID ].z, "cylinder", 1.5, 255, 255, 0, 200)
		setElementData(interiors[ interiorID ].marker, "interiorID", interiorID)
		setElementData( interiors[ interiorID ].marker, "inside", false )

		-- inside marker
		interiors[ interiorID ].insideMarker = createMarker( interiors[ interiorID ].interiorx, interiors[ interiorID ].interiory, interiors[ interiorID ].interiorz, "cylinder", 1.5, 255, 255, 0, 200)
		setElementData( interiors[ interiorID ].insideMarker, "interiorID", interiorID)
		setElementData( interiors[ interiorID ].insideMarker, "inside", true) -- this way we can teleport to outside dimension, instead of inside.
		setElementInterior( interiors[ interiorID ].insideMarker, interiors[ interiorID ].interior )
		setElementDimension( interiors[ interiorID ].insideMarker, interiors[ interiorID ].dimension )
	end
end

function deleteInteriorMarker( interiorID )
	if ( type( interiorID ) == "number" ) then
		if ( interiors[ interiorID ].marker ~= nil ) then
			removeEventHandler("onMarkerHit", interiors[ interiorID ].marker, markerTriggerHandler) 
			interiors[ interiorID ].marker = nil
		end
	end
end

addEventHandler("onResourceStart", _root, _constructInteriors)

function markerTriggerHandler( hitElement, matchingDimension )
	if ( getElementType( hitElement ) == "player" and matchingDimension and getElementData( hitElement, "loggedin" ) == true ) then
		if ( getElementData( source, "interiorID" ) ) then
			if ( p[ hitElement ] ) then
				unbindKey( hitElement, "enter_exit", "down", enterInterior, p[ element ] )
			end

			local interiorID = getElementData( source, "interiorID" )
			
			p [ hitElement ] = source
			bindKey( hitElement, "enter_exit", "down", enterInterior, p[ hitElement ] )
			bindKey( hitElement, "k", "down", lockInterior, interiorID)

			triggerClientEvent(hitElement, "prepInfoHUD", hitElement, interiors[ interiorID ])
		else
			return
		end
	else
		return
	end
end		

addEventHandler("onMarkerHit", _root, markerTriggerHandler)

function markerExitTriggerHandler( leftElement, matchingDimension )
	if ( getElementType( leftElement ) == "player"  and getElementType( source ) == "marker" ) then
		if ( getElementData( source, "interiorID" ) ) then
			
			unbindKey( leftElement, "k", "down", lockInterior, getElementData( source, "interiorID" ))
			triggerClientEvent(leftElement, "prepInfoHUD", leftElement)
			unbindKey( leftElement, "enter_exit", "down", enterInterior, p[ leftElement ])
		end
	end
end
addEventHandler("onMarkerLeave", _root, markerExitTriggerHandler)

function enterInterior( player, key, state, marker )
	if ( marker and not getPedOccupiedVehicle( player ) ) then -- marker has been given, and player is not in vehicle.
		if ( getElementDimension( player ) == getElementDimension( marker ) ) then -- this is for future implentation of multi-dimensional markers.
			local interiorID = getElementData( marker, "interiorID" )
			local locked = interiors[ interiorID ].locked
			local owner = interiors[ interiorID ].owner
				
			if ( owner == 0 ) then -- unowned interior
				if ( interiors[ interiorID ].type == 1 or interiors[ interiorID ].type == 2 ) then -- house or business
					local buyermoney = exports.money:getMoney( player )
					local interiorcost = tonumber( interiors[ interiorID ].cost )
					local rest = buyermoney - interiorcost

					if ( buyermoney >= interiorcost ) then
						local process = exports.money:takeMoney( player, interiorcost )
							if ( process == true ) then
								local query, error = exports.sql:query_free("UPDATE `interiors` SET owner = '".. exports.account:getCharacterName( getElementData( player, "characterID" ) ) .."' WHERE id = '".. interiorID .."'")
									if ( query ) then
										interiors[ interiorID ].owner = exports.account:getCharacterName( getElementData( player, "characterID" ) )
										outputChatBox("You have successfully purchased the property: ".. interiors[ interiorID ].name, player, 158, 253, 56 )
										outputChatBox("for the sum of: $".. interiors[ interiorID ].cost .."!", player, 158, 253, 56 )
									else
										outputChatBox("ERROR 0015 REPORT TO ADMIN!", player, 200, 0, 0)
										outputDebugString(error)
									end
							end
					else
						outputChatBox("You cannot afford this property", player, 200, 0, 0)
					end
				end
				-- buying feature is be able to detect type automatically. eat that valhalla
			elseif ( owner ~= 0 and locked == 0 ) then -- unlocked
				allowInteriorTeleport( player, marker )
			elseif ( owner ~= 0 and locked == 1 ) then
				exports.chat:meAction( player, "attempts to open the door, but it is locked.")
			end
		else
			return false
		end
	else
		return MISSING_ARGUMENTS
	end
end

function allowInteriorTeleport( player, marker )
-- NOTE: ADD A CHECK FOR ADMIN DUTY.
	if ( getElementData(player, "adminrank") >= 5 ) then -- ADD CHECKS FOR FACTION CHECK, MAKING FACTION LOCKABLE ENTRANCES POSSIBLE.
		-- nothing right now
	end

	if ( getElementData( marker, "inside" ) == true ) then
		local interiorID = getElementData( marker, "interiorID" )
		local x = interiors[ interiorID ].x
		local y = interiors[ interiorID ].y
		local z = interiors[ interiorID ].z
		
		triggerClientEvent(player, "prepInfoHUD", player)

		if ( x and y and z ) then
			-- fade out
			setElementFrozen( player, true ) -- securitiez

			setElementInterior(player, 0)
			setCameraInterior(player, 0)
			setElementDimension(player, 0)
			setElementPosition(player, x, y, z + 1)
		
			-- fade back in
			setTimer(setElementFrozen, 500, 1, player, false )
		end
	else
		local interiorID = getElementData( marker, "interiorID" )
		local x = interiors[ interiorID ].interiorx
		local y	= interiors[ interiorID ].interiory
		local z = interiors[ interiorID ].interiorz
		local interior = interiors[ interiorID ].interior
		local dimension = interiors[ interiorID ].dimension

		triggerClientEvent(player, "prepInfoHUD", player)

		if ( x and y and z and interior and dimension ) then
			-- fade out
			setElementFrozen( player, true ) -- securitiez

			setElementInterior(player, interior)
			setCameraInterior(player, interior)
			setElementDimension(player, dimension)
			setElementPosition(player, x, y, z + 1)
		
			-- fade back in
			setTimer(setElementFrozen, 500, 1, player, false )
		end
	end
end

function lockInterior ( thePlayer, interiorID )
 if ( getElementType( thePlayer ) == "player" and type( interiorID ) == "number" ) then
	local pId = exports.account:getCharacterName( getElementData( thePlayer, "characterID" ) )
	local iOwner = interiors[ interiorID ].owner
	

	if ( pId == iOwner ) then -- only owner can lock interior for now
		interiors[ interiorID ].locked = 1
		exports.sql:query_free( "UPDATE TABLE `interiors` SET locked = '1'")
	end
 end
end