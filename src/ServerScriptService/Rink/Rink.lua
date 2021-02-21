local Sss = game:GetService('ServerScriptService')

local Utils = require(Sss.Source.Utils.U001GeneralUtils)
local Utils3 = require(Sss.Source.Utils.U003PartsUtils)

local LetterGrabber = require(Sss.Source.LetterGrabber.LetterGrabber)
local StrayLetterBlocks = require(Sss.Source.StrayLetterBlocks.StrayLetterBlocks)
local InvisiWall = require(Sss.Source.InvisiWall.InvisiWall2)

local module = {}

function module.initPuck(puck)
    local thrust = Instance.new('BodyThrust', puck)
    thrust.Force = Vector3.new(0, 0, 2000)

    local av = Instance.new('BodyAngularVelocity', puck)
    av.MaxTorque = Vector3.new(1000000, 1000000, 1000000)
    av.AngularVelocity = Vector3.new(0, 1, 0)
    av.P = 1250

    puck.WeldConstraint.Enabled = false
    puck.WeldConstraint:Destroy()
end

function module.initRink(rink)
    local puck = rink.Puck.PrimaryPart

    local thrust = Instance.new('BodyThrust', puck)
    thrust.Force = Vector3.new(0, 0, 2000)

    local av = Instance.new('BodyAngularVelocity', puck)
    av.MaxTorque = Vector3.new(1000000, 1000000, 1000000)
    av.AngularVelocity = Vector3.new(0, 1, 0)
    av.P = 1250

    puck.WeldConstraint.Enabled = false
    puck.WeldConstraint:Destroy()
end

function module.initRinks(props)
    local parentFolder = props.parentFolder or workspace
    local rinks = Utils.getDescendantsByName(parentFolder, 'Rink')

    for i, rink in ipairs(rinks) do
        module.initRink(rink)
    end
end

function module.addRink(props)
    local bridgeConfig = props.bridgeConfig
    local bridge = props.bridge
    local parentFolder = props.parentFolder
    local size = props.size

    local cloneProps = {
        parentTo = bridge,
        positionToPart = bridge.PrimaryPart,
        templateName = 'Rink',
        fromTemplate = true,
        modelToClone = nil,
        offsetConfig = {
            useParentNearEdge = Vector3.new(0, 1, 0),
            useChildNearEdge = Vector3.new(0, -1, 0),
            offsetAdder = Vector3.new(0, 0, 0)
        }
    }

    local rinkModel = Utils.cloneModel(cloneProps)
    local rinkPart = rinkModel.PrimaryPart

    local buffer = 2
    rinkPart.Size = Vector3.new(size.X, rinkPart.Size.Y, size.Z - buffer)

    local grabbers = bridgeConfig.itemConfig.grabbers or {}
    local words = bridgeConfig.itemConfig.words or {}
    for grabberIndex, grabberWord in ipairs(grabbers) do
        local offsetX = (grabberIndex - 1) * 10
        local positioner = Instance.new('Part', rinkModel)
        positioner.CFrame =
            Utils3.setCFrameFromDesiredEdgeOffset(
            {
                parent = rinkPart,
                child = positioner,
                offsetConfig = {
                    useParentNearEdge = Vector3.new(0, -1, -1),
                    useChildNearEdge = Vector3.new(0, -1, -1),
                    offsetAdder = Vector3.new(offsetX, 0, 20)
                }
            }
        )

        positioner.CFrame = positioner.CFrame * CFrame.Angles(0, math.rad(180), 0)
        local grabbersConfig = {
            word = grabberWord,
            parentFolder = parentFolder,
            positioner = positioner
        }

        local newGrabber = LetterGrabber.initLetterGrabber(grabbersConfig)
        positioner:Destroy()
        -- local grabberPart = newGrabber.PrimaryPart

        -- grabberPart.CFrame = grabberPart.CFrame * CFrame.Angles(0, math.rad(180), 0)
    end

    local strayRegion = Utils.getFirstDescendantByName(rinkModel, 'StrayRegion')

    local blockTemplate = Utils.getFirstDescendantByName(rinkModel, 'Puck')
    local blockTemplatePart = blockTemplate.PrimaryPart

    local wordLength = 3
    local requiredLetters = #words * wordLength

    InvisiWall.setAllInvisiWalls(
        {
            thickness = 3,
            height = 2,
            shortHeight = 0,
            shortWallProps = {
                Transparency = 0,
                BrickColor = BrickColor.new('Light yellow'),
                Material = Enum.Material.Grass
            },
            wallProps = {
                Transparency = 0,
                BrickColor = BrickColor.new('Alder'),
                Material = Enum.Material.Granite
            },
            part = rinkModel.PrimaryPart
        }
    )

    local strays =
        StrayLetterBlocks.initStraysInRegion(
        {
            parentFolder = parentFolder,
            numBlocks = math.floor(requiredLetters * 1.2),
            words = words,
            region = strayRegion,
            blockTemplate = blockTemplatePart,
            onTouchBlock = function()
            end
        }
    )

    for _, stray in ipairs(strays) do
        stray.CanCollide = true
        module.initPuck(stray)
    end

    -- module.initRink(rinkModel)
    return rinkModel
end

return module
