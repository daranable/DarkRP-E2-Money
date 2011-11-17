function OpenDeductMenu(data)
	local e2id = data:ReadLong()
	local e2name = data:ReadString()
	local amount = data:ReadLong()
	
	local DeductFrame = vgui.Create("DFrame")
	DeductFrame:SetSize(250, 150)
	DeductFrame:SetPos((ScrW()/2)-125,(ScrH()/2)-75)
	DeductFrame:SetTitle(e2name .. " is asking you for money")
	DeductFrame:SetVisible(true)
	DeductFrame:ShowCloseButton(true)
	DeductFrame:MakePopup()
	
	local DeductLabel = Label("The E2 Chip " .. e2name .. " is asking \nyou for $" .. tostring(amount) .. "\nWould you like to accept?",DeductFrame)
	DeductLabel:SizeToContents()
	DeductLabel:SetPos(10,30)
	
	local DeductYes = vgui.Create("DButton", DeductFrame)
	DeductYes:SetPos(10, 100)
	DeductYes:SetSize(100,40)
	DeductYes:SetText("Yes")
	DeductYes.DoClick = function()
		RunConsoleCommand("deduct_e2",e2id,amount)
		DeductFrame:Close()
	end
	
	local DeductNo = vgui.Create("DButton", DeductFrame)
	DeductNo:SetPos(135,100)
	DeductNo:SetSize(100,40)
	DeductNo:SetText("No")
	DeductNo.DoClick = function()
		RunConsoleCommand("deduct_e2_no",e2id)
		DeductFrame:Close()
	end
end
usermessage.Hook("e2deduct",OpenDeductMenu)