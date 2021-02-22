-- local isDev = true
local isDev = false
--
local activeSpawn
activeSpawn = 'SpawnLocation_Hex3'
activeSpawn = 'SpawnLocation_Hex1'
activeSpawn = 'SpawnLocation_ramp'
activeSpawn = 'SpawnLocation_L2H1'
activeSpawn = 'SpawnLocation_L3H1'
activeSpawn = 'Spawn-L2'
activeSpawn = 'SpawnLocation_L3_ramp'

local devGameConfig = {
    singleIsland = false,
    -- singleIsland = true,
    transparency = false,
    -- transparency = true,
    -- walkSpeed = 30,
    walkSpeed = 80
}

local prodGameConfig = {
    singleIsland = false,
    -- singleIsland = true,
    transparency = true,
    -- walkSpeed = 30
    walkSpeed = 80
}

local gameConfig = isDev and devGameConfig or prodGameConfig

gameConfig.activeSpawn = activeSpawn
gameConfig.isDev = isDev

local module = {
    gameConfig = gameConfig, --
    walkSpeed = gameConfig.walkSpeed, --
    gameData = {letterGrabbers = {}}
}

return module
