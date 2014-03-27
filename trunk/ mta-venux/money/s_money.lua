--[[
--    <<< VENUX _ SWIFT >>>
--      DEV: AeroXbird
--]]

_root = getRootElement()

function giveMoney(thePlayer, amount)
	if ( type( tonumber(amount) ) == "number" and getElementType( thePlayer ) == "player" ) then
		if ( amount == 0 ) then
			return true
		elseif ( thePlayer and isElement(thePlayer) and tonumber(amount) > 0 ) then
				amount = math.floor( tonumber(amount) )
		
				setElementData(thePlayer, "money", getMoney( thePlayer ) + amount )
				local result, error = exports.sql:query_free("UPDATE `characters` SET `cash` = cash + " .. amount .. " WHERE charid = '" .. getElementData( thePlayer, "characterID" ) .."'" )
				if ( result ) then
					givePlayerMoney( thePlayer, amount )
				else
					return outputDebugString( error )
				end
			return true
		end
		return false
	else
		return outputDebugString("MISSING_ARGUMENTS")
	end
end

function takeMoney(thePlayer, amount, rest)
	amount = tonumber( amount ) or 0
	if amount == 0 then
		return true, 0
	elseif thePlayer and isElement(thePlayer) and amount > 0 then
		amount = math.ceil( amount )
		
		local money = getMoney( thePlayer )
		if rest and amount > money then
			amount = money
		end
		
		if amount == 0 then
			return true, 0
		elseif hasMoney(thePlayer, amount) then
			setElementData(thePlayer, "money", money - amount )
			if getElementType(thePlayer) == "player" then
				exports.sql:query_free("UPDATE `characters` SET `cash` = cash - " .. amount .. " WHERE charid = '" .. getElementData( thePlayer, "characterID" ) .."' " )
				takePlayerMoney( thePlayer, amount )
			return true, amount
			end
		end
	return false, 0
	end
end

function setMoney(thePlayer, amount)
	amount = tonumber( amount ) or 0
	if thePlayer and isElement(thePlayer) and amount >= 0 then
		amount = math.floor( amount )
		
		setElementData(thePlayer, "money", amount )
		if getElementType(thePlayer) == "player" then
			exports.sql:query_free("UPDATE characters SET money = " .. amount .. " WHERE charid = " .. getElementData( thePlayer, "dbid" ) )
			setPlayerMoney( thePlayer, amount )
		elseif getElementType(thePlayer) == "team" then
			exports.sql:query_free("UPDATE factions SET bankbalance = " .. amount .. " WHERE charid = " .. getElementData( thePlayer, "id" ) )
		end
		return true
	end
	return false
end

function hasMoney(thePlayer, amount)
	amount = tonumber( amount ) or 0
	if thePlayer and isElement(thePlayer) and amount >= 0 then
		amount = math.floor( amount )
		
		return getMoney(thePlayer) >= amount
	end
	return false
end

function getMoney(thePlayer, nocheck)
	if not nocheck then
		checkMoneyHacks(thePlayer)
	end
	return getElementData(thePlayer, "money") or 0
end

function checkMoneyHacks(thePlayer)
	if not getMoney(thePlayer, true) or getElementType(thePlayer) ~= "player" then return end
	
	local safemoney = getMoney(thePlayer, true)
	local hackmoney = getPlayerMoney(thePlayer)

	if (safemoney~=hackmoney) then
		--banPlayer(thePlayer, getRootElement(), "Money Hacks: " .. hackmoney .. "$.")
		setPlayerMoney(thePlayer, safemoney)
		--sendMessageToAdmins("Possible money hack detected: "..getPlayerName(thePlayer))
		return true
	else
		return false
	end
end