local Sss = game:GetService('ServerScriptService')

local Utils = require(Sss.Source.Utils.U001GeneralUtils)
local Utils3 = require(Sss.Source.Utils.U003PartsUtils)
local LetterUtils = require(Sss.Source.Utils.U004LetterUtils)

local module = {}

local function createStray(char, parentFolder, props)
    local isGem = false
    -- local isGem = true

    local blockTemplate = props and props.blockTemplate
    if props and props.blockTemplate then
    -- print('props.blockTemplate' .. ' - start')
    -- print(props.blockTemplate)
    end
    local letterBlockFolder = Utils.getFromTemplates('LetterBlockTemplates')

    local modelClone
    local newLetterBlock

    if isGem then
        local letterBlockTemplate = Utils.getFromTemplates('HexLetterGemTemplate')
        modelClone = letterBlockTemplate:Clone()
    else
        -- local letterBlockTemplate = Utils.getFirstDescendantByName(letterBlockFolder, 'Stray_available')
        local letterBlockTemplate = blockTemplate or Utils.getFirstDescendantByName(letterBlockFolder, 'BD_6_blank')
        local letterBlockTemplate2 = letterBlockTemplate:Clone(letterBlockTemplate)
        -- letterBlockTemplate2.Parent = letterBlockTemplate.Parent

        local dummyModel = Instance.new('Model', letterBlockFolder)
        letterBlockTemplate2.Parent = dummyModel
        dummyModel.PrimaryPart = letterBlockTemplate
        -- modelClone = dummyModel:Clone()
        modelClone = dummyModel
        newLetterBlock = letterBlockTemplate2
    end

    local letterId = 'ID--R'

    local name = 'strayLetter-ppp' .. char .. '-' .. letterId
    newLetterBlock.Name = name

    LetterUtils.createPropOnLetterBlock(
        {
            letterBlock = newLetterBlock,
            propName = LetterUtils.letterBlockPropNames.IsLifted,
            initialValue = false,
            propType = 'BoolValue'
        }
    )

    LetterUtils.createPropOnLetterBlock(
        {
            letterBlock = newLetterBlock,
            propName = LetterUtils.letterBlockPropNames.IsFound,
            initialValue = false,
            propType = 'BoolValue'
        }
    )

    modelClone.Parent = parentFolder
    newLetterBlock.Anchored = false

    LetterUtils.initLetterBlock(
        {
            letterBlock = newLetterBlock,
            char = char,
            -- templateName = 'Stray_normal',
            templateName = 'Stray_available',
            isTextLetter = true,
            letterBlockType = 'StrayLetter'
        }
    )
    return newLetterBlock
end

print('initStraysInRegions++++++++++++++++++++++++++++++++++++++++++++++++')
local function initStraysInRegions(props)
    local parentFolder = props.parentFolder
    local strayRegions = Utils.getByTagInParent({parent = parentFolder, tag = 'StrayRegion'})

    local words = {
        'CAT', --
        'RAT', --
        'BAT', --
        'HAT', --
        'MAT', --
        'SAT' --
        -- "CAT", --
        -- "RAT", --
        -- "BAT", --
        -- "HAT", --
        -- "MAT", --
        -- "SAT" --
    }

    local wordLength = 3
    local requiredLetters = #words * wordLength

    for _, region in ipairs(strayRegions) do
        -- Populate random letter gems
        local strays =
            module.initStraysInRegion(
            {
                parentFolder = parentFolder,
                numBlocks = math.floor(requiredLetters * 1.2),
                words = words,
                region = region,
                onTouchBlock = function()
                end
            }
        )

        for _, stray in ipairs(strays) do
            stray.CanCollide = true

            -- stray.Size = Vector3.new(4, 4, 4)
        end
    end
    --
    --
end
local function initStraysInRegion(props)
    print('initStraysInRegion----------------------------------')
    local numBlocks = props.numBlocks
    local region = props.region
    local words = props.words
    local blockTemplate = props.blockTemplate

    -- populate matrix with letters
    local letterMatrix = {}
    local lettersNotInWords = LetterUtils.getLettersNotInWords(words)
    local totalRows = numBlocks

    for _ = 1, totalRows do
        table.insert(letterMatrix, LetterUtils.getRandomLetter(lettersNotInWords))
    end

    for _, word in ipairs(words) do
        for letterIndex = 1, #word do
            local letter = string.sub(word, letterIndex, letterIndex)
            table.insert(letterMatrix, letter)
        end
    end

    local strays = {}
    for _, char in ipairs(letterMatrix) do
        local parentFolder = props.parentFolder

        local strayProps = {
            blockTemplate = blockTemplate
        }

        local newLetterBlock = createStray(char, parentFolder, strayProps)

        local offsetX = Utils.genRandom(0, region.Size.X) - region.Size.X / 2
        local offsetZ = Utils.genRandom(0, region.Size.Z) - region.Size.Z / 2

        -- local offsetX = Utils.genRandom(0, 20)
        -- local offsetZ = Utils.genRandom(0, 20)
        table.insert(strays, newLetterBlock)
        newLetterBlock.CFrame =
            Utils3.setCFrameFromDesiredEdgeOffset(
            {
                parent = region,
                child = newLetterBlock,
                offsetConfig = {
                    useParentNearEdge = Vector3.new(0, -1, 0),
                    useChildNearEdge = Vector3.new(0, -1, 0),
                    offsetAdder = Vector3.new(offsetX, 0, offsetZ)
                }
            }
        )
    end

    for _, block in ipairs(strays) do
        LetterUtils.createPropOnLetterBlock(
            {
                letterBlock = block,
                propName = 'DestroyOnTouch',
                initialValue = true,
                propType = 'BoolValue'
            }
        )
    end

    return strays
end

module.initStraysInRegion = initStraysInRegion
module.createStray = createStray
module.initStraysInRegions = initStraysInRegions

return module
