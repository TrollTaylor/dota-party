-- Generated from template
local playersIn = {}
local rollers = {}
local playersSpaces = {}
--local space = nil
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

	if npc:IsRealHero() then
		playersSpaces[PlayerResource:GetPlayer(npc:GetPlayerOwnerID())] = 1

	end


	if  npc:GetUnitName() == "npc_dota_blue_space" then
		npc:SetRenderColor(0,0,1000)
		space = npc

	end

 	if  npc:GetUnitName() == "npc_dota_red_space" then
		npc:SetRenderColor(1000,0,0)

	end
end
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end


function RollDice(eventSourceIndex, args)	
	local player = PlayerResource:GetPlayer(args['roller']) 
	local space = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, PlayerResource:GetSelectedHeroEntity(args['roller']):GetOrigin(), nil, 100000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	local roll =  math.random(1,10)
	local spaceimgoingto = nil
	print("roll = ", roll)
				
					for i = 1, roll do 

		--print(space[i]:GetOrigin())
				--print(space[i]:GetDebugName(), " equaled I")
				for a = 1, tablelength(space) do
        spaceimgoingto =  a

					if tonumber(space[a]:GetDebugName()) == i  then
											print("a = ", space[a]:GetDebugName(), " i = ", space[i]:GetDebugName(), " playersSpaces = ", playersSpaces[player])

	local order = {
            UnitIndex = PlayerResource:GetSelectedHeroEntity(args['roller']):GetEntityIndex(),
            OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
            Position = space[ spaceimgoingto  ]:GetOrigin(),
            Queue = true
        }
        ExecuteOrderFromTable(order)	
					end 
				end
					--print("yeye")
 	
		
		
	end

				playersSpaces[player] = playersSpaces[player] + roll
				print("space = ", playersSpaces[player])
        print("the space im going to is ", spaceimgoingto)

end

function setPlayerSpace(playeSpce)
	playersSpaces[playeSpce] = 1
end

function DotaParty:InitGameMode()
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	--GameRules:GetGameModeEntity():SetCustomGameForceHero("npc_dota_hero_wisp")
	GameRules:GetGameModeEntity():SetAnnouncerDisabled(true)
	GameRules:GetGameModeEntity():SetBuybackEnabled(false)
	GameRules:GetGameModeEntity():SetFixedRespawnTime(0.0)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(DotaParty, 'OnNPCSpawned'), self)
	CustomGameEventManager:RegisterListener( "rollDice", RollDice )



Convars:RegisterCommand( "playerID", function()

    local cmdPlayer = Convars:GetCommandClient()
    local player = PlayerResource:GetPlayer(cmdPlayer:GetPlayerID())

    if cmdPlayer then
        return setPlayerSpace(player)
    end
end, "a", 0 )

Convars:RegisterCommand( "playerIDp", function()

    local cmdPlayer = Convars:GetCommandClient()
    local player = PlayerResource:GetPlayer(cmdPlayer:GetPlayerID())

    if cmdPlayer then
        return print(playersSpaces[player])
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