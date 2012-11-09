------------------------------------------------------------------------
-- Library Variables                                                  --
------------------------------------------------------------------------
-- The libraries global table
darkrp_scripting = { }

local P = darkrp_scripting

local ask_limits = { }
local requests = { }

------------------------------------------------------------------------
-- Internal functions                                                 --
------------------------------------------------------------------------
--- Takes the name of a gun and returns it's table
-- @param name of the gun that you want the table of
-- @returns the guns customshipment table
local function getGunTable( name )
	local idx, ret
	
	for key,value in pairs(CustomShipments) do
		if name == value["name"] then
			idx = key
			ret = value
			break
		end
	end
	
	return idx, ret
end

--- Spawns a gun at a given location
-- @param name name of the gun you want to spawn
-- @param pos position to spawn the gun at
-- @param ang angle to spawn the gun at
-- @returns entity if it succeeds, and nil, error if it fails.
local function spawnGun( gun, pos )
	local model = gun["model"]
	local class = gun["entity"]
	
	local weapon = ents.Create("spawned_weapon")
	weapon:SetModel(model)
	weapon.weaponclass = class
	weapon.ShareGravgun = true
	weapon:SetPos( pos )
	weapon.nodupe = true
	weapon:Spawn()
	
	if IsValid( weapon ) then 
		return weapon
	end
end

--- Spawns a shipment at a given location
-- @param name name of the gun you want to spawn a shipment of
-- @param pos position to spawn the shipment at
-- @param ang angle to spawn the shipment at
-- @returns entity if it succeeds, and nil, error if it fails
local function spawnShipment( ply, gun, pos, ang, idx )
	local crate = ents.Create("spawned_shipment")
	crate.SID = ply.SID
	crate.dt.owning_ent = ply
	crate:SetContents(idx, gun.amount, gun.weight)

	crate:SetPos( pos )
	--crate:SetAngle( ang )
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

	if IsValid( crate ) then
		return crate
	end
end


------------------------------------------------------------------------
-- Library Functions                                                  --
------------------------------------------------------------------------

--- Returns the amount of money a player entity has
-- @param person the player entity that you want to check the money of
-- @return number the amount of money that person has
function P.money( person )
	if not IsValid(person) or 
			person:GetClass() ~= "player" then 
		return -1 
	end
	
	return person.DarkRPVars.money
end

--- Returns the amount of money in a spawned money entity
-- @param money then entity of the money piece
-- @return number returns the amount of money
function P.moneyAmount( money )
	if not IsValid( money ) 
			or money:GetClass() ~= "spawned_money" then 
		return -1 
	end
	
	return money.Amount
end

--- Returns the conents of a shipment entity
-- @param shipment the entity of the shipment your checking
-- @return string returns the name of the type of gun in it
function P.shipmentContents( shipment )
	if not IsValid(shipment) 
			or shipment:GetClass() ~= "spawned_shipment" then 
		return "" 
	end
	
	return CustomShipments[shipment.dt.contents]["name"]
end

--- Returns the number of guns left in a given shipment
-- @param shipment the entity of the shipment your checking
-- @return number returns the number of guns in the shipment
function P.shipmentAmount( shipment )
	if not IsValid(shipment) 
			or shipment:GetClass() ~= "spawned_shipment" then 
		return -1 
	end
	
	return shipment.dt.count
end

--- Returns a table containing all things the player can buy.
-- @param person the entity of the player requesting the table
-- @return table containing a number indexed list of the names of the guns a 
--         player can buy.
function P.merchandise( person )
	if not IsValid( person ) 
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
function P.guninfo( name )
	local info = { }
	
	local idx, gun = getGunTable( name )
	
	info["shipment"]  = not gun["noship"]
	info["single"]    =     gun["seperate"]
	info["count"]     =     gun["amount"]
	info["shipprice"] =     gun["price"]
	info["price"]     =     gun["pricesep"]
	info["model"]     =     gun["model"]
	
	return info
end

--- Allows you to buy a shipment
-- @param name the name of the gun you want to buy.
-- @param pos the position to spawn the shipment at
-- @param ang the angle to spawn the shipment at
-- @returns true if it succeeds, and nil, error if it fails.
function P.buyShipment( buyer, name, pos, ang )
	local idx, gun = getGunTable( name )
	if not gun then return nil, "not a valid gun name" end
	
	local player_team = buyer:Team()
	local allowed = false
	
	for _,id in pairs( gun.allowed ) do
		if id == player_team then
			allowed = true
		end
	end
	
	if not allowed then return nil, "you are not allowed to buy that gun" end
	
	if buyer:CanAfford( gun.price ) and not gun.noship then
		local shipment = spawnShipment( buyer, gun, pos, ang, idx )
		
		if shipment then
			buyer:AddMoney( -gun.price )
			print( "success" )
			return shipment
		end
	end
end

--- Allows you to buy a gun
-- @param name the name of the gun you want to buy
-- @param pos the position to spawn the gun at
-- @param ang the angle to spawn the gun at
-- @returns shipment if it succeeds, and nil, error if it fails.
function P.buyGun( buyer, name, pos )
	local idx, gun = getGunTable( name )
	if not gun then return nil, "not a valid gun name" end
	
	local player_team = buyer:Team()
	local allowed = false
	
	for _,id in pairs( gun.allowed ) do
		if id == player_team then
			allowed = true
		end
	end
	
	if not allowed then return nil, "you are not allowed to buy that gun" end
	
	if buyer:CanAfford( gun.price ) and gun.seperate then
		local gun = spawnGun( gun, pos )
		
		if gun then
			buyer:AddMoney( -gun.pricesep )
			return gun
		end
	end
