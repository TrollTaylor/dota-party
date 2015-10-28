-- Generated from template
local playersIn = {}
local icon = Entities:CreateByClassname("prop_dynamic")

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
	PrecacheResource( "model", "models/items/ember_spirit/ember_hat/ember_hat.vmdl", context)

end
-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = DotaParty()
	GameRules.AddonTemplate:InitGameMode()
end

function DotaParty:OnNPCSpawned( keys )
	  		 wingsModel = "models/items/ember_spirit/ember_hat/ember_hat.vmdl"

		local npc = EntIndexToHScript(keys.entindex)

	playersIn[PlayerResource:GetPlayerName(npc:GetPlayerOwnerID())] = true
	print("THE VALUE ", playersIn[PlayerResource:GetPlayerName(npc:GetPlayerOwnerID())], " WHO IT IS ", PlayerResource:GetPlayerName(npc:GetPlayerOwnerID()) )
	if npc:IsRealHero() and playersIn[PlayerResource:GetPlayerName(npc:GetPlayerOwnerID())] ~= nil and playersIn[PlayerResource:GetPlayerName(npc:GetPlayerOwnerID())] == true then

  	 	 icon:SetModel(wingsModel)
  	 	 icon:SetParent(npc:GetRootMoveParent(), "attach_hitloc")
   		-- icon:SetOrigin(Vector(0, 0, 18))
   		 icon:SetModelScale(1.50)

	end
 
end

function DotaParty:InitGameMode()
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	--GameRules:GetGameModeEntity():SetCustomGameForceHero("npc_dota_hero_wisp")
	GameRules:GetGameModeEntity():SetAnnouncerDisabled(true)
	GameRules:GetGameModeEntity():SetBuybackEnabled(false)
	GameRules:GetGameModeEntity():SetFixedRespawnTime(0.0)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(DotaParty, 'OnNPCSpawned'), self)

Convars:RegisterCommand( "setIonA", function(scale)

    local cmdPlayer = Convars:GetCommandClient()
    if cmdPlayer then
    	
        return icon:SetModelScale(scale)

    end
end, "a", 0 )


Convars:RegisterCommand( "setIonB", function(x,y,z)

    local cmdPlayer = Convars:GetCommandClient()
    if cmdPlayer then
    	
        return icon:SetOrigin(Vector(tonumber(x), tonumber(y), tonumber(z)))


    end
end, "a", 0 )

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