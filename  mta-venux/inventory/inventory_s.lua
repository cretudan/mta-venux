--[[
--    <<< VENUX _ SWIFT >>>
--      DEV: AeroXbird
--]]

sql = exports.sql

items = {}

local _root = getRootElement()

function _construct() 
	for i, v in ipairs( getElementsByType( "player" ) ) do
		bindKey( v, "i", "down", openInventory, v )
		load( v ) -- simply load all items for our player.
	end
end

function openInventory( player )
	if ( getElementType( player ) == "player" and getElementData( player, "loggedin" ) == true ) then
		reload( player ) -- reload inventory every time we open it.
		triggerClientEvent(player, "toggleInventory", _root, items[player] ) -- show the inventory
	else
		return MISSING_ARGUMENTS
	end
end

function _constructJoin()
	if ( getElementType( source ) == "player" ) then
		bindKey( source, "i", "down", openInventory, source )
	end
end

---------------------------------- || EXPORTED FUNCTIONS || --------------------------------

-- FUNCTION: load ( player player )
-- Description: This function will load a players items and smash it right into our little table.
function load( player )
		local charid = exports.account:getCharacterID( getElementData( player, "characterName" ) )
		items[player] = {}

		local i, error = sql:query_assoc( "SELECT * FROM `items` WHERE owner = ".. charid .." ORDER BY `id` ASC")

		for key, value in ipairs( i ) do
			-- save all of our items nice and ordered in the great invention called a table.
			items[player][key] = {}
			items[player][key].id = value.id
			items[player][key].itemid = value.itemid
			items[player][key].itemvalue = value.itemvalue
			items[player][key].owner = charid
			items[player][key].itemname = tostring ( value.itemname )
		end
		return true
end

function has( player, itemValue, itemID )
	if ( getElementType( player ) == "player" ) then
		local result, error = sql:query_free( "SELECT * FROM `items` WHERE owner = ".. charid .." AND itemvalue = '".. itemValue .."' AND itemid = '".. itemID .."'")
		
		if ( #result == 1 ) then
			return true
		else
			return false
		end
	else
		return MISSING_ARGUMENTS
	end
end

-- FUNCTION: remove ( player player, int itemid )
-- Description: This will remove an item from the item table, make sure you reload the table with the client before continuing.
function remove( player, itemid )
	if ( getElementType( player ) == "player" and type ( itemid ) == "number" ) then
		if ( items[player][itemid] ~= nil ) then
			items[player][itemid] = nil
		end
	else
		return MISSING_ARGUMENTS
	end
end


-- FUNCTION: reload ( player player )
-- Description: This function will destroy the players item table and it will recreate it again, useful when you add a new table, 
--				but its very resource intensive if you have a full server, so use with caution.
function reload( player )
	if ( getElementType( player ) == "player" ) then
		if ( items[player] ~= nil ) then
			items[player] = nil -- clean the table up.
			load( player ) -- reload it.
		else
			load( player ) -- simply load it.
		end
	else
		return MISSING_ARGUMENTS
	end
end


-- FUNCTION: getItemsTable( )
-- Description: This will mash you the whole item table holding all tables with the items of every player, thats playing in the server.
function getItemsTable()
	return items
end

-- FUNCTION: add( player player, int index, int itemid, int itemvalue, string itemname )
-- Description: This will allow you to add an item to your item table, and it will also initialize your table if you havent for some reason, 
-- and then it will try to add your new item anyway.
function add( player, index, itemid, itemvalue, itemname )
	if ( getElementType( player ) == "player" and type ( index ) == "number" and type ( itemid ) == "number" and type ( itemvalue ) == "number"  and type ( itemname ) == "string" ) then
		if ( items[player] ~= nil ) then -- items for player have been initialized.
			local charid = exports.account:getCharacterID( getElementData( player, "characterName" ) )

			items[player][index] = index
			items[player][index].itemid = itemid
			items[player][index].itemvalue = itemvalue
			items[player][index].owner = charid
			items[player][index].itemname = tostring ( itemname )
		elseif( items[player] == nil ) then -- not initialized, be nice enough to initialize and add item afterwards.
			if ( load ( player ) ) then
				local charid = exports.account:getCharacterID( getElementData( player, "characterName" ) )

				items[player][index] = index
				items[player][index].itemid = itemid
				items[player][index].itemvalue = itemvalue
				items[player][index].owner = charid
				items[player][index].itemname = tostring ( itemname )
			end
		end
	else
		return MISSING_ARGUMENTS
	end
end

function getItemDescription( itemid )
	if ( type( itemid ) == "number" ) then
		if ( itemid == 1 ) then -- test item
			return "An item that help the player\n with testing his scripts.";
		end
	else
		return MISSING_ARGUMENTS
	end
end
---------------------------------------------------------------------------------------------------------



function toggleVehicleLock( player, vehicleID )
	if ( getElementType( player ) == "player" and type ( vehicleID ) == "number" ) then
		exports.vehicles:removeVehicleLocks( player, vehicleID )
	end
end

addEvent("removeVehicleLocks", true )
addEventHandler("removeVehicleLocks", _root, toggleVehicleLock )

addEvent("getItemDescription", true)


addEvent("getItemsTable", true)
addEventHandler("getItemsTable", _root, getItemsTable)

addEventHandler("onPlayerJoin", _root, _constructJoin)
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), _construct)