-- E2's default table format
local DEFAULT = {n={},ntypes={},s={},stypes={},size=0,istable=true,depth=0}

local P = darkrp_scripting

-- Returns the amount of money a player has
e2function number entity:money()
	return P.money( this )
end

e2function string entity:shipmentContents( )
	return P.shipmentContents( this )
end

e2function number entity:shipmentAmount( )
	return P.shipmentAmount( this )
end

e2function number entity:moneyAmount( )
	return P.moneyAmount( this )
end

e2function array entity:merchandise( )
	return P.merchandise( this )
end