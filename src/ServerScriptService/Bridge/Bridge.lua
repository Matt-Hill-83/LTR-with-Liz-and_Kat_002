local Sss = game:GetService('ServerScriptService')
local CS = game:GetService('CollectionService')
local Utils = require(Sss.Source.Utils.U001GeneralUtils)

local Rink = require(Sss.Source.Rink.Rink)

local module = {}

function module.createBridge(props)
    local templateName = props.templateName
    local parentFolder = props.parentFolder
    local p0 = props.p0
    local p1 = props.p1

    local bridgeTemplate = Utils.getFromTemplates(templateName)

    local newBridge = bridgeTemplate:Clone()
    newBridge.Parent = parentFolder
    local bridgePart = newBridge.PrimaryPart

    local Distance = (p0 - p1).Magnitude
    bridgePart.CFrame = CFrame.new(p0, p1) * CFrame.new(0, 0, -Distance / 2)
    bridgePart.Size = Vector3.new(bridgePart.Size.X, bridgePart.Size.Y, Distance)

    bridgePart.Anchored = true
    local wallFolder = Utils.getFirstDescendantByName(newBridge, 'Walls')
    local walls = wallFolder:getChildren()
    -- local top = Utils.getFirstDescendantByName(newBridge, 'Top')

    for _, wall in ipairs(walls) do
        wall.Size = Vector3.new(wall.Size.X, wall.Size.Y, Distance)
    end
    return newBridge
end

function module.rodIsValid(rod)
    local isValid = false

    local hasAtt0 = Utils.hasProperty(rod, 'Attachment0')
    local hasAtt1 = Utils.hasProperty(rod, 'Attachment1')

    if hasAtt0 == true and hasAtt1 == true then
        local hasParent0 = Utils.hasProperty(rod.Attachment0, 'Parent')
        local hasParent1 = Utils.hasProperty(rod.Attachment1, 'Parent')
        if
            hasParent0 and hasParent1 and rod.Attachment0.Parent and rod.Attachment0.Parent.Position and
                rod.Attachment1.Parent and
                rod.Attachment1.Parent.Position
         then
            isValid = true
        end
    end

    return isValid
end

function module.initBridges(props)
    local parentFolder = props.parentFolder
    local bridgeConfigs = props.bridgeConfigs

    local rods =
        Utils.getInstancesByNameStub(
        {
            nameStub = 'RodConstraint',
            parent = parentFolder
        }
    )

    Utils.sortListByObjectKey(rods, 'Name')

    local bridges = {}
    for rodIndex, rod in ipairs(rods) do
        local bridgeConfig = bridgeConfigs[rodIndex] or {}

        local rodValid = module.rodIsValid(rod)

        if rodValid then
            local bridge =
                module.createBridge(
                {
                    p0 = rod.Attachment0.Parent.Position,
                    p1 = rod.Attachment1.Parent.Position,
                    templateName = 'Bridge',
                    parentFolder = parentFolder
                }
            )
            rod:Destroy()
            local bridgeTop = Utils.getFirstDescendantByName(bridge, 'Top')
            if bridgeConfig.item == 'Rink' then
                Utils.convertItemAndChildrenToTerrain(
                    {parent = bridgeTop, material = 'Air', ignoreKids = true, canCollide = true}
                )
                -- CS:AddTag(bridgeTop, 'T-Air')

                local rinkProps = {
                    bridgeConfig = bridgeConfig,
                    bridge = bridge,
                    parentFolder = parentFolder,
                    size = bridgeTop.Size
                }
                local newRink = Rink.addRink(rinkProps)
            else
                -- CS:AddTag(bridgeTop, 'T-Grass')
                Utils.convertItemAndChildrenToTerrain({parent = bridgeTop, material = 'Grass', ignoreKids = true})
            end
            table.insert(bridges, bridge)
        end
    end
    return bridges
end

return module
