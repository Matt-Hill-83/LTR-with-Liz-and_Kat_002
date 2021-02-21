local Sss = game:GetService('ServerScriptService')

local Utils = require(Sss.Source.Utils.U001GeneralUtils)
local Utils3 = require(Sss.Source.Utils.U003PartsUtils)

local module = {}

local configs = {
    FRONT = {
        offsetConfig = {
            useParentNearEdge = Vector3.new(0, 1, -1),
            useChildNearEdge = Vector3.new(0, -1, -1)
        },
        getSize = function(part, height, thickness)
            return Vector3.new(part.Size.X, height, thickness)
        end
    },
    BACK = {
        offsetConfig = {
            useParentNearEdge = Vector3.new(0, 1, 1),
            useChildNearEdge = Vector3.new(0, -1, 1)
        },
        getSize = function(part, height, thickness)
            return Vector3.new(part.Size.X, height, thickness)
        end
    },
    LEFT = {
        offsetConfig = {
            useParentNearEdge = Vector3.new(1, 1, 0),
            useChildNearEdge = Vector3.new(1, -1, 0)
        },
        getSize = function(part, height, thickness)
            return Vector3.new(thickness, height, part.Size.Z)
        end
    },
    RIGHT = {
        offsetConfig = {
            useParentNearEdge = Vector3.new(-1, 1, 0),
            useChildNearEdge = Vector3.new(-1, -1, 0)
        },
        getSize = function(part, height, thickness)
            return Vector3.new(thickness, height, part.Size.Z)
        end
    }
}

function module.setAllInvisiWalls(props)
    module.setInvisiWallFront(props)
    module.setInvisiWallBack(props)
    module.setInvisiWallLeft(props)
    module.setInvisiWallRight(props)
end

function module.setInvisiWallFront(props)
    module.setInvisiWall(props, 'FRONT')
end
function module.setInvisiWallBack(props)
    module.setInvisiWall(props, 'BACK')
end
function module.setInvisiWallLeft(props)
    module.setInvisiWall(props, 'LEFT')
end
function module.setInvisiWallRight(props)
    module.setInvisiWall(props, 'RIGHT')
end

function module.setInvisiWall(props, sideName)
    local height = props.height or 16
    local thickness = props.thickness or 1
    local wallProps = props.wallProps or {}
    local shortWallProps = props.shortWallProps or {}
    local shortHeight = props.shortHeight or 2
    local part = props.part

    local config = configs[sideName]
    local offsetConfig = config.offsetConfig
    local getSize = config.getSize

    local newWall = Instance.new('Part')

    newWall.Parent = part.Parent
    newWall.Color = part.Color
    newWall.Size = getSize(part, height, thickness)
    newWall.CFrame =
        Utils3.setCFrameFromDesiredEdgeOffset(
        {
            parent = part,
            child = newWall,
            offsetConfig = offsetConfig
        }
    )

    newWall.CanCollide = true
    newWall.Anchored = false
    local shortWall = newWall:Clone()

    Utils.mergeTables(newWall, wallProps)

    shortWall.Parent = newWall.Parent
    shortWall.Size = Vector3.new(shortWall.Size.X, shortHeight, shortWall.Size.Z)

    local weld = Instance.new('WeldConstraint')
    weld.Name = 'WeldConstraint-wall'
    weld.Parent = newWall
    weld.Part0 = newWall
    weld.Part1 = part

    shortWall.CFrame =
        Utils3.setCFrameFromDesiredEdgeOffset(
        {
            parent = newWall,
            child = shortWall,
            offsetConfig = {
                useParentNearEdge = Vector3.new(0, -1, 0),
                useChildNearEdge = Vector3.new(0, -1, 0)
            }
        }
    )

    -- newWall.Transparency = transparency
    shortWall.Transparency = 0
    shortWall.Anchored = true
    shortWall.Material = Enum.Material.Cobblestone
    shortWall.BrickColor = BrickColor.new('Pastel green')
    Utils.mergeTables(shortWall, shortWallProps)
end

return module
