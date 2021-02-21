local Sss = game:GetService('ServerScriptService')
local Statue = require(Sss.Source.Statue.Statue)
local Key = require(Sss.Source.Key.Key)
local Door = require(Sss.Source.Door.Door)
local Bridge = require(Sss.Source.Bridge.Bridge)

local Utils = require(Sss.Source.Utils.U001GeneralUtils)
local Replicator = require(Sss.Source.BlockDash.Replicator)

local module = {}

function module.initStatueGates(props)
    local hexConfigs = props.configs or {}
    local parentFolder = props.parentFolder

    local hexIslandFolderBox = Utils.getFirstDescendantByName(parentFolder, 'HexIslands')
    local hexIslandFolders = hexIslandFolderBox:getChildren()
    Utils.sortListByObjectKey(hexIslandFolders, 'Name')

    for hexIndex, hexIslandFolder in ipairs(hexIslandFolders) do
        local hexConfig = hexConfigs[hexIndex] or {}
        local bridgeConfigs = hexConfig.bridgeConfigs or {}
        Bridge.initBridges({parentFolder = hexIslandFolder, bridgeConfigs = bridgeConfigs})

        if hexConfig then
            local statueConfigs = hexConfig.statueConfigs
            if statueConfigs then
                local statueGates = Utils.getByTagInParent({parent = hexIslandFolder, tag = 'StatueGate'})
                for _, gate in ipairs(statueGates) do
                    local statuePositioners = Utils.getByTagInParent({parent = gate, tag = 'StatuePositioner'})
                    for _, statuePositioner in ipairs(statuePositioners) do
                        local statueName = statuePositioner.Name
                        local config = statueConfigs[statueName] or {}
                        Statue.initStatue(statuePositioner, config)

                        local keyPositioners = Utils.getByTagInParent({parent = gate, tag = 'KeyPositioner-Key'})
                        local keyPositioner = keyPositioners[1]

                        local doorPositioners = Utils.getByTagInParent({parent = gate, tag = 'BasicDoorPositioner'})
                        local doorPositioner = doorPositioners[1]

                        local dummy = Utils.getFirstDescendantByName(doorPositioner, 'Dummy')
                        if dummy then
                            dummy:Destroy()
                        end

                        local replicatorProps = {
                            rewardTemplate = Utils.getFromTemplates('ColorKey'),
                            positionerModel = keyPositioner,
                            parentFolder = parentFolder
                        }

                        local doorProps = {
                            positioner = doorPositioner.Positioner,
                            parentFolder = parentFolder,
                            keyName = 'Yellow',
                            width = 32
                            -- noGem = noGem
                        }

                        local newDoor = Door.initDoor(doorProps)
                        local newReplicator = Key.initKey(replicatorProps)
                        Replicator.initReplicator(newReplicator)
                    end
                end
            end
        end
    end
end

return module
