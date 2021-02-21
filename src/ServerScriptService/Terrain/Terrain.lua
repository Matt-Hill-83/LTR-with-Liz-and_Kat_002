local Sss = game:GetService('ServerScriptService')

local Utils = require(Sss.Source.Utils.U001GeneralUtils)

local module = {}

function module.initTerrain(props)
    local parentFolder = props.parentFolder or workspace
    local materials = Enum.Material:GetEnumItems()
    print('materials' .. ' - start')
    print(Utils.tableToString({materials}))
    print('materials' .. ' - end')

    for _, material in ipairs(materials) do
        local tagName = 'T-' .. material.Name

        local parts = Utils.getByTagInParent({parent = parentFolder, tag = tagName})

        for _, part in ipairs(parts) do
            Utils.convertItemAndChildrenToTerrain({parent = part, material = material, ignoreKids = true})
        end
    end

    -- Do air last, for subtracting terrain
    local airParts = Utils.getByTagInParent({parent = parentFolder, tag = 'T-Air'})
    print('airParts' .. ' - start')
    print(airParts)
    for _, part in ipairs(airParts) do
        Utils.convertItemAndChildrenToTerrain({parent = part, material = 'Air', ignoreKids = true})
    end
end

return module
