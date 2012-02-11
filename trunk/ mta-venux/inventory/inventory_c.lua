--[[
---			|\-/| Roleplay VX Version one |\-/|  ---
---		     Developer: AeroXbird 			     ---
--]]
	
local _root = getRootElement()
local sx, sy = guiGetScreenSize()
local windowWidth, windowHeight = 450, 288
local left = sx/2 - sx/2
local top = sy/2 - sy/2

gui = {}

gui._placeHolders = {}

myItems = {}

local selectedIndex = nil

alpha = 1
windowAlpha = 1

function getX(xcoord)
	return sx / 100 * xcoord
end
 
--This function takes a number from 0 to 100 and returns the absolute y-position on the screen. A value below 0 or over 100 will return values that are off the screen.
function getY(ycoord)
	return sy / 100 * ycoord
end


function showInventory(items)
	gui["_root"] = guiCreateWindow(getX(62.0), getY(63.0), windowWidth, windowHeight, "Inventory", false)

	guiSetProperty(gui["_root"], "TitlebarEnabled", "false")
	guiWindowSetSizable(gui["_root"], false)
	
	gui["listWidget"] = guiCreateGridList(10, 25, 531, 192, false, gui["_root"])
	guiGridListSetSortingEnabled(gui["listWidget"], false)
	
	gui["ItemID"] = guiGridListAddColumn(gui["listWidget"], "Item ID", 0.10)
	gui["ItemName"] = guiGridListAddColumn(gui["listWidget"], "Item Name", 0.65)
	gui["ItemValue"] = guiGridListAddColumn(gui["listWidget"], "Value", 0.10)

	gui["pushButton"] = guiCreateButton(10, 225, 75, 23, "Drop", false, gui["_root"])

	
	gui["pushButton_2"] = guiCreateButton(90, 225, 75, 23, "Use", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["pushButton_2"], useItem)

	
	gui["pushButton_3"] = guiCreateButton(170, 225, 75, 23, "Show", false, gui["_root"])

	
	gui["pushButton_4"] = guiCreateButton(470, 225, 75, 23, "Close", false, gui["_root"])

	addEventHandler ( "onClientGUIClick", gui["listWidget"], clickedItem )
	if ( type( items ) == "table" ) then -- this is very important, otherwise inventory wont work :)
	-- items table is for the client player only, otherwise some fat fuck will make a tool to see other peoples' inventory.
		myItems = items
		gui["row"] = {}
		for i, v in ipairs( myItems ) do
			gui["row"].i = guiGridListAddRow(gui["listWidget"])
			guiGridListSetItemText(gui["listWidget"], gui["row"].i, gui["ItemID"], myItems[i].id, false, false )
			guiGridListSetItemText(gui["listWidget"], gui["row"].i, gui["ItemName"], myItems[i].itemname, false, false )
			guiGridListSetItemText(gui["listWidget"], gui["row"].i, gui["ItemValue"], myItems[i].itemvalue, false, false )
		end

	else
		return MISSING_ARGUMENTS
	end
	
end

function clickedItem( button, state, sx, sy, x, y, z, elem )
	if ( button == "left") then
		-- The + 1 is critical, because the gridlists count from zero, and we start at 1 :-)
		local itemindex = guiGridListGetSelectedItem ( gui["listWidget"] ) + 1
		if ( selectedIndex == tonumber( itemindex ) ) then 
			selectedIndex = nil
			removeEventHandler("onClientRender", _root, draw3DOverlay)
			resetAlpha()
		elseif ( selectedIndex ~= nil ) then
			selectedIndex = nil
			removeEventHandler("onClientRender", _root, draw3DOverlay)
			resetAlpha()

			selectedIndex = tonumber( itemindex )
			addEventHandler("onClientRender", _root, draw3DOverlay)
		else
			selectedIndex = tonumber( itemindex )
			addEventHandler("onClientRender", _root, draw3DOverlay)
		end
	end
