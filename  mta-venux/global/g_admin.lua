--[[
--    <<< VENUX _ SWIFT >>>
--      DEV: AeroXbird
--]]

local titles = { "Trial Moderator", "Moderator", "Administrator", "Super Administrator", "Head Administrator", "Owner", "Scripter" }

function getPlayerAdminLevel( thePlayer )
	return tonumber( getElementData( thePlayer, "adminrank" ) ) or 0
end

function getPlayerAdminTitle(thePlayer)
	local text = titles[getPlayerAdminLevel(thePlayer)] or "Player"

	return text
end

function isPlayerTrial( thePlayer )
	return getPlayerAdminLevel(thePlayer) >= 1
end

function isPlayerMod( thePlayer )
	return getPlayerAdminLevel(thePlayer) >= 2
end

function isPlayerAdmin( thePlayer )
	return getPlayerAdminLevel(thePlayer) >= 3
end

function isPlayerSuperAdmin( thePlayer )
	return getPlayerAdminLevel(thePlayer) >= 4
end

function isPlayerHeadAdmin( thePlayer )
	return getPlayerAdminLevel(thePlayer) >= 5
end

function isPlayerOwner( thePlayer )
	return getPlayerAdminLevel(thePlayer) >= 6
end

function isPlayerDeveloper( thePlayer )
	return getPlayerAdminLevel(thePlayer) >= 7
end