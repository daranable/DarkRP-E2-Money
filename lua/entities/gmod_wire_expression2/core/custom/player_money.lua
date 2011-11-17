__e2setcost(2)

e2function number entity:money()
	if ( !validEntity(this) or this:GetClass() != "player" ) then return -1 end
	
	return this.DarkRPVars.money
end