end

function resetAlpha()
	alpha = 0
	windowAlpha = 0
end

function draw3DOverlay()
	if ( type ( selectedIndex ) == "number" ) then
		if ( myItems[selectedIndex] ~= nil ) then
		
			if ( alpha < 200 ) then
				alpha = alpha + 4
			else
				alpha = 200
			end

			if ( windowAlpha < 180 ) then
				windowAlpha = windowAlpha + 3
			else
				windowAlpha = 180
			end

			local goodWidth = dxGetTextWidth( getItemDescription( myItems[selectedIndex].itemid ), 1.7 ) + 128 + 30 
			-- formula: description + image + offset space

			local base = dxDrawRectangle(getX(58.0), getY(41.0), goodWidth, 190, tocolor( 0, 0, 0, windowAlpha ) ) -- main window
			if ( myItems[selectedIndex].itemid == 2 ) then
				local title = dxDrawText( myItems[selectedIndex].itemname .."  ( ".. myItems[selectedIndex].itemvalue .. " )" , getX(70.0), getY(45.0), 0, 0, tocolor(255, 255, 255, alpha ), 1.4, "pricedown")
			else
				local title = dxDrawText( myItems[selectedIndex].itemname .."  ( ".. myItems[selectedIndex].id .. " )", getX(70.0), getY(45.0), 0, 0, tocolor(255, 255, 255, alpha ), 1.4, "pricedown")
			end
			local description = dxDrawText( getItemDescription( myItems[selectedIndex].itemid ), getX(68.0), getY(51.0), 0, 0, tocolor( 255, 255, 255, alpha ), 1.7 )
			local image = dxDrawImage(getX(58.5), getY(43.5), 128, 128, "items/".. myItems[selectedIndex].itemid ..".png", 0, 0, 0, tocolor( 255, 255, 255, alpha ) )
		
		end
	end
end

function useItem( )
	if ( selectedIndex ~= nil ) then
		if ( type( myItems[selectedIndex] ) == "table" ) then
		local itemValue = myItems[selectedIndex].itemvalue
		local itemid = myItems[selectedIndex].itemid
			if ( itemid == 2 ) then -- vehicle keys
				triggerServerEvent("removeVehicleLocks", _root, getLocalPlayer(), tonumber( itemValue ) ) -- lock or unlock.
			end
		else
			return MISSING_ARGUMENTS
		end
	else
		return MISSING_ARGUMENTS
	end
end

function reloadTable()
	newItems = triggerServerEvent("getItemsTable", _root)
	outputDebugString( tostring( type( newItems ) ) )
end
addCommandHandler("reloadTable", reloadTable) -- just for testing if we can retrieve a table, otherwise time2debug

function toggleInventory( items )
	if ( type ( items ) == "table" ) then
		if ( gui["_root"] == nil or guiGetVisible( gui["_root"] ) == false  ) then
			showInventory(items)
			showCursor( true )
		else
			guiSetVisible( gui["_root"], false )
			gui["row"] = {}
			gui = {}
			showCursor( false )
			if ( selectedIndex ~= nil ) then
				selectedIndex = nil
				removeEventHandler("onClientRender", _root, draw3DOverlay)
				resetAlpha()
			end
		end
	else
		return MISSING_ARGUMENTS
	end
end

--------------------------------------------------- || EXPORTED FUNCTIONS || -----------------------------------------

function getItemDescription( itemid )
	if ( type( itemid ) == "number" ) then
		if ( itemid == 1 ) then -- test item
			return "An item that help the player\n with testing his scripts.";
		elseif ( itemid == 2 ) then -- vehicle keys
			return "These keys give you access to a vehicle. \n there's also a button to control the doors.";
		end
	else
		return MISSING_ARGUMENTS
	end
end

----------------------------------------------------------------------------------------------------------------

addEvent("toggleInventory", true)
addEventHandler("toggleInventory", _root, toggleInventory)