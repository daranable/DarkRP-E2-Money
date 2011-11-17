function E2Deduct(ply,cmd,args)
	local e2id = args[1]
	local amount = args[2]
	local e2ent = ents.GetByIndex(e2id)
	if !ValidEntity(e2ent) or e2id==0 then return end
	if ply:CanAfford(amount) then
		ply:AddMoney(amount * -1)
		e2ent.Accepted = true
		e2ent:Execute()
		e2ent.Amount = 0
		e2ent.giver=ply
		e2ent.player:AddMoney(amount)
		e2ent.player:ChatPrint("Your e2 has paid you $" .. tostring(amount) .. " from " .. ply:Nick())
	end
end
concommand.Add("deduct_e2",E2Deduct)

function E2DReject(ply,cmd,args)
	local e2id = args[1]
	local e2ent = ents.GetByIndex(e2id)
	if !ValidEntity(e2ent) or e2id==0 then return end
	e2ent.Amount = 0
end
concommand.Add("deduct_e2_no",E2DReject)

e2function void askForMoney(entity ply, number amount)
	umsg.Start("e2deduct", ply)
		umsg.Long(self.entity:EntIndex())
		umsg.String(self.entity.name)
		umsg.Long(amount)
	umsg.End()
	self.entity.Amount = amount
end

e2function number deductClk()
	if self.entity.Accepted then
		self.entity.Accepted = false
		return 1
	else
		return 0
	end
end

e2function number deductAmount()
	if self.entity.Amount then
		return self.entity.Amount
	else
		return 0
	end
end

e2function entity deductPlayer()
	if self.entity.giver and self.entity.giver:IsPlayer() then
		return self.entity.giver
	else
		return ents.GetByIndex(0)
	end
end

e2function void giveMoney(entity ply, number amount)
	if !ply:IsPlayer() then return end
	if amount < 0 then return end
	if !self.entity.player:CanAfford(amount) then return end
	self.entity.player:AddMoney(amount*-1)
	ply:AddMoney(amount)
	ply:ChatPrint(self.entity.player:Nick() .. "'s e2 has given you $" .. amount)
	self.entity.player:ChatPrint("You gave away $" .. amount .. " to " .. ply:Nick())
end