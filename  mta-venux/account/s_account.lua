--[[
---			|\-/| Roleplay VX Version one |\-/|  ---
---		     Developer: AeroXbird & Lukkaz	     ---
--]]
-- random quote:
-- I get happy when i just got laid.
-- A.

--TODO LIST!
-- * ADD ADMIN DUTY
-- * SAVE MORE DATA INTO ELEMENT

_root = getRootElement();

local attempts = 0
local startingPay = 200 --change this to change how much your players get when they create a character.

pedTable = {}

-- TODO: Add new values once i get the time.
function _construct()
	for i, v in ipairs(getElementsByType("player")) do -- find every one of you's in this place
		toggleAllControls (v, false, false, true ) 
		setElementData(v, "loggedin", false ) -- because we are not logged in
		setElementData(v, "adminrank", 0 ) -- just for good measure
		setElementData(v, "username", getPlayerName( source )) -- saving the username you come in with.
		setElementData(v, "loginAttempts", 0)
		setElementData(v, "ooc", 0 ) -- dont need people spamming people at main menu
		setCameraMatrix(v, 783.44, -1287.73, 23.5, 733.9, -1276.6, 13.5)
		fadeCamera(v, true, 1)
	end
end

-- TODO: Add some new values once i get the time.
function _joinConstruct()
	if ( getElementType(source) == "player" ) then
		toggleAllControls (source, false, false, true ) 
		--triggerClientEvent(source, "toggleDashboard", source, 1)
		setElementData(source, "loggedin", false )
		setElementData(source, "adminrank", 0 )
		setElementData(source, "username", getPlayerName( source ) )
		setElementData(source, "loginAttempts", 0)
		setElementData(source, "ooc", 0 )
		setPlayerNametagColor(player, 127, 127, 127)
		fadeCamera(source, true, 1)
		setCameraMatrix(source, 783.44, -1287.73, 23.5, 733.9, -1276.6, 13.5)
	end
end

-- TODO: Make this a little more secure.
function attemptLogin(thePlayer, username, password)
	if ( username ~= "" and password ~= "" ) then 
		local result = exports.sql:query_assoc_single("SELECT * FROM `accounts` WHERE username = '".. tostring(username) .."' AND password = '".. exports.sql:escape_string( md5( password ) ) .."'")
			 if ( result ) then -- result is actually valid
				setElementData(thePlayer, "adminrank", result.rank )
				setElementData(thePlayer, "userid", result.id + 25565)
				setElementData(thePlayer, "accountid", result.id)
				setElementData(thePlayer, "atCharSelect", true)
				setElementData(thePlayer, "adminduty", result.adminduty)
				setElementDimension(thePlayer, getElementData(thePlayer, "userid"))

				triggerClientEvent(thePlayer, "characterSelect", thePlayer)
				triggerClientEvent(thePlayer, "toggleDashboard", thePlayer, 0)
				setupCharacterSelect(thePlayer)
				setElementDimension(thePlayer, getElementData(thePlayer, "userid"))
				
			else
				attempts = tonumber(getElementData(thePlayer, "loginAttempts"))
				attempts = tonumber(attempts) + 1
				setElementData(thePlayer, "loginAttempts", attempts)
				
			if attempts >= 3 then
				kickPlayer(thePlayer, true, false, false, _root, "Too many login attempts")
			else
				outputChatBox("Username or password is invalid! You only have "..(3-attempts).." attempts left!",thePlayer, 255,0,0 )
				--return outputDebugString("ERROR 1: Failed to retrieve account for user: ".. getPlayerName(thePlayer) .."   function: attemptLogin", 3)
			end
			end
	else
		return outputDebugString("ERRROR 2: Failed to get the players username, password or element type mismatch at function attemptLogin for user:".. getPlayerName(thePlayer), 3)
	end
end

-- TODO: Make this a little more secure shall we?
function attemptRegister(thePlayer, username, password)
	if ( username ~= "" and password ~= "" ) then
		local success, error = exports.sql:query_free("INSERT INTO `accounts` VALUES('', '".. tostring(username) .."', '".. md5( tostring( password ) ) .."', '".. getPlayerSerial(thePlayer) .."', '0')")
			if ( error ) then
				return outputDebugString( error )
			else
				return outputChatBox("Successfully registered your account!", thePlayer, 100, 0, 100) 
			end
	end
end

