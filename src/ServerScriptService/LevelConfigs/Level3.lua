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

local sectorConfigs = {
    sector1Config --
}

local hexIslandConfigs = {
    {
        hexNum = 1,
        statueConfigs = {},
        bridgeConfigs = {
            {item = nil},
            {
                item = 'Rink',
                itemConfig = {
                    grabbers = {'CAT'}
                }
            },
            {item = nil},
            {item = nil},
            {
                item = 'Rink',
                itemConfig = {
                    grabbers = {'BAT'}
                }
            },
            {item = nil}
        }
    },
    {
        hexNum = 2,
        bridgeConfigs = {
            {item = nil},
            {item = nil},
            {item = nil},
            {item = nil},
            {
                item = 'Rink',
                itemConfig = {
                    grabbers = {'RAT'}
                }
            },
            {item = nil}
        }
    },
    {
        hexNum = 3,
        bridgeConfigs = {
            {item = nil},
            {item = nil},
            {item = nil},
            {item = nil},
            {
                item = 'Rink',
                itemConfig = {
                    grabbers = {'SAT'}
                },
                {item = nil}
            }
        }
    },
    {
        hexNum = 4,
        bridgeConfigs = {
            {item = nil},
            {
                item = 'Rink',
                itemConfig = {
                    grabbers = {'PAT'}
                    -- words = {'CAT', 'RAT'}
                }
            },
            {item = nil},
            {item = nil},
            {
                item = 'Rink',
                itemConfig = {
                    grabbers = {'CAT'}
                }
            },
            {item = nil}
        }
    },
    {
        hexNum = 5,
        bridgeConfigs = {
            {item = nil},
            {item = nil},
            {item = nil},
            {item = nil},
            {
                item = 'Rink',
                itemConfig = {
                    grabbers = {'MAT'}
                }
            },
            {item = nil}
        }
    },
    {
        hexNum = 6,
        bridgeConfigs = {
            {item = nil},
            {
                item = 'Rink',
                itemConfig = {
                    grabbers = {'PAT'}
                }
            },
            {item = nil},
            {item = nil},
            {
                item = 'Rink',
                itemConfig = {
                    grabbers = {'CAT'}
                },
                {item = nil}
            }
        }
    }
}

module.sectorConfigs = sectorConfigs
module.hexIslandConfigs = hexIslandConfigs

module.targetWords = {
    {word = 'RAT', target = 4, found = 0}, --
    {word = 'CAT', target = 4, found = 0}, --
    {word = 'BAT', target = 4, found = 0}, --
    {word = 'HAT', target = 4, found = 0} --
}

return module
