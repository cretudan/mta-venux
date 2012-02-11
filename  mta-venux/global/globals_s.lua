--[[
---			|\-/| Roleplay VX Version one |\-/|  ---
---		        Developer: AeroXbird 		     ---
--]]

local BUILD = "1.0 'Swift'"
local fpscap = 60 -- 60 fps vSync limit.

addEventHandler("onResourceStart", getResourceRootElement( getThisResource() ), 
function()

	setGameType("MTA-VenuX RP")
	setRuleValue( "author", "AeroXbird" )
	setRuleValue( "version", getVersion() )
	setMapName( "Los Santos" )
	setFPSLimit( fpscap )
	
	setTimer(
		function()
			outputServerLog( "||_________________________________||" )
			outputServerLog( "||                                 ||" )
			outputServerLog( "||          < MTA VENUX >          ||" )
			outputServerLog( "||          ______________         ||" )
			outputServerLog( "||          Codename SWIFT         ||" )
			outputServerLog( "||_________________________________||" )
		end, 150, 1)
end)


function getVersion( )
	return tostring( BUILD );
end

function getFPSCap( )
	return fpscap
end