function setupCharacterSelect(thePlayer)
local accountID = getElementData(thePlayer, "accountid")
pedTable[accountID] = {}
	if ( getElementData(thePlayer, "accountid") ~= "" ) then
		q = exports.sql:query_assoc("SELECT * FROM `characters` WHERE accountid = ".. tonumber(getElementData(thePlayer, "accountid") ).. " ")
			triggerClientEvent(thePlayer, "pickAped", thePlayer, true)
			-- location stuff will go here, to set the first ped's location, then we will work that up in the loop.
			local startX = 763.26171875
			local startY = -1296.1162109375
			local startZ = 13.5625
			local myY = startY

				-- X: 763.26171875  Y: -1291.1162109375  Z: 13.5625
				if ( q == false ) then
						outputDebugString("Error: This player doesnt have any characters.", 3) -- output info message.
						outputChatBox("* You do not have any characters yet, please create one to play.", thePlayer, 180, 100, 0 )
				else

					for key, result in ipairs( q ) do

						myY = myY + 3 -- move to right

						ped = createPed(result.charskin, startX, myY, startZ, -90)

							if (getElementType(ped) == "ped" ) then
								outputDebugString("Ped created is indeed a ped!",3)
							end 

						setElementDimension( ped, getElementData(thePlayer, "userid") )
						setElementData( ped, "characterid", result.id )
						setElementData( ped, "skin", result.charskin )
						setElementData( ped, "charName", result.charactername )
						setElementData( ped, "charOwner", getPlayerName(thePlayer) )

						pedTable[accountID][key] = ped
						outputDebugString( tostring(myY) )
					end
				end
	else
		return outputDebugString("ERROR 5: setupCharacterSelect could not be started, first IF failed.", 2)
	end
end

function removePed(source)
local accountID = getElementData(source, "accountid")
	for k, v in pairs(pedTable[accountID]) do
		destroyElement(pedTable[accountID][k])
		pedTable[accountID][k] = nil
	end
end
	
function playerSpawn(player, charactername)
	if ( player and charactername ) then
			local result = exports.sql:query_assoc_single("SELECT * FROM `characters` WHERE charactername = '".. charactername .."' ")

			if ( result ) then 

				spawnPlayer(player, 0, 0, 0, 0, characterskin )

				setElementPosition(player, result.savedX, result.savedY, result.savedZ) -- We are most likely already spawned, so we just reset pos and skin.
				setElementModel(player, tonumber( result.charskin ))

				setPlayerMoney( player, result.cash )
			
				bindKey(player, "end", "down", "home")
			
				setElementDimension(player, 0)
				setCameraTarget(player)
				
				setElementData(player, "ooc", 1 )
				setElementData(player, "loggedin", true)
				setElementData(player, "atCharSelect", false)
				setElementData(player, "characterName", charactername)
				setElementData(player, "characterID", result.charid)
				
				if ( getElementData(player, "adminduty" ) == 1 ) then
					setPlayerNametagColor(player, 255, 194, 14)
				elseif ( getElementData( player, "adminduty" ) == 0 ) then
					setPlayerNametagColor(player, 255, 255, 255)
				end
				
				setPlayerName(player, charactername)
			
				toggleAllControls (player, true, true, true ) 
				triggerClientEvent(player, "clean_up", player)
				triggerEvent("onCharacterSpawned", player, player, charactername)
				triggerClientEvent(player, "pickAped", false)
				showCursor(player, false)
			else
				return false end
	end
end

function onCharacterSpawned( player, charactername )
-- this function is triggered after we have spawned.
	outputChatBox("Welcome to Roleplay!", player, 255, 130, 0)
	--outputChatBox("Press the 'end' key to change characters.", player, 255,184,0)

end
addEvent("onCharacterSpawned", true)
addEventHandler("onCharacterSpawned", _root, onCharacterSpawned)

-- This will handle the quitting, once a player quits, we will use this to save his information.
function _playerQuit(quitType, reason, responsibleElement)
	if ( quitType == "Timed Out" ) then -- the poor lad timed out, lets help him save his shit.
		local saveplayer = exports.save:savePlayer( source )
		if ( saveplayer ) then 
				if ( getPedOccupiedVehicle(source) ) then
					-- TODO: insert vehicle saving options here, also locking vehicle should be here.
				end
		else
			return false
		end
	elseif ( quitType == "Quit" ) then
		local saveplayer = exports.save:savePlayer( source )
		if ( saveplayer ) then 
				if ( getPedOccupiedVehicle(source) ) then
					-- TODO: insert vehicle saving options here, also locking vehicle should be here.
				end
		else
			return false
		end
	end
end



function createCharacter(name, weight, height, skin, age, gender)
	local accntID = getElementData(source, "accountid")
	result = exports.sql:query_assoc_single("SELECT charactername FROM `characters` WHERE charactername = '".. name .."' ")
	
	if ( result ~= false ) then ---the char name exists
		outputChatBox("Please select another character name. (Name in use!)")
	else
		local name = string.gsub(name, " ", "_")
		local dbid = exports.sql:query_free("INSERT INTO characters SET charactername='"..exports.sql:escape_string(name).."', accountid='"..tonumber(accntID).."', charskin='"..skin.."',  age='"..age.."', intelligence='".. math.random(80, 160) .."',  faction_id='1', faction_name='San Andreas Government', faction_rank='1', hospitalized='0', driverslicense='0', drivingexperience='0', charlevel='0', charexp='0', perk1='', perk2='', cash='"..startingPay.."', savedX='835.009765625', savedY='-1313.96875', savedZ='13.546875', health='100', armor='0', interior='0', dimension='0'")
		outputChatBox("* Your character has successfully been created!", source, 0, 255, 127)
		triggerClientEvent(source, "characterSelect", source)
	end
end
					  

function reloadPeds( player )
	if ( pedTable ~= nil ) then
		triggerClientEvent(player, "pickAped", player, false)
		removePed( player )
		setupCharacterSelect( player )
	end
end

addEvent("reloadPeds", true)
addEventHandler("reloadPeds", _root, reloadPeds)

--------------------------------------------------------------------------
--|| Exported functions ||-
--------------------------------------------------------------------------
-- FUNCTION: getCharacterName( int characterID )
-- Description: Allows you to retrieve a characters' name from the ID attached to the player.
function getCharacterName( characterID )
	if ( characterID ) then
		local q = exports.sql:query_assoc_single("SELECT charactername FROM `characters` WHERE charid = '".. tonumber( characterID ) .."' ")
			if ( q ) then
				return string.gsub( q.charactername, "_", " " )
			else
				return false;
			end
	else
		return MISSING_ARGUMENTS
	end
end

-- FUNCTION: getCharacterID ( string charactername )
-- Description: Retrieve a characters' ID by parsing their name.
function getCharacterID( charactername )
	if ( charactername ) then
		local success, error = exports.sql:query_assoc_single( "SELECT charid FROM `characters` WHERE charactername = '".. tostring( exports.sql:escape_string( charactername ) ) .."'");
		if ( success ) then
			return success.charid
		else
			return false
		end
	else
		return MISSING_ARGUMENTS
	end
end

-- FUNCTION: getCharacterExists( int characterID )
-- Description: Checks if a character with a specific ID exists, if it does, returns true, if ID does not exist, return false.
function getCharacterExists( characterID )
	if ( characterID ) then
		local success, error = exports.sql:query_assoc_single( "SELECT charactername FROM `characters` WHERE charid = '".. tonumber( characterID ) .."'")
		if ( success ) then
			return true
		else
			return false
		end
	else
		return MISSING_ARGUMENTS
	end
end


---------------------------------------------------------------------------



function returnHome(source, commandName)
	setElementDimension(source, tonumber(getElementData(source, "userid"))) -- make the current character disapear
	setupCharacterSelect(source) -- populate the players characters
	triggerClientEvent(source, "characterSelect", source)
	unbindKey(source, "end", "down", "home")
	setElementData(source, "loggedin", false) -- player is no longer logged in
	setElementData(source, "ooc", 0 ) -- no one can talk to the player
	showCursor(source, true)
end

addCommandHandler("home", returnHome)

addEvent("createCharacter", true)
addEventHandler("createCharacter", _root, createCharacter)

addEvent("onClientWantLogin", true)
addEventHandler("onClientWantLogin", _root, attemptLogin)

addEvent("removeCharacterPeds", true)
addEventHandler("removeCharacterPeds", _root, removePed)

addEvent("onClientRegister", true)
addEventHandler("onClientRegister", _root, attemptRegister)

addEvent("onCharacterSpawn", true)
addEventHandler("onCharacterSpawn", _root, playerSpawn)

addEventHandler("onPlayerJoin", _root, _joinConstruct)
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), _construct)
addEventHandler("onPlayerQuit", _root, _playerQuit)