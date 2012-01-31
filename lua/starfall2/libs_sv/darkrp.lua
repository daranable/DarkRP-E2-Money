local darkrp_lib, _ = SF.Libraries.Register("darkrp")

local unwrap, wrap = SF.Entities.Unwrap, SF.Entities.Wrap
local P = darkrp_scripting

function darkrp_lib.money( person )
	return darkrp_scripting.money( unwrap( person ) )
end

function darkrp_lib.shipmentContents( shipment )
	return darkrp_scripting.shipmentContents( unwrap( shipment ) )
end

function darkrp_lib.shipmentAmount( shipment )
	return darkrp_scripting.shipmentAmount( unwrap( shipment ) )
end

function darkrp_lib.moneyAmount( money )
	return darkrp_scripting.moneyAmount( unwrap( money ) )
end

function darkrp_lib.merchandise( person )
	return darkrp_scripting.merchandise( unwrap( person ) )
end

function darkrp_lib.guninfo( name )
	return darkrp_scripting.guninfo( name )
end

function darkrp_lib.buyShipment( name, pos, ang )
	SF.CheckType( name, "string" )
	SF.CheckType( pos, "Vector" )
	SF.CheckType( ang, "Angle" )
	
	return darkrp_scripting.buyShipment( SF.instance.player, name, pos, ang )
end