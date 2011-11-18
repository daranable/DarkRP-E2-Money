
-- The libraries global table
darkrp_scripting = { }

-- Money Functions

--- Returns the amount of money a player entity has
--@param person the player entity that you want to check the money of
--@return number the amount of money that person has
function darkrp_scripting.money( person )
	if ( !validEntity(person) or person:GetClass() != "player" ) then return -1 end
	
	return person.DarkRPVars.money
end

--- Returns the conents of a shipment entity
--@param shipment the entity of the shipment your checking
--@return string returns the name of the type of gun in it
function darkrp_scripting.shipmentContents( shipment )
	if ( !validEntity(shipment) or shipment:GetClass() != "spawned_shipment" ) then return "" end
	
	return CustomShipments[shipment.dt.contents]["name"]
end

--- Returns the number of guns left in a given shipment
--@param shipment the entity of the shipment your checking
--@return number returns the number of guns in the shipment
function darkrp_scripting.shipmentAmount( shipment )
	if ( !validEntity(shipment) or shipment:GetClass() != "spawned_shipment" ) then return -1 end
	
	return shipment.dt.count
end

--- Returns the amount of money in a spawned money entity
--@param money then entity of the money piece
--@return number returns the amount of money
function darkrp_scripting.moneyAmount( money )
	if ( !validEntity( money ) or money:GetClass() != "spawned_money" ) then return -1 end
	
	return money.Amount
end