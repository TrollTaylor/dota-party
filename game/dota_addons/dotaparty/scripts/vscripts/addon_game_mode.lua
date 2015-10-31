-- Generated from template
local playersIn = {}

if DotaParty == nil then
	DotaParty = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
		PrecacheResource( "model", "models/heroes/pedestal/effigy_pedestal_ti5.vmdl", context )
end
-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = DotaParty()
	GameRules.AddonTemplate:InitGameMode()
end

function DotaParty:OnNPCSpawned( keys )

	local npc = EntIndexToHScript(keys.entindex)

	if  npc:GetUnitName() == "npc_dota_blue_space" then
		npc:SetRenderColor(0,0,1000)

	end

 	if  npc:GetUnitName() == "npc_dota_red_space" then
		npc:SetRenderColor(1000,0,0)

	end
end

function DotaParty:InitGameMode()
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	--GameRules:GetGameModeEntity():SetCustomGameForceHero("npc_dota_hero_wisp")
	GameRules:GetGameModeEntity():SetAnnouncerDisabled(true)
	GameRules:GetGameModeEntity():SetBuybackEnabled(false)
	GameRules:GetGameModeEntity():SetFixedRespawnTime(0.0)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(DotaParty, 'OnNPCSpawned'), self)





end

-- Evaluate the state of the game
function DotaParty:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end