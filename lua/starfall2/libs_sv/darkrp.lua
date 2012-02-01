local darkrp_lib, _ = SF.Libraries.Register("darkrp")

local unwrap, wrap = SF.Entities.Unwrap, SF.Entities.Wrap
local P = darkrp_scripting

function darkrp_lib.money( person )
	return P.money( unwrap( person ) )
end

function darkrp_lib.shipmentContents( shipment )
	return P.shipmentContents( unwrap( shipment ) )
end

function darkrp_lib.shipmentAmount( shipment )
	return P.shipmentAmount( unwrap( shipment ) )
end

function darkrp_lib.moneyAmount( money )
	return P.moneyAmount( unwrap( money ) )
end

function darkrp_lib.merchandise( person )
	return P.merchandise( unwrap( person ) )
end

function darkrp_lib.guninfo( name )
	return P.guninfo( name )
end

function darkrp_lib.buyShipment( name, pos, ang )
	SF.CheckType( name, "string" )
	SF.CheckType( pos, "Vector" )
	SF.CheckType( ang, "Angle" )
	
	local ret, err = P.buyShipment( SF.instance.player, name, pos, ang )
	
	if type( ret ) == "Entity" then
		return wrap ( ret )
	end
	
	return nil, err
end

function darkrp_lib.buyGun( name, pos )
	SF.CheckType( name, "string" )
	SF.CheckType( pos, "Vector" )
	
	local ret, err = P.buyGun( SF.instance.player, name, pos )
	
	if type( ret ) == "Entity" then
		return wrap ( ret )
	end
	
	return nil, err
end

function darkrp_lib.extractGun( shipment, pos )
	--SF.CheckType( shipment, "Entity" )
	SF.CheckType( pos, "Vector" )
	
	
	return P.extractGun( SF.instance.player, unwrap( shipment ), pos )
end