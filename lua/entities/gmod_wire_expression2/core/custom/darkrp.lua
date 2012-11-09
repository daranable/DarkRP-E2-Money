------------------------------------------------------------------------
-- Internals                                                          --
------------------------------------------------------------------------
-- E2's default table format
local DEFAULT = {n={},ntypes={},s={},stypes={},size=0,istable=true,depth=0}

-- Save global table to a shorter local variable
local P = darkrp_scripting


--- Takes a standard table and converts it to a usable e2 table
-- @param table the lua table you want to convert
-- @returns the converted table usable in e2
local function convertTable( entry )
	local ret = table.Copy( DEFAULT )
	
	for key, value in pairs( entry ) do
		local new
		local valtype
		if type( value ) == "table" then
			new = convertTable( value )
			valtype = "t"
		elseif type ( value ) == "boolean" then
			if value == true then
				new = 1
				valtype = "n"
			else
				new = 0
				valtype = "n"
			end
		elseif type( value ) == "number" then
			new = value
			valtype = "n"
		elseif type( value ) == "string" then
			new = value
			valtype = "s"
		end
		
		if type( key ) == "string" then
			ret.s[key] = new
			ret.stypes[key] = valtype
		elseif type( key ) == "number" then
			ret.n[key] = new
			ret.ntypes[key] = valtype
		end
	end
	
	return ret
end


------------------------------------------------------------------------
-- Library Functions                                                  --
------------------------------------------------------------------------

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

e2function table guninfo( string name )
	local guninfo = P.guninfo( name )
	
	local ret = convertTable( guninfo )
	
	return ret
end

e2function entity buyShipment( string name, vector pos )
	local shipment, err = P.buyShipment( self.entity.player, name, Vector( pos[ 1 ], pos[ 2 ], pos[ 3 ] ) )
	
	if err then 
		error( err )
	end
	
	return shipment
end

e2function entity buyGun( string name, vector pos )
	local gun, err = P.buyGun( self.entity.player, name, Vector( pos[ 1 ], pos[ 2 ], pos[ 3 ] ) )
	
	if err then
		error( err )
	end
	
	return gun
end

e2function entity entity:extractGun( vector pos )
	local gun, err = P.extractGun( self.entity.player, this, Vector( pos[ 1 ], pos[ 2 ], pos[ 3 ] ) )
	
	if err then
		error( err )
	end
	
	return gun
end

e2function void entity:giveMoney( number amount )
	local success, err = P.giveMoney( self.entity.player, this,amount )
	
	if err then
		error( err )
	end
end

local function money_response() 
	
end

e2function string entity:askForMoney( number amount )
	local _, err = P.askForMoney( self.entity, self.entity.player, this, 
			amount, money_response )
	
	if err then
		return err
	end	
	return ""
end