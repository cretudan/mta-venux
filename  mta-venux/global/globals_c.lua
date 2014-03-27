--[[
--    <<< VENUX _ SWIFT >>>
--      DEV: AeroXbird
--]]

local BUILD = "1.0 'Swift'"

-- special thanks to mabako.
addEventHandler( "onClientResourceStart", resourceRoot,
	function( )
		local screenX, screenY = guiGetScreenSize( )
		local label = guiCreateLabel( 0, 0, screenX, 15, "MTA-Venux " .. getVersion( ), false )
		guiSetSize( label, guiLabelGetTextExtent( label ) + 5, 14, false )
		guiSetPosition( label, screenX - guiLabelGetTextExtent( label ) - 5, screenY - 27, false )
		guiSetAlpha( label, 0.5 )
	end
)

function getVersion( )
	return tostring( BUILD );
end