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