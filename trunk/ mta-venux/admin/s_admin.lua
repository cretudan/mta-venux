--[[
---			|\-/| Roleplay VX Version one |\-/|  ---
---		        Developer: AeroXbird 		     ---
--]]

_root = getRootElement()

function giveMoney(thePlayer, commandName, target, money)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Money]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				exports.money:giveMoney(targetPlayer, money)
				outputChatBox("You have given " .. targetPlayerName .. " $" .. money .. ".", thePlayer)
				outputChatBox("Admin " .. username .. " has given you $" .. money .. ".", targetPlayer)
			end
		end
	end
end
addCommandHandler("givemoney", giveMoney, false, false)

function adminDuty( thePlayer, commandName )
	if ( exports.global:isPlayerTrial( thePlayer ) and getElementData( thePlayer, "adminduty" ) == 0 ) then
		setElementData( thePlayer, "adminduty", 1 )
		setPlayerNametagColor(thePlayer, 255, 194, 14)
		exports.sql:query_free("UPDATE `accounts` SET adminduty=1 WHERE id=".. getElementData( thePlayer, "accountid") .."");
		outputChatBox("You're now on duty!", thePlayer, 0, 190, 0 )
	elseif ( exports.global:isPlayerTrial( thePlayer ) and getElementData( thePlayer, "adminduty" ) == 1 ) then
		setElementData( thePlayer, "adminduty", 0 )
		setPlayerNametagColor(thePlayer, 255, 255, 255)
		exports.sql:query_free("UPDATE `accounts` SET adminduty=0 WHERE id=".. getElementData( thePlayer, "accountid") .."");
		outputChatBox("You're now off duty!", thePlayer, 190, 0, 0 )
	end
end
addCommandHandler("adminduty", adminDuty)