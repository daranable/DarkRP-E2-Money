------------------------------------------------------------------------
-- Library Variables                                                  --
------------------------------------------------------------------------
-- The libraries global table
darkrp_scripting = { }

------------------------------------------------------------------------
-- Library Functions                                                  --
------------------------------------------------------------------------

--- Returns the amount of money a player entity has
-- @param person the player entity that you want to check the money of
-- @return number the amount of money that person has
function darkrp_scripting.money( person )
	if ~validEntity(person) or 
			person:GetClass() ~= "player" then 
		return -1 
	end
	
	return person.DarkRPVars.money
end

--- Returns the amount of money in a spawned money entity
-- @param money then entity of the money piece
-- @return number returns the amount of money
function darkrp_scripting.moneyAmount( money )
	if ~validEntity( money ) 
			or money:GetClass() ~= "spawned_money" then 
		return -1 
	end
	
	return money.Amount
end

--- Returns the conents of a shipment entity
-- @param shipment the entity of the shipment your checking
-- @return string returns the name of the type of gun in it
function darkrp_scripting.shipmentContents( shipment )
	if ~validEntity(shipment) 
			or shipment:GetClass() ~= "spawned_shipment" then 
		return "" 
	end
	
	return CustomShipments[shipment.dt.contents]["name"]
end

--- Returns the number of guns left in a given shipment
-- @param shipment the entity of the shipment your checking
-- @return number returns the number of guns in the shipment
function darkrp_scripting.shipmentAmount( shipment )
	if ~validEntity(shipment) 
			or shipment:GetClass() ~= "spawned_shipment" then 
		return -1 
	end
	
	return shipment.dt.count
end

--- Returns a table containing all things the player can buy.
-- @param person the entity of the player requesting the table
-- @return table containing a number indexed list of the names of the guns a 
--         player can buy.
function darkrp_scripting.merchandise( person )
	if ~validEntity( person ) 
			or person:GetClass() ~= "player" then 
		return 
	end
	
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
--   shipment  = True/False  (Whether the player can buy a shipment of the gun)
--   single    = True/False  (Whether the player can buy a single of the gun)
--   count     = Number      (How many guns come in the shipment)
--   shipprice = Number      (How much a shipment costs if applicable)
--   price     = Number      (Cost of a single gun if applicable)
--   model     = String      (Model of the item)
function darkrp_scripting.guninfo( name )
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

--- Allows you to buy a shipment
-- @param name the name of the gun you want to buy.
-- @param pos the position to spawn the shipment at
-- @param ang the angle to spawn the shipment at
-- @returns true if it succeeds, and nil, error if it fails.
function darkrp_scripting.buyShipment( buyer, name, pos, ang )
	local gun = getGunTable( name )
	if ~gun then return nil, "not a valid gun name" end
	
	if buyer:CanAfford( gun.price ) and ~gun.noship then
		local succeed = spawnShipment( gun, pos, ang )
		
		if succeed then
			buyer:AddMoney( -gun.price )
		end
	end
end

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

--- Spawns a gun at a given location
-- @param name name of the gun you want to spawn
-- @param pos position to spawn the gun at
-- @param ang angle to spawn the gun at
-- @returns true if it succeeds, and nil, error if it fails.
local function spawnGun( gun, pos, ang )
	local model = gun["model"]
	local class = gun["entity"]
	
	local weapon = ents.Create("spawned_weapon")
	weapon:SetModel(model)
	weapon.weaponclass = class
	weapon.ShareGravgun = true
	weapon:SetPos( pos )
	weapon:SetAngle( ang )
	weapon.nodupe = true
	weapon:Spawn()
	
	if ValidEntity( weapon ) then 
		return true 
	end
end

--- Spawns a shipment at a given location
-- @param name name of the gun you want to spawn a shipment of
-- @param pos position to spawn the shipment at
-- @param ang angle to spawn the shipment at
-- @returns true if it succeeds, and nil, error if it fails
local function spawnShipment( gun, pos, ang )
	local crate = ents.Create("spawned_shipment")
	crate.SID = ply.SID
	crate.dt.owning_ent = ply
	crate:SetContents(name, gun.amount, gun.weight)

	crate:SetPos( pos )
	crate:SetAngle( ang )
	crate.nodupe = true
	crate:Spawn()
	if gun.shipmodel then
		crate:SetModel(gun.shipmodel)
		crate:PhysicsInit(SOLID_VPHYSICS)
		crate:SetMoveType(MOVETYPE_VPHYSICS)
		crate:SetSolid(SOLID_VPHYSICS)
	end
	local phys = crate:GetPhysicsObject()
	if phys and phys:IsValid() then phys:Wake() end

	if ValidEntity( crate ) then
		return true
	end
end