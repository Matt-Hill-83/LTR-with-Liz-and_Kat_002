local Sss = game:GetService('ServerScriptService')
local Colors = require(Sss.Source.Constants.Const_02_Colors)

local module = {}

local sector1Config = {
    freezeConveyor = true,
    words = {
        'NAP', --
        'TAP', --
        'RAP', --
        'ZAP' --
    }
}

local sector2Config = {
    words = {
        'CAP', --
        'GAP', --
        'LAP', --
        'MAP' --
    }
}

local sector3Config = {
    words = {
        'VAN', --
        'RAN', --
        'CAN', --
        'AN' --
    }
}

local sector4Config = {
    words = {
        'PAN', --
        'DAN', --
        'FAN', --
        'TAN', --
        'JAN' --
    }
}
local sector5Config = {
    words = {
        'SAT', --
        'RAT', --
        'VAT', --
        'AT' --
    }
}

local sector6Config = {
    words = {
        'CAT', --
        'HAT', --
        'MAT', --
        'PAT' --
    }
}

local sectorConfigs = {
    sector1Config, --
    sector2Config, --
    sector3Config, --
    sector4Config, --
    sector5Config, --
    sector6Config --
}

local hexIslandConfigs = {
    {
        hexNum = 1,
        statueConfigs = {
            Liz = {
                sentence = {'I', 'SEE', 'A', 'CAT'},
                character = 'lizHappy',
                -- songId = '6342102168',
                keyColor = Colors.colors.yellow
            }
        },
        bridgeConfigs = {
            {item = nil},
            {
                item = 'Rink',
                itemConfig = {
                    words = {'NOT', 'CAT'},
                    grabbers = {'NOT', 'CAT'}
                }
            },
            {item = nil}
        }
    },
    {
        hexNum = 2,
        statueConfigs = {
            Kat = {
                sentence = {'NOT', 'A', 'CAT'},
                character = 'katScared',
                songId = '6342102168'
            }
        },
        bridgeConfigs = {
            {item = nil},
            {
                item = 'Rink',
                itemConfig = {
                    words = {'RUN', 'BUN'},
                    grabbers = {'RUN', 'BUN'}
                }
            },
            {item = nil}
        }
    },
    {
        hexNum = 3,
        statueConfigs = {
            Kat = {
                sentence = {'RUN', 'TO', 'THE', 'BUN'},
                character = 'katScared'
                -- songId = '6342102168'
            }
        }
        -- bridgeConfigs = {
        --     {item = nil},
        --     {
        --         item = 'Rink',
        --         itemConfig = {
        --             words = {'SEE', 'CAT'},
        --             grabbers = {'SEE', 'CAT'}
        --         }
        --     },
        --     {item = nil}
        -- }
    }
}

-- Troll = {
--     sentence = {'TROLL', 'NEED', 'GOLD'},
--     character = 'babyTroll04'
--     -- songId = '6338745550'
-- },

module.sectorConfigs = sectorConfigs
module.hexIslandConfigs = hexIslandConfigs

module.targetWords = {
    {word = 'RAT', target = 4, found = 0}, --
    {word = 'CAT', target = 4, found = 0}, --
    {word = 'BAT', target = 4, found = 0}, --
    {word = 'HAT', target = 4, found = 0} --
}

return module
