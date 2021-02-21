local Sss = game:GetService('ServerScriptService')

local Const4 = require(Sss.Source.Constants.Const_04_Characters)
local Utils = require(Sss.Source.Utils.U001GeneralUtils)

local LetterUtils = require(Sss.Source.Utils.U004LetterUtils)

local module = {}

local function styleGems(items)
    for _, block in ipairs(items) do
        LetterUtils.applyStyleFromTemplate({targetLetterBlock = block, templateName = 'Grabber_normal'})
    end

    for _, block in ipairs(items) do
        if block.IsFound.Value == true then
            LetterUtils.applyStyleFromTemplate({targetLetterBlock = block, templateName = 'Grabber_found'})
        end
    end
end

local function sentenceComplete(touchedBlock)
    print('touchedBlock.ParentStatue.Value' .. ' - start')
    print(touchedBlock.ParentStatue.Value)
    local parentStatueGate = touchedBlock:FindFirstAncestor('StatueGate')
    -- local parentStatueGate = touchedBlock:FindFirstAncestor(touchedBlock.ParentStatue.Value)
    print('parentStatueGate' .. ' - start')
    print(parentStatueGate)

    local keyWalls = Utils.getDescendantsByName(parentStatueGate, 'KeyWall')
    for _, keyWall in ipairs(keyWalls) do
        if keyWall then
            LetterUtils.styleImageLabelsInBlock(keyWall, {Visible = false})
            keyWall.CanCollide = false
            keyWall.Transparency = 1
        end
    end
    wait(10)
    for _, keyWall in ipairs(keyWalls) do
        if keyWall then
            LetterUtils.styleImageLabelsInBlock(keyWall, {Visible = false})
            keyWall.CanCollide = true
            keyWall.Transparency = 0.8
        end
    end

    local allWords = module.getAllWords(touchedBlock)

    for _, word in ipairs(allWords) do
        word.PrimaryPart.IsFound.Value = false

        LetterUtils.applyStyleFromTemplate(
            {
                targetLetterBlock = word.PrimaryPart,
                templateName = 'Stray_normal'
            }
        )

        LetterUtils.styleGemFromTemplate(
            {
                targetLetterBlock = word.PrimaryPart,
                templateName = 'Gem_pink'
            }
        )
    end
end

local function wordFound(tool, touchedBlock)
    touchedBlock.IsFound.Value = true

    LetterUtils.applyStyleFromTemplate(
        {
            targetLetterBlock = touchedBlock,
            templateName = 'Stray_available'
        }
    )

    LetterUtils.styleGemFromTemplate(
        {
            targetLetterBlock = touchedBlock,
            templateName = 'Gem_yellow'
        }
    )

    local targetWord = touchedBlock.Character.Value

    local function destroyParts()
        local explosionSound = '515938718'
        Utils.playSound(explosionSound, 0.5)

        local fireSound = '5207654419'
        local currentWord2 = Const4.wordConfigs[targetWord]
        if currentWord2 then
            local soundId = currentWord2.soundId or fireSound
            Utils.playSound(soundId)
        end

        tool:Destroy()
    end
    delay(0, destroyParts)
    -- delay(0.5, destroyParts)

    local allWords = module.getAllWords(touchedBlock)
    local allFound = true

    for _, word in ipairs(allWords) do
        if word.PrimaryPart.IsFound.Value == false then
            allFound = false
            break
        end
    end

    if allFound then
        sentenceComplete(touchedBlock)
    end
end

function module.getAllWords(touchedBlock)
    return touchedBlock.Parent.Parent:getChildren()
end

local function partTouched(touchedBlock, player)
    local tool = Utils.getActiveToolByToolType(player, 'LetterGemTool')
    if not tool then
        return
    end
    if touchedBlock.IsFound.Value == true then
        return
    end
    local match = touchedBlock.Character.Value == tool.Handle.KeyName.Value

    if match then
        module.wordFound(tool, touchedBlock)
    --
    end

    -- module.styleLetterGrabberBlocks(tool)
end

module.partTouched = partTouched
module.wordFound = wordFound
module.styleGems = styleGems
return module
