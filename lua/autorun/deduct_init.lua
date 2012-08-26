-- Include needed files for deduct clk

if SERVER then
	-- this file
	AddCSLuaFile( "autorun/deduct_init.lua" )
	AddCSLuaFile( "cl_deduct.lua" )
	
	include( "darkrp_scripting.lua" )
end

if CLIENT then
	include( "cl_deduct.lua" )
end