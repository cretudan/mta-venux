--[[
--    <<< VENUX _ SWIFT >>>
--      DEV: AeroXbird
--]]

_root = getRootElement()

local vehicleIDs = { }
local vehicles = { }

function _constructVehicles() -- this will load vehicles once the resource is started.
		-- load all vehicles
		local result = exports.sql:query_assoc("SELECT * FROM `vehicles` ORDER BY vehicleID ASC" )
		if result then
			for i, data in ipairs( result ) do
				local vehicle = createVehicle( data.model, data.respawnX, data.respawnY, data.respawnZ, data.respawnRotX, data.respawnRotY, data.respawnRotZ, tostring( data.numberplate ) )

				-- tables for ID -> vehicle and vehicle -> data
				vehicleIDs[ data.vehicleID ] = vehicle
				vehicles[ vehicle ] = { vehicleID = data.vehicleID, interior = data.interior, dimension = data.dimension, ownerID = data.ownerID, engineState = data.enginestate, tintedWindows = data.tintedWindows, fuel = data.fuel, respawnX = data.respawnX, respawnY = data.respawnY, respawnZ = data.respawnZ, respawnRotX = data.respawnRotX, respawnRotY = data.respawnRotY, respawnRotZ = data.respawnRotZ }

				-- some properties
				setElementHealth( vehicle, data.health )
				if tonumber( data.health ) <= 300 then -- badly damaged - black smoke.
					setVehicleDamageProof( vehicle, true )
					vehicles[ vehicle ].engineState = false
				end

				if ( tonumber( data.engineState ) == 1 ) then 
					setVehicleEngineState( vehicle, true )
				elseif ( tonumber( data.engineState ) == 0 ) then
					setVehicleEngineState( vehicle, false )
				end

				if ( tonumber( data.locked ) == 1 ) then 
					setVehicleLocked( vehicle, true )
				elseif ( tonumber( data.locked ) == 0 ) then
					setVehicleLocked( vehicle, false )
				end

				setVehicleOverrideLights( vehicle, data.lights )
				setVehicleRespawnPosition( vehicle, data.respawnX, data.respawnY, data.respawnZ, data.respawnRotX, data.respawnRotY, data.respawnRotZ )
				setVehicleColor( vehicle, data.red1, data.green1, data.blue1, data.red2, data.green2, data.blue2 )


				setElementData( vehicle, "ownerID", data.ownerID )
				setElementData( vehicle, "faction", data.faction )
				setElementData( vehicle, "vehicleID", data.vehicleID )
				setElementData( vehicle, "numberplate", data.numberplate )
			end
		end
end

function _globalSave()
	for key, vehicle in ipairs( getElementsByType( "vehicle" ) ) do -- attempt to find every vehicle in the game.
		if ( getElementData( vehicle, "vehicleID" ) ~= nil and getVehicleOccupant( vehicle, 0 ) == false ) then -- it has been spawned by our code, and nobody is driving it.
			local carX, carY, carZ = getElementPosition( vehicle )
			local carRotX, carRotY, carRotZ = getElementRotation( vehicle )
			local carHealth = getElementHealth( vehicle )
			local carFuel = getElementData( vehicle, "fuel" )
			local engine = getVehicleEngineState ( vehicle )

			local success, error = exports.sql:query_free("UPDATE `vehicle` SET posX = '".. carX .."', posY = '".. carY .."', posZ = '".. carZ .."', rotX = '".. carRotX .."', rotY = '".. carRotY .."', rotZ = '".. carRotZ .."', health = '".. carHealth .."', fuel = '".. carFuel .."', enginestate = '".. engine .."'")
				if ( error ) then
					return outputDebugString(error) -- output the mysql error code.
				else
					return true -- otherwise we're all clear and we can say we have completed.
				end
		else
			return CAR_OCCUPIED_OR_NOT_RP_VEHICLE; -- occupied, or not spawned by our system.
		end
	end
end

