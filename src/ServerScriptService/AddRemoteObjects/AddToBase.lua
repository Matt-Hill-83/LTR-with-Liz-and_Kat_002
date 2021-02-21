local Sss = game:GetService('ServerScriptService')

local Utils = require(Sss.Source.Utils.U001GeneralUtils)
local Constants = require(Sss.Source.Constants.Constants)
local LevelConfigs = require(Sss.Source.LevelConfigs.LevelConfigs)
local ConfigRemoteEvents = require(Sss.Source.AddRemoteObjects.ConfigRemoteEvents)

local BeltJoint = require(Sss.Source.BeltJoint.BeltJoint)
local BlockDash = require(Sss.Source.BlockDash.BlockDash)
local ConfigGame = require(Sss.Source.AddRemoteObjects.ConfigGame)
local Door = require(Sss.Source.Door.Door)
local Entrance = require(Sss.Source.BlockDash.Entrance)
local HexJunction = require(Sss.Source.HexJunction.HexJunction)
local HexWall = require(Sss.Source.HexWall.HexWall)
local Junction = require(Sss.Source.Junction.Junction)
local Key = require(Sss.Source.Key.Key)
local PlayerStatManager = require(Sss.Source.AddRemoteObjects.PlayerStatManager)
local SkiSlope = require(Sss.Source.SkiSlope.SkiSlope)
local StatueGate = require(Sss.Source.StatueGate.StatueGate)
local Terrain = require(Sss.Source.Terrain.Terrain)

local module = {}

function module.addConveyors(level, sectorConfigs)
    local islandTemplate = Utils.getFromTemplates('IslandTemplate')

    local islandPositioners = Utils.getByTagInParent({parent = level, tag = 'IslandPositioner'})
    Utils.sortListByObjectKey(islandPositioners, 'Name')
    local myPositioners = Constants.gameConfig.singleIsland and {islandPositioners[1]} or islandPositioners

    for islandIndex, islandPositioner in ipairs(myPositioners) do
        -- if islandIndex == 3 then break end
        local newIsland = islandTemplate:Clone()

        local anchoredParts = {}
        for _, child in pairs(newIsland:GetDescendants()) do
            if child:IsA('BasePart') then
                if child.Anchored then
                    child.Anchored = false
                    table.insert(anchoredParts, child)
                end
            end
        end

        newIsland.Parent = level
        newIsland.Name = 'Sector-' .. islandPositioner.Name
        if sectorConfigs then
            local sectorConfig = sectorConfigs[(islandIndex % #sectorConfigs) + 1]
            sectorConfig.sectorFolder = newIsland
            sectorConfig.islandPositioner = islandPositioner

            for _, child in pairs(anchoredParts) do
                child.Anchored = true
            end
            BlockDash.addBlockDash(sectorConfig)
        end
    end
end

local function addRemoteObjects()
    ConfigRemoteEvents.configRemoteEvents()

    local myStuff = workspace:FindFirstChild('MyStuff')

    local blockDash = Utils.getFirstDescendantByName(myStuff, 'BlockDash')
    local levelsFolder = Utils.getFirstDescendantByName(blockDash, 'Levels')
    local levels = levelsFolder:GetChildren()
    Utils.sortListByObjectKey(levels, 'Name')

    local islandTemplate = Utils.getFromTemplates('IslandTemplate')

    for levelIndex, level in ipairs(levels) do
        -- if levelIndex == 2 then break end

        local levelConfig = LevelConfigs.levelConfigs[levelIndex]
        local hexIslandConfigs = levelConfig.hexIslandConfigs

        StatueGate.initStatueGates({parentFolder = level, configs = hexIslandConfigs})
        Entrance.initRunFasts(level)
        Door.initDoors({parentFolder = level})
        Key.initKeys({parentFolder = level})

        BeltJoint.initBeltJoints({parentFolder = level})
        HexWall.initHexWalls({parentFolder = level})
        Junction.initJunctions({parentFolder = level})
        HexJunction.convertJunctionsToTerrain({})
        SkiSlope.initSlopes({parentFolder = level})
        Terrain.initTerrain({parentFolder = workspace})

        if true then
            local sectorConfigs = levelConfig.sectorConfigs
            module.addConveyors(level, sectorConfigs)
        end
    end
    islandTemplate:Destroy()

    PlayerStatManager.init()
    ConfigRemoteEvents.initRemoteEvents()

    -- Do this last after everything has been created/deleted
    ConfigGame.configGame()
end

module.addRemoteObjects = addRemoteObjects
return module
