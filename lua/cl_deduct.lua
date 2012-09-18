local function openRequestMenu( data )
	local asker = data:ReadEntity()
	local requestnum = data:ReadLong()
	local amount = data:ReadLong()
	
	local DeductFrame = vgui.Create( "DFrame" )
	DeductFrame:SetSize( 250,  200 )
	DeductFrame:SetPos( ( ScrW() / 2 ) - 125, ( ScrH() / 2 ) - 75 )
	DeductFrame:SetTitle( asker:Nick() .. " is asking you for money" )
	DeductFrame:SetVisible( true )
	DeductFrame:ShowCloseButton( false )
	DeductFrame:MakePopup()
	
	local DeductLabel = Label(
		"The Precessor of " .. asker:Nick() .. " is asking \nyou for $" .. 
		tostring(amount) .. 
		"\nWould you like to accept?",
		DeductFrame
	)
	DeductLabel:SizeToContents()
	DeductLabel:SetPos( 10, 30 )
	
	local DeductYes = vgui.Create( "DButton", DeductFrame )
	DeductYes:SetPos( 10, 100 )
	DeductYes:SetSize( 100, 40 )
	DeductYes:SetText( "Yes" )
	DeductYes.DoClick = function()
		RunConsoleCommand( "drp_money_request", "accept", requestnum )
		DeductFrame:Close()
	end
	
	local DeductNo = vgui.Create( "DButton", DeductFrame )
	DeductNo:SetPos( 135, 100 )
	DeductNo:SetSize( 100, 40 )
	DeductNo:SetText( "No" )
	DeductNo.DoClick = function()
		RunConsoleCommand( "drp_money_request", "decline", requestnum )
		DeductFrame:Close()
	end
end
usermessage.Hook( "drpumsg_money_request", openRequestMenu )