end

--- Extracts a gun from a shipment you own
-- @param extractor the entity of the palyer extracting the gun
-- @param shipment the entity of the shipment you want to extract from, must be owned by you.
-- @param pos the vector position you want the gun extracted to
function P.extractGun( extractor, shipment, pos )
	if not IsValid(shipment) 
			or shipment:GetClass() ~= "spawned_shipment" then 
		return nil, "not a valid shipment"
	end
	
	if extractor.SID ~= shipment.SID then
		return nil, "you are not allowed to extract from that shipment"
	end
	
	local count = shipment.dt.count
	local contents = shipment.dt.contents
	local gun
	
	for k,v in pairs(CustomShipments) do
		if k == contents then
			gun = v
			break
		end
	end
	
	local spawned_gun = spawnGun( gun, pos )
	
	if gun then
		shipment.dt.count = count - 1
		if shipment.dt.count == 0 then
			shipment:Remove()
		end
		return spawned_gun
	end
end

--- Takes money from your supply and gives it to another player
-- @param giver the entity of the person giving money
-- @param receiver the entity of the player your giving money to
-- @param amount the amount you want to give to the player
-- @returns true if it succeeded, nil, error if it fails
function P.giveMoney( giver, receiver, amount )
	if not IsValid(giver) or 
			giver:GetClass() ~= "player" then 
		return nil, "giver not a valid player entity"
	end
	if not IsValid(receiver) or 
			receiver:GetClass() ~= "player" then 
		return nil, "receiver not a valid player entity"
	end
	
	if type( amount ) ~= "number" then 
		return nil, "amount must be a number" 
	end
	
	if amount < 0 then
		return nil, "amount must be a positive number"
	end
	
	if not giver:CanAfford( amount ) then
		return nil, "you can not afford to give that much"
	end
	
	giver:AddMoney( -amount )
	Notify( 
		giver, 
		4, 
		4, 
		"Your chip has given $" .. amount .. " to " .. receiver:GetName() .. "."
	)
	
	receiver:AddMoney( amount )
	Notify( 
		receiver, 
		4, 
		4, 
		receiver:GetName() .. "'s chip has given you $" .. amount .. "."
	)
	
	return true
end

--- Displays a derma menu on another player's screen asking them to 
-- give you money.  You may only ask someone on the server once every five
-- minutes.  
-- If a person declines your request you may not ask them again for one
-- minute.
-- @param chip entity of the processor making request
-- @param asker entity of the person asking for money
-- @param target entity of the person being asked
-- @param amount how much you would like
-- @param message a short message to accompany the request
-- @param cb a function to be called with result
function P.askForMoney( chip, asker, target, amount, cb )
	if not IsValid(asker) or 
			asker:GetClass() ~= "player" then 
		return nil, "asker not a valid player entity"
	end
	if not IsValid(target) or 
			target:GetClass() ~= "player" then 
		return nil, "target not a valid player entity"
	end
	
	if amount < 1 then
		return nil, "amount must be greater than 0"
	end
	
	if not target:CanAfford( amount ) then
		return nil, "target can not afford that much money"
	end
	
	local curtime = CurTime()
	local limits = ask_limits[ asker:SteamID() ]
	local playerask = ask_limits[ target:SteamID()  ]
	
	if limits == nil then
		limits = { }
		ask_limits[ asker:SteamID()  ] = limits
		limits[ "_next_ask" ] = curtime - 20
	end
	
	if curtime < limits["_next_ask"] then
		return nil, "you can not ask for money again this soon"
	end
	
	if playerask == true then
		return nil, "you are all ready asking that player for money"
	end
	
	limits[ target:SteamID()  ]  = true
	limits[ "_next_ask" ] = CurTime() + 5
	
	local target_requests = requests[ target:SteamID() ]
	
	if target_requests == nil then
		target_requests = { }
		requests[ target:SteamID()  ] = target_requests
	end
	
	local requestnum = #target_requests + 1
	local request = { }
	target_requests[ requestnum ] = request
	
	request.asker  = asker
	request.amount = amount
	request.requester = chip
	request.target = target
	request.cb = cb
	
	umsg.Start( "drpumsg_money_request", target )
		umsg.Entity( asker )
		umsg.Long( requestnum )
		umsg.Long( amount )
	umsg.End( )
end

local function find_player_by_steamid( steamid )
	
end

-- Handle requst results
local function money_response( person, cmd, args )
	local response = args[ 1 ]
	local requestnum = tonumber( args[2] )
	local asker = Player( tonumber( args[3] ) )
	local request = requests[ asker:SteamID()  ]
	request = request[ requestnum ]
	
	local cb = request.cb
	local limits = ask_limits[ asker:SteamID() ]
	local curtime = CurTime( )
	
	if response == "cancel" then
		request.response = 0
		
		
	elseif response == "decline" then
		request.response = -1
		
		
	elseif response == "accept" then
		request.response = 1
		
		local amount = request.amount
		
		person:AddMoney( -amount )
		asker:AddMoney( amount )
		
		local message = "You have payed $" .. tostring( amount ) .. 
				" to " .. asker:Nick() .. "."
		person:ChatPrint( message )
		
		message = person:Nick() .. " has payed you $" .. amount .. "."
		asker:ChatPrint( message )
	end
	
end
concommand.Add( "drp_money_request", money_response )