function _assembleVehicle(vehicleID)
	local data = exports.sql:query_assoc("SELECT * FROM `vehicles` WHERE vehicleID = '".. tonumber( vehicleID ) .."'");
	if ( data ) then
			local vehicle = createVehicle( data.model, data.respawnX, data.respawnY, data.respawnZ, data.respawnRotX, data.respawnRotY, data.respawnRotZ, data.numberplate )

			-- tables for ID -> vehicle and vehicle -> data
			vehicleIDs[ data.vehicleID ] = vehicle
			vehicles[ vehicle ] = { vehicleID = data.vehicleID, interior = data.interior, dimension = data.dimension, ownerID = data.ownerID, engineState = data.enginestate, tintedWindows = data.tintedWindows, fuel = data.fuel, respawnX = data.respawnX, respawnY = data.respawnY, respawnZ = data.respawnZ, respawnRotX = data.respawnRotX, respawnRotY = data.respawnRotY, respawnRotZ = data.respawnRotZ }

			-- some properties
			setElementHealth( vehicle, data.health )
			if tonumber( data.health ) <= 300 then -- badly damaged - black smoke.
				setVehicleDamageProof( vehicle, true )
				vehicles[ vehicle ].engineState = 0
			end

			setVehicleEngineState( vehicle, data.engineState )
			setVehicleLocked( vehicle, data.locked )
			setVehicleOverrideLights( vehicle, data.lights )
			setVehicleRespawnPosition( vehicle, data.respawnX, data.respawnY, data.respawnZ, data.respawnRotX, data.respawnRotY, data.respawnRotZ )
			setVehicleColor( vehicle, data.red1, data.green1, data.blue1, data.red2, data.green2, data.blue2 )

			setElementData( vehicle, "ownerID", data.ownerID )
			setElementData( vehicle, "faction", data.faction )
			setElementData( vehicle, "vehicleID", data.vehicleID )
			setElementData( vehicle, "numberplate", data.numberplate )

			return vehicle, vehicleID
	end
end
		
function _enterVehicle( thePlayer, seat, jacked )
	if ( thePlayer and seat ) then
		outputChatBox("* You are now driving a: ".. getVehicleName( source ), thePlayer, 255, 97, 3)
		if ( getElementData( thePlayer, "adminrank" ) >= 1 ) then -- only admins may see the owner.
			outputChatBox("* This vehicle belongs to: ".. string.gsub(exports.account:getCharacterName( getElementData( source, "ownerID" ) ), "_", " ") ..".", thePlayer, 255, 97, 3)
		end
		
	end
end

function _lockVehicle( thePlayer ) 
local theVehicle = getPedOccupiedVehicle ( thePlayer )
local vehicleID = vehicles[ theVehicle ].vehicleID
	if ( theVehicle and thePlayer ) then
		if ( getPedOccupiedVehicleSeat( thePlayer ) == 0 ) then -- mta lua vm is like politics, works in mysterious ways.
			_changeVehicleLockstate( thePlayer, theVehicle )
		else -- we're not in the driver seat, for now this does not do a lot, but in the future we can edit this to trigger cool things.
				outputChatBox("You are not in the drivers seat, so you cannot lock the vehicle.")
			end
		end
	else -- we're not in a vehicle, assuming we are near it?
		local pX, pY, pZ = getElementPosition( thePlayer )
		local sphere = createColSphere ( pX, pY, pZ, 10 )
		local elements = getElementsWithinColShape ( sphere, "vehicle" )
		
		-- get rid of the collision sphere since we no longer need it.
		destroyElement ( sphere )
		sphere = nil
		
		for i, v in ipairs( elements ) do
			local vehID = getElementData( v, "vehicleID" )
			
			-- if we have the keys for this car :)
			if ( exports.inventory:has( thePlayer, vehID, 2 ) ) then
				_changeVehicleLockstate( thePlayer, v )
			end
		end
	end	
end

function _changeEngineState( thePlayer )
local theVehicle = getPedOccupiedVehicle ( thePlayer )
	if ( theVehicle ) then
		if ( getPedOccupiedVehicleSeat( thePlayer ) == 0 ) then
			if ( getVehicleEngineState( theVehicle ) == true and vehicles[ theVehicle ].engineState == 1 ) then
				setVehicleEngineState( theVehicle, false ) -- turn it off.
				vehicles[ theVehicle ].engineState = 0 -- update table values.
			elseif ( getVehicleEngineState( theVehicle ) == false and vehicles[ theVehicle].engineState == 0 ) then
				setVehicleEngineState( theVehicle, true ) -- turn it on
				vehicles[ theVehicle ].engineState = 1
			end
		end
	end
end
			
