--[[
---			|\-/| Roleplay VX Version one |\-/|  ---
---		     Developer: AeroXbird & Lukkaz	     ---
--]]

_root = getRootElement()

local sx, sy = guiGetScreenSize()
local interiors = {}

function prepareInfoHUD( interior )
	if ( type( interior ) == "table" ) then
		interiors = interior
		addEventHandler("onClientRender", _root, renderInfoHUD)
	else
		removeEventHandler("onClientRender", _root, renderInfoHUD)
	end
end


function renderInfoHUD()
	if ( type( interiors ) == "table" ) then 
		dxDrawRectangle( 0.3 * sx, 0.780 * sy, 0.250 * sx, 0.200 * sy, tocolor( 0, 0, 0, 200) )
		dxDrawText( interiors.name, 0.310 * sx, 0.790 * sy, 0, 0, tocolor( 255, 255, 255, 255 ), 1.5 )
		dxDrawLine(  0.308 * sx, 0.810 * sy, 0.550 * sx, 0.810 * sy, tocolor( 255, 255, 255, 255 ) )

		if ( interiors.rented == 0 and interiors.owner ~= 0 ) then
			dxDrawText( "This property is owned by: ".. string.gsub(interiors.owner, "_", " "), 0.310 * sx, 0.820 * sy, 0, 0, tocolor( 255, 255, 255, 255 ), 1.2 )
		elseif( interiors.rented == 1 ) then
			dxDrawText( "This property is currently being rented by: ".. string.gsub(interiors.renter, "_", " "), 0.310 * sx, 0.820 * sy, 0, 0, tocolor( 255, 255, 255, 255 ), 1.2 )
		else
			dxDrawText( "This property is owned by: Nobody ", 0.310 * sx, 0.820 * sy, 0, 0, tocolor( 255, 255, 255, 255 ), 1.2 )
		end

		dxDrawText( "The current market value of this property is: $".. interiors.cost .. ".", 0.310 * sx, 0.840 * sy, 0, 0, tocolor( 255, 255, 255, 255 ), 1.2 )
		
		if ( interiors.type == 1 ) then
			dxDrawText( "This property is a Civilian Home.", 0.310 * sx, 0.860 * sy, 0, 0, tocolor( 255, 255, 255, 255 ), 1.2 )
		elseif ( interiors.type == 2 ) then
			dxDrawText( "This property is a Private Business.", 0.310 * sx, 0.860 * sy, 0, 0, tocolor( 255, 255, 255, 255 ), 1.2 )
		elseif ( interiors.type == 3 ) then
			dxDrawText( "This property is a Government Building.", 0.310 * sx, 0.860 * sy, 0, 0, tocolor( 255, 255, 255, 255 ), 1.2 )
		end
			
		if ( interiors.owner == 0 ) then
			dxDrawText( "This property is currently for sale, the current price is \n a sum of $".. interiors.cost .." to buy it.", 0.310 * sx, 0.880 * sy, 0, 0, tocolor( 200, 0, 0, 255 ), 1.2 )
			dxDrawText( "Press (F) to enter/leave this property.", 0.310 * sx, 0.940 * sy, 0, 0, tocolor(255, 255, 255, 255), 1.4)
		else
			dxDrawText( "Press (F) to purchase this property.", 0.310 * sx, 0.940 * sy, 0, 0, tocolor(255, 255, 255, 255), 1.4)
		end
	end

end

addEvent("prepInfoHUD", true)
addEventHandler("prepInfoHUD", _root, prepareInfoHUD)