
-- The libraries global table
darkrp_scripting = { }

local P = darkrp_scripting
-- Money Functions

--- Returns the amount of money a player entity has
-- @param person the player entity that you want to check the money of
-- @return number the amount of money that person has
function P.money( person )
	if ( !validEntity(person) or person:GetClass() != "player" ) then return -1 end
	
	return person.DarkRPVars.money
end

--- Returns the conents of a shipment entity
-- @param shipment the entity of the shipment your checking
-- @return string returns the name of the type of gun in it
function P.shipmentContents( shipment )
	if ( !validEntity(shipment) or shipment:GetClass() != "spawned_shipment" ) then return "" end
	
	return CustomShipments[shipment.dt.contents]["name"]
end

--- Returns the number of guns left in a given shipment
-- @param shipment the entity of the shipment your checking
-- @return number returns the number of guns in the shipment
function P.shipmentAmount( shipment )
	if ( !validEntity(shipment) or shipment:GetClass() != "spawned_shipment" ) then return -1 end
	
	return shipment.dt.count
end

--- Returns the amount of money in a spawned money entity
-- @param money then entity of the money piece
-- @return number returns the amount of money
function P.moneyAmount( money )
	if ( !validEntity( money ) or money:GetClass() != "spawned_money" ) then return -1 end
	
	return money.Amount
end

--- Returns a table containing all things the player can buy.
-- @param person the entity of the player requesting the table
-- @return table containing a number indexed list of the names of the guns a 
--         player can buy.
function P.merchandise( person )
	if ( !validEntity( person ) or person:GetClass() != "player" ) then return end
	
	local player_team = person:Team()
	local guns = { }
	
	for key,value in pairs(CustomShipments) do
		local allowed
		for _,id in pairs( value["allowed"] ) do
			if id == player_team then
				allowed = true
			end
		end
		
		if allowed then
			guns[ #guns + 1 ] = value["name"]
		end
	end
	
	return guns
end

--- Returns a table contating information about an item.
-- @param name the name of the item that data will be returned about.
-- @returns a table containing following data:
--          shipment  = True/False  (Whether the player can buy a shipment of the gun)
--          single    = True/False  (Whether the player can buy a single of the gun)
--          count     = Number      (How many guns come in the shipment)
--          shipprice = Number      (How much a shipment costs if applicable)
--          price     = Number      (Cost of a single gun if applicable)
--          model     = String      (Model of the item)
function P.guninfo( name )
	local info = { }
	
	local gun = getGunTable( name )
	
	info["shipment"]  = ~gun["noship"]
	info["single"]    =  gun["seperate"]
	info["count"]     =  gun["amount"]
	info["shipprice"] =  gun["price"]
	info["price"]     =  gun["pricesep"]
	info["model"]     =  gun["model"]
	
	return info
end

--- Allows a player to buy a shipment
-- @param name the name of the gun they want to buy.
-- @param 



------------------------------------------------------------------------
-- Internal functions                                                 --
------------------------------------------------------------------------
--- Takes the name of a gun and returns it's table
-- @param name of the gun that you want the table of
-- @returns the guns customshipment table
local function getGunTable( name )
	local ret
	
	for key,value in pairs(CustomShipments) do
		if name = value["name"] then
			ret = value
			break
		end
	end
	
	return ret
end