function _changeLightsState( thePlayer )
local theVehicle = getPedOccupiedVehicle( thePlayer )
	if ( getElementType( theVehicle ) == "vehicle" ) then
		if ( getPedOccupiedVehicleSeat( thePlayer ) == 0 ) then
			if ( getVehicleOverrideLights( theVehicle ) == 0 ) then -- default
				setVehicleOverrideLights( theVehicle, 1 ) -- turn on ( default )
			elseif ( getVehicleOverrideLights( theVehicle ) == 1 ) then -- on
				setVehicleOverrideLights( theVehicle, 2 ) -- turn off
			elseif ( getVehicleOverrideLights( theVehicle ) == 2 ) then -- off
				setVehicleOverrideLights( theVehicle, 1 ) -- turn on
			else
				setVehicleOverrideLights( theVehicle, 0 ) -- if we're retarded just reset to default to make sure we dont get any seizures.
			end
		else
			return NOT_DRIVER
		end
	else
		return ELEMENT_NOT_VEHICLE
	end
end

function _changeVehicleLockstate( player, vehicle )
	if ( getElementType( vehicle ) == "vehicle" ) then
	local vehicleID = vehicles[ vehicle ].vehicleID
		if ( isVehicleLocked( vehicle ) == true ) then
			setVehicleLocked( vehicle, false ) 
			local success, error = exports.sql:query_free("UPDATE `vehicles` SET locked = '0' WHERE vehicleID = ".. tonumber( vehicleID ) .."")
				if ( success == false ) then
					outputDebugString( error, 2 ) 
				end

			exports.chat:meAction( player, "unlocks the vehicle doors.")
		elseif ( isVehicleLocked( vehicle ) == false ) then
			setVehicleLocked( vehicle, true )
			local success, error = exports.sql:query_free("UPDATE `vehicles` SET locked = '1' WHERE vehicleID = ".. tonumber( vehicleID ) .."")
				if ( success == false ) then
					outputDebugString( error, 2 )
				end

			exports.chat:meAction( player, "locks the vehicle doors.")
		end
	end
end



------------------------- || EXPORTED FUNCTIONS || ---------------------------------------
-- FUNCTION: _vehicleSave( int vehicleID )
-- Description: Allows you to save your vehicle through code, for example when a player has crashed, when you modify the color, etc.
function _vehicleSave(vehicleID)
	if ( vehicleIDs[ vehicleID ] ~= nil ) then -- we're here.
		if ( getVehicleOccupant( vehicle, 0 ) == false ) then -- it has been spawned by our code, and nobody is driving it.
			local carX, carY, carZ = getElementPosition( vehicle )
			local carRotX, carRotY, carRotZ = getElementRotation( vehicle )
			local carHealth = getElementHealth( vehicle )
			local carFuel = getElementData( vehicle, "fuel" )
			local engine = getVehicleEngineState ( vehicle )
				
			local success, error = exports.sql:query_free("UPDATE `vehicles` SET posX = '".. carX .."', posY = '".. carY .."', posZ = '".. carZ .."', rotX = '".. carRotX .."', rotY = '".. carRotY .."', rotZ = '".. carRotZ .."', health = '".. carHealth .."', fuel = '".. carFuel .."', enginestate = '".. engine .."'")

			if ( error ) then
				return outputDebugString(error)
			else
				return true
			end
		else
			return VEHICLE_OCCUPIED; -- vehicle is occupied
		end
	else
		return NOT_RP_VEHICLE; -- vehicle is not spawned by the system.
	end
end

function removeVehicleLocks( player, vehicleID )
	if ( getElementType( player ) == "player" and type ( vehicleID ) == "number" ) then
		local pX, pY, pZ = getElementPosition( player )
		local vX, vY, vZ = getElementPosition( vehicleIDs[ vehicleID ] )
			if ( getDistanceBetweenPoints3D( pX, pY, pZ, vX, vY, vZ ) <= 30 ) then -- we're nearby

				_changeVehicleLockstate( player, vehicleIDs[ vehicleID ] )

			else
				return end
	else
		return MISSING_ARGUMENTS
	end
end


