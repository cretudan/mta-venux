--[[
---			|\-/| Roleplay VX Version one |\-/|  ---
---		     Developer: AeroXbird & Lukkaz	     ---
--]]

_root = getRootElement();

local gui = {}
gui._placeHolders = {}

local width, height = guiGetScreenSize()

local windowWidth, windowHeight = 382, 226
local left = width/2 - windowWidth/2
local top = height/2 - windowHeight/2
local lastElement = nil
local firstClick = true
local charNameLabel = nil

local pedX = nil
local pedY = nil
local clickCharname = nil


--creation booleans
valid = false
height = false
weight = false
age = false
name = false



function showDashboard()
	guiSetInputEnabled(true)
	gui["_root"] = guiCreateWindow(left, top, windowWidth, windowHeight, "MainWindow", false)
	guiWindowSetSizable(gui["_root"], false)
	guiSetProperty(gui["_root"], "TitlebarEnabled", "false")
	guiSetAlpha(gui["_root"], 0.65)
	
	gui["label"] = guiCreateLabel(80, 65, 90, 25, "Your username:", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["label"], "left", false)
	guiLabelSetVerticalAlign(gui["label"], "center")
	
	gui["label_2"] = guiCreateLabel(80, 105, 90, 25, "Your password:", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["label_2"], "left", false)
	guiLabelSetVerticalAlign(gui["label_2"], "center")
	
	gui["username"] = guiCreateEdit(180, 65, 113, 20, "", false, gui["_root"])
	guiEditSetMaxLength(gui["username"], 32767)
	
	gui["password"] = guiCreateEdit(180, 105, 113, 20, "", false, gui["_root"])
	guiEditSetMaxLength(gui["password"], 32767)
	guiEditSetMasked(gui["password"], true)
	
	gui["pushButton"] = guiCreateButton(110, 135, 75, 23, "Login", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["pushButton"], on_login_clicked, false)
	
	gui["pushButton_2"] = guiCreateButton(210, 135, 75, 23, "Register", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["pushButton_2"], on_register_clicked, false)

	
	gui._placeHolders["line"] = {left = 190, top = 135, width = 16, height = 31, parent = gui["_root"]}
	
	gui["label_3"] = guiCreateLabel(10, 25, 290, 16, "Welcome to Project VenuX - Version ".. exports.global:getVersion() .."", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["label_3"], "left", false)
	guiLabelSetVerticalAlign(gui["label_3"], "center")

	showCursor(true)
	
	toggleInterfaceComponents(false)
	
	return gui, windowWidth, windowHeight
	
end

