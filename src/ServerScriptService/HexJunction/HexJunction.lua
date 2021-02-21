local Sss = game:GetService('ServerScriptService')
local Utils = require(Sss.Source.Utils.U001GeneralUtils)

local module = {}

function module.convertJunctionsToTerrain(props)
    local parent = workspace
    local hexJunctions = Utils.getDescendantsByName(parent, 'HexJunction')

    for _, hex in ipairs(hexJunctions) do
        Utils.convertItemAndChildrenToTerrain({parent = hex})
    end
end

return module
