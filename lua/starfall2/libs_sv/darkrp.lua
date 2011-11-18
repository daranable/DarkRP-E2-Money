local darkrp_lib = {}

SF.Libraries.Register("darkrp",darkrp_lib)

local unwrap, wrap = SF.Entities.Unwrap, SF.Entities.Wrap

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