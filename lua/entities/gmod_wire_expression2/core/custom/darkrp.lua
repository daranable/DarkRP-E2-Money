-- E2's default table format
local DEFAULT = {n={},ntypes={},s={},stypes={},size=0,istable=true,depth=0}

-- Returns the amount of money a player has
e2function number entity:money()
	return darkrp_scripting.money( this )
end

e2function string entity:shipmentContents( )
	return darkrp_scripting.shipmentContents( this )
end

e2function number entity:shipmentAmount( )
	return darkrp_scripting.shipmentAmount( this )
end

e2function number entity:moneyAmount( )
	return darkrp_scripting.moneyAmount( this )
end

e2function array entity:merchandise( )
	return darkrp_scripting.merchandise( this )
end

e2function table guninfo( string name )
	
end