-- FUNCTION: makeVehicle( int vehicleMode, int owner, int colorR1, int colorG1, int colorB1, int colorR2, int colorG2, int colorB2, float placeX, float placeY, float placeZ, float placeRotX, float placeRotY, float plateRotZ )
-- Description: Allows the creation of a vehicle through the code, for vehicle shops for example.
function makeVehicle( vehicleModel, owner, colorR1, colorG1, colorB1, colorR2, colorG2, colorB2, placeX, placeY, placeZ, placeY, placeRotX, placeRotY, placeRotZ )
	if ( vehicleModel and owner and colorR1 and colorG1 and colorB1 and colorR2 and colorG2 and colorB2 ) then -- just making sure all the arguments are there.
		if ( exports.account:getCharacterExists( owner ) == true ) then -- the owner id turns out to be valid

			-- randomize plate
			local letter1 = string.char(math.random(65,90))
			local letter2 = string.char(math.random(65,90))
			local plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)

			local vehicleID, error = exports.sql:query_insertid( "INSERT INTO `vehicles` VALUES('', '".. tonumber( vehicleModel ) .."', '".. placeX .."', '".. placeY .."', '".. placeZ .."', '".. placeRotX .."', '".. plateRotY .."', '".. placeRotZ .."', '".. plate .."', '".. tonumber( owner ) .."', 0, 0, 0, 100, 0, 0, 0, 0, '', '', '', '', '', '', '".. colorR1 .."', '".. colorG1 .."', '".. colorB1 .."', '".. colorR2 .."', '".. colorG2 .."', '".. colorB2 .."' ")
				if ( vehicleID ) then
					if ( _assembleVehicle( vehicleID ) ) then -- attempt to spawn our dear vehicle
						return true -- we can tell we're done here
					else
						return false -- something went wrong while making the vehicle
					end
				else
					return outputDebugString( error ) -- Output the MySQL error, because mysql failed on us.
				end
		else
			return CHARID_INVALID -- charid was invalid
		end
	else
		return MISSING_ARGUMENTS -- We're missing some argument(s) here buddy.
	end
end

-- FUNCTION: _reloadVehicle( int vehicleID )
-- Description: Allows the reloading of vehicle when changes have been made that require vehicle to be re-spawned / reloaded.
function _reloadVehicle( vehicleID ) 
	if ( vehicleIDs[ vehicleID ] ~= nil ) then
			destroyElement( vehiclesIDs[ vehicleID ] ) -- destroy vehicle element so we can re-create it.
			vehicles[ vehicleIDs[ vehicleID ] ] = nil
			vehicleIDs[ vehicleID ] = nil
			_assembleVehicle( vehicleID ); -- run assemble script.
	end
end

function repairVehicle( vehicleID )
	if ( type ( vehicleID ) == "number" ) then
		if ( vehicleIDs[ vehicleID ] ~= nil ) then
			if ( getElementType( vehicleIDs[ vehicleID ] ) == "vehicle" ) then
				local result, error = exports.sql:query_free( "UPDATE `vehicles` SET health = '1000' WHERE vehicleID = '".. tonumber( vehicleID ) .."'")
					if ( result ) then
						fixVehicle( vehicleIDs[ vehicleID ] )
					else
						return outputDebugString( error )
					end
			else
				return MISSING_ARGUMENTS
			end
		else
			return MISSING_ARGUMENTS
		end
	else
		return MISSING_ARGUMENTS
	end
end

function getVehicleByID( vehicleID )
	if ( vehicleIDs[ vehicleID ] ~= nil ) then
		return vehicleIDs[ vehicleID ]
	else
		return MISSING_ARGUMENTS
	end
end

------------------------------------------------------------------------------------------------------------------

function _constructPlayerJoin(thePlayer)
	if ( getElementType( source ) == "player" ) then
		bindKey( source, "k", "down", _lockVehicle, source ) -- locking bind
		bindKey( source, "j", "down", _changeEngineState, source ) -- toggle the engine
		bindKey( source, "l", "down", _changeLightsState, source ) -- toggle the lights.
	end
end

function _constructPlayerJoin2(thePlayer)
	if ( getElementType( thePlayer ) == "player" ) then
		bindKey( thePlayer, "k", "down", _lockVehicle, thePlayer ) -- locking bind
		bindKey( thePlayer, "j", "down", _changeEngineState, thePlayer ) -- toggle the engine
		bindKey( thePlayer, "l", "down", _changeLightsState, thePlayer ) -- toggle the lights.
	end
end

addCommandHandler("bindmykeys", _constructPlayerJoin2)


addEventHandler("onPlayerJoin", _root, _constructPlayerJoin)
addEventHandler("onVehicleEnter", _root, _enterVehicle)
	

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), _constructVehicles)