-- clicky click.
function characterClick(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
if ( getElementType(clickedElement) ~= nil and getElementType( clickedElement ) == "ped" ) then
	if ( clickedElement == lastElement ) then
		if ( button == "left" and state == "down" and getElementType(clickedElement) ~= "player") then -- because MTA's lua vm still works in mysterious ways, in which case you better be prepared my son.
			if ( firstClick == true ) then
		
				local x, y, z = getElementPosition(clickedElement)
				local sx, sy = getScreenFromWorldPosition ( x, y, z )
				pedX = sx -60
				pedY = sy -75
				clickCharactername =  tostring ( getElementData ( clickedElement, "charName" ) )
				addEventHandler("onClientRender", _root, draw3D )
				lastElement = clickedElement;
				firstClick = false;

			elseif ( firstClick == false ) then -- secondClick
				local characters_real_name = tostring( getElementData( clickedElement, "charName" ) )
				triggerServerEvent("removeCharacterPeds", _root, getLocalPlayer())
				clickStop(false)
				triggerServerEvent("onCharacterSpawn", _root, getLocalPlayer(), characters_real_name, getElementData(clickedElement, "skin"))
			
				-- cleanup
				lastElement = nil
				firstClick = true
				removeEventHandler("onClientRender", _root, draw3D )
			end
		end
	else
		firstClick = true; -- reset value prease
		charNameLabel = nil
			if ( button == "left" and state == "down" and getElementType(clickedElement) ~= "player") then -- because MTA's lua vm still works in mysterious ways, in which case you better be prepared my son.
				if ( firstClick == true ) then

					local x, y, z = getElementPosition(clickedElement)
					local sx, sy = getScreenFromWorldPosition ( x, y, z )
					pedX = sx -60
					pedY = sy -75
					clickCharactername =  tostring ( getElementData ( clickedElement, "charName" ) )
					addEventHandler("onClientRender", _root, draw3D )
					lastElement = clickedElement;
					firstClick = false;

				elseif ( firstClick == false ) then -- secondClick
					local characters_real_name = tostring( getElementData( clickedElement, "charName" ) )
					triggerServerEvent("removeCharacterPeds", _root, getLocalPlayer())
					clickStop(false)
					triggerServerEvent("onCharacterSpawn", _root, getLocalPlayer(), characters_real_name)
				
					-- cleanup
					lastElement = nil
					firstClick = true
					removeEventHandler("onClientRender", _root, draw3D )
				end
			end
		end
	end
end

function draw3D() -- yay for hacky methods.
	dxDrawText( string.gsub( clickCharactername, "_", " "), pedX, pedY, 0, 0, tocolor(0, 0, 0, 255), 1.7)
	dxDrawText( string.gsub( clickCharactername, "_", " "), pedX, pedY - 3, 0, 0, tocolor(255, 255, 255, 255), 1.7) -- shadow
end


function toggleInterfaceComponents(visible) --- let's toggle the hud components so players cant troll
	showPlayerHudComponent("weapon", visible)
	showPlayerHudComponent("ammo", visible)
	showPlayerHudComponent("vehicle_name", visible)
	showPlayerHudComponent("money", visible)
	showPlayerHudComponent("clock", visible)
	showPlayerHudComponent("health", visible)
	showPlayerHudComponent("armour", visible)
	showPlayerHudComponent("breath", visible)
	showPlayerHudComponent("area_name", visible)
	showPlayerHudComponent("radar", visible)
end


function clearChatBox() --- self explanitory
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
end



function on_login_clicked()
		triggerServerEvent("onClientWantLogin", _root, getLocalPlayer(), guiGetText(gui["username"]), guiGetText(gui["password"]) )
end

function on_register_clicked()
	if ( guiGetText(gui["username"]) ~= "" and guiGetText(gui["password"]) ~= "" ) then 
		triggerServerEvent("onClientRegister", _root, getLocalPlayer(), guiGetText(gui["username"]), guiGetText(gui["password"]))
	else
		return outputChatBox("You have not entered a username or password!", 100, 0, 0)
	end
end

function characterSelect()
	setCameraMatrix(783.44, -1287.73, 23.5, 733.9, -1276.6, 13.5)
	showCursor(true)
	clearChatBox()
	createChar_button = guiCreateButton(.4, .05, .2, .08, "Create Character", true)

	addEventHandler("onClientGUIClick", createChar_button, 
		function()
			destroyElement(createChar_button)
			clickStop(false)
			setElementPosition(getLocalPlayer(), 211.31640625,24.6015625,2.57080078125)
			setElementRotation(getLocalPlayer(), 0, 0, -90)
			setCameraMatrix( 213.8203125,24.72265625,2.57080078125, 211.31640625,24.6015625,3.0080078125)
			creationProcess()

			removeEventHandler("onClientRender", _root, charselectInfo)
			removeEventHandler("onClientRender", _root, draw3D )
		end )
	toggleInterfaceComponents(false)
	addEventHandler("onClientRender", _root, charselectInfo)
end

function charselectInfo()
	local width, height = guiGetScreenSize()

	dxDrawText( "To play as a character, click it once to view its name, then click it again to confirm.\n If you have no characters, please select 'Create Character' to get started.", width / 3.38 , height / 1.076, 0, 0, tocolor(0, 0, 0, 255), 1.5)	 -- shadow
	dxDrawText( "To play as a character, click it once to view its name, then click it again to confirm.\n If you have no characters, please select 'Create Character' to get started.", width / 3.4, height / 1.08, 0, 0, tocolor(255, 255, 255, 255), 1.5)
end

gender = 0
curskin = 0
curskinam = 0


Males = {7, 14, 15, 16, 17, 18, 20, 21, 22, 24, 25, 28, 35, 36, 50, 51, 66, 67, 78, 79, 80, 83, 84, 102, 103, 104, 105, 106, 107, 134, 136, 142, 143, 144, 156, 163, 166, 168, 176, 180, 182, 183, 185, 220, 221, 222, 249, 253, 260, 262, 23, 26, 27, 29, 30, 32, 33, 34, 35, 36, 37, 38, 43, 44, 45, 46, 47, 48, 50, 51, 52, 53, 58, 59, 60, 61, 62, 68, 70, 72, 73, 78, 81, 82, 94, 95, 96, 97, 98, 99, 100, 101, 108, 109, 110, 111, 112, 113, 114, 115, 116, 120, 121, 122, 124, 125, 126, 127, 128, 132, 133, 135, 137, 146, 147, 153, 154, 155, 158, 159, 160, 161, 162, 164, 165, 170, 171, 173, 174, 175, 177, 179, 181, 184, 186, 187, 188, 189, 200, 202, 204, 206, 209, 212, 213, 217, 223, 230, 234, 235, 236, 240, 241, 242, 247, 248, 250, 252, 254, 255, 258, 259, 261, 264, 49, 57, 58, 59, 60, 117, 118, 120, 121, 122, 123, 170, 186, 187, 203, 210, 227, 228, 229}
Females = {9, 10, 11, 12, 13, 40, 41, 63, 64, 69, 76, 91, 139, 148, 190, 195, 207, 215, 218, 219, 238, 243, 244, 245, 256, 12, 31, 38, 39, 40, 41, 53, 54, 55, 56, 64, 75, 77, 85, 86, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 140, 145, 150, 151, 152, 157, 172, 178, 192, 193, 194, 196, 197, 198, 199, 201, 205, 211, 214, 216, 224, 225, 226, 231, 232, 233, 237, 243, 246, 251, 257, 263, 38, 53, 54, 55, 56, 88, 141, 169, 178, 224, 225, 226, 263}

function nextSkin()
	local array = nil
	if (gender==0) then
		array = Males
	elseif (gender==1) then 
		array = Females
	end
	
	-- Get the next skin
	if (curskin==#array) then
		curskin = 1
		skin = array[1]
		setElementModel(getLocalPlayer(), tonumber(skin))
	else
		curskin = curskin + 1
		skin = array[curskin]
		setElementModel(getLocalPlayer(), tonumber(skin))
	end
end

function reverseSkin()
	local array = nil
	if (gender==0) then 
		array = Males
	elseif (gender==1) then 
		array = Females
	end
	
	-- Get the next skin
	if (curskin==1) then
		curskin = #array
		skin = array[1]
		setElementModel(getLocalPlayer(), tonumber(skin))
	else
		curskin = curskin - 1
		skin = array[curskin]
		setElementModel(getLocalPlayer(), tonumber(skin))
	end
end

function setMale()
	gender = 0
	generateSkin()
end

function setFemale()
	gender = 1
	generateSkin()
end

function generateSkin()
	if (gender==0) then -- MALE
			curskinam = math.random(1, #Males)
			skin = Males[curskinam]
			setElementModel(getLocalPlayer(), skin)
	elseif (gender==1) then -- FEMALE
			curskinam = math.random(1, #Females)
			skin = Females[curskinam]
			setElementModel(getLocalPlayer(), skin)
	end
	curskin = skin
end


function creationProcess()
	creationWin = {} -- I prefer to make guis with tables, that way you can later on build more gui elements in the same function. Neatens your work up a bit.
	creationButton = {}
	creationLabel = {}
	creationEdit = {}
	creationRadio = {}

	creationWin[1] = guiCreateWindow(84,154,296,448,"Character Creation",false)
	creationEdit[1] = guiCreateEdit(111,54,122,22,"",false,creationWin[1]) --name
	creationLabel[1] = guiCreateLabel(68,55,38,20,"Name:",false,creationWin[1])
	creationLabel[2] = guiCreateLabel(77,91,29,20,"Age:",false,creationWin[1])
	creationEdit[2] = guiCreateEdit(112,89,37,22,"",false,creationWin[1])
	creationLabel[3] = guiCreateLabel(60,123,44,20,"Weight:",false,creationWin[1])
	creationEdit[3] = guiCreateEdit(112,120,37,22,"",false,creationWin[1])
	creationLabel[4] = guiCreateLabel(60,153,44,20,"Height:",false,creationWin[1])
	creationEdit[4] = guiCreateEdit(112,149,37,22,"",false,creationWin[1])
	creationButton[1] = guiCreateButton(147,413,112,26,"Cancel",false,creationWin[1])
	creationButton[3] = guiCreateButton(31,414,106,25,"Create!",false,creationWin[1])
	creationLabel[5] = guiCreateLabel(117,198,62,22,"Select Skin",false,creationWin[1])

	creationButton[4] = guiCreateButton(191,238,66,39,"-->",false,creationWin[1])
	addEventHandler("onClientGUIClick", creationButton[4], nextSkin, true)

	creationButton[5] = guiCreateButton(35,238,66,39,"<--",false,creationWin[1])
	addEventHandler("onClientGUIClick", creationButton[5], reverseSkin, false)

	creationLabel[6] = guiCreateLabel(122,297,41,17,"Gender",false,creationWin[1])
	creationRadio[1] = guiCreateRadioButton(65,328,47,19,"Male",false,creationWin[1])
	guiRadioButtonSetSelected(creationRadio[1],true)
	addEventHandler("onClientGUIClick", creationRadio[1], setMale)
	creationRadio[2] = guiCreateRadioButton(167,328,61,19,"Female",false,creationWin[1])
	addEventHandler("onClientGUIClick", creationRadio[2], setFemale)
	addEventHandler("onClientGUIClick", creationButton[1], function() destroyElement(creationWin[1]) characterSelect() clickStop(true) end, false)
	addEventHandler("onClientGUIClick", creationButton[3], function()
		checkInputInfo( guiGetText( creationEdit[1] ), guiGetText( creationEdit[3] ), guiGetText( creationEdit[4] ), getElementModel( getLocalPlayer() ), guiGetText( creationEdit[2] ), gender )
		clickStop(true) 
		end, false)
		
	generateSkin()
end


--name, weight, height, skin, age, gender
function checkInputInfo(charName, charweight, charheight, skin, charage, gender)
	local skin = tonumber(skin)
	local gender = tonumber(gender)
	local theText = tostring(charName)

		local foundSpace,name = false,true
		local lastChar, current = ' ', ''
		for i = 1, #theText do
			local char = theText:sub( i, i )
			if char == '_' then -- it's a space
				if i == #theText then -- space at the end of name is not allowed
					name = false
					break
				else
					foundSpace = true -- we have at least two name parts
				end
				if #current < 2 then -- check if name's part is at least 2 chars
					name = false
					break
				end
				current = ''
			elseif lastChar == ' ' then -- this char follows a space, we need a capital letter
				if char < 'A' or char > 'Z' then
					name = false
					break
				end
				current = current .. char
			elseif ( char >= 'a' and char <= 'z' ) or ( char >= 'A' and char <= 'Z' ) then -- can have letters anywhere in the name
				current = current .. char
			else -- unrecognized char (numbers, special chars)
				name = false
				break
			end
		end
		-- check the age.
		if (tonumber(charage) >= 18) and (tonumber(charage) <= 100) then
			age = true
		else
			guiLabelSetColor(creationLabel[2], 255, 0, 0)
			outputChatBox("Please enter a valid age (18-100)", 255,0,0)
		end

		-- check their weight.
		if tonumber(charweight) >= 80 and tonumber(charweight) <= 300 then
			weight = true
		else
			guiLabelSetColor(creationLabel[3], 255, 0, 0)
			outputChatBox("Please enter a valid weight (80-300)", 255,0,0)
		end
		
		-- check their height.
		if tonumber(charheight) >= 45 and tonumber(charheight) <= 70 then
			height = true
		else
			guiLabelSetColor(creationLabel[4], 255, 0, 0)
			outputChatBox("Please enter a valid height (45-70)", 255,0,0)
		end

		-- check if all values passed.
		if ( age == true and height == true and weight == true ) then 
			triggerServerEvent("createCharacter", getLocalPlayer(), charName, charweight, charheight, skin, charage, gender)
			destroyElement(creationWin[1])
			characterSelect() 
			triggerServerEvent("reloadPeds", getLocalPlayer(), getLocalPlayer()) 
		else
			outputDebugString("Something went wrong with parsing a characters info.", 3 )
		end
end


function toggleDashboard(state)
	if ( state == 1 ) then
		guiSetInputEnabled(true)
		showCursor(true)
		showDashboard();
	elseif( state == 0 ) then
		guiSetVisible(gui["_root"], false)
		gui = {}
		guiSetInputEnabled(false)
	end
end


function _playerJoin()
	if ( getElementData(source, "loggedin") == false ) then
		toggleDashboard(1);
	else
		return nil -- not supposed to happen anyway..
	end
end

function clean_up() -- Clean up your code. -mom
	destroyElement(createChar_button)
	toggleInterfaceComponents(true)
	showChat(true)
	showCursor(false)
	removeEventHandler("onClientRender", _root, charselectInfo)
end


-- for us dirty workaround people, we thought of you too sweethearts.
function clickStop(picking)
	if ( picking == true ) then
		addEventHandler("onClientClick", _root, characterClick)
	else
		removeEventHandler("onClientClick", _root, characterClick)
	end
end

addEvent("pickAped", true)
addEventHandler("pickAped", _root, clickStop)

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), _playerJoin)

addEvent("clean_up", true)
addEventHandler("clean_up", _root, clean_up)

addEvent("characterSelect", true)
addEventHandler("characterSelect", _root, characterSelect)

addEvent("toggleDashboard", true)
addEventHandler("toggleDashboard", _root, toggleDashboard)