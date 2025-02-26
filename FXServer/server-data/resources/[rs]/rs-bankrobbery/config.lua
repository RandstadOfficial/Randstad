Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

Config = Config or {}

Config.ItemTiers = 1

Config.MinimumPaletoPolice = 4
Config.MinimumPacificPolice = 6
Config.MinimumFleecaPolice = 4
Config.MinimumThermitePolice = 2
Config.MinimumMazePolice = 4

Config.RewardTypes = {
    [1] = {
        type = "item",
    },
    [2] = {
        type = "money",
        maxAmount = 1000
    }
}

Config.PowerStations = {
    [1] = { -- Big Power Station 1
        coords = {x = 2835.24, y = 1505.68, z = 24.72},
        hit = false,
    },
    [2] = { -- Big Power Station 2
        coords = {x = 2811.76, y = 1500.6, z = 24.72},
        hit = false,
    },
    [3] = { -- Power Station Windmills
        coords = {x = 2137.73, y = 1949.62, z = 93.78},
        hit = false,
    },
    [4] = {
        coords = {x = 708.92, y = 117.49, z = 80.95},
        hit = false,
    },
    [5] = {
        coords = {x = 670.23, y = 128.14, z = 80.95},
        hit = false,
    },
    [6] = {
        coords = {x = 692.17, y = 160.28, z = 80.94},
        hit = false,
    },
    [7] = {
        coords = {x = 2459.16, y = 1460.94, z = 36.2},
        hit = false,
    },
    [8] = {
        coords = {x = 2280.45, y = 2964.83, z = 46.75},
        hit = false,
    },
    [9] = {
        coords = {x = 2059.68, y = 3683.8, z = 34.58},
        hit = false,
    },
    [10] = {
        coords = {x = 2589.5, y = 5057.38, z = 44.91},
        hit = false,
    },
    [11] = {
        coords = {x = 1343.61, y = 6388.13, z = 33.41},
        hit = false,
    },
    [12] = {
        coords = {x = 236.61, y = 6406.1, z = 31.83},
        hit = false,
    },
    [13] = {
        coords = {x = -293.1, y = 6023.54, z = 31.54},
        hit = false,
    },
}

Config.LockerRewards = {
    ["tier1"] = {
        [1] = {item = "goldchain", minAmount = 5, maxAmount = 15},
    },
    ["tier2"] = {
        [1] = {item = "rolex", minAmount = 5, maxAmount = 15},
    },
    ["tier3"] = {
        [1] = {item = "goldbar", minAmount = 1, maxAmount = 2},
    },
}

Config.LockerRewardsPaleto = {
    ["tier1"] = {
        [1] = {item = "goldchain", minAmount = 10, maxAmount = 20},
    },
    ["tier2"] = {
        [1] = {item = "rolex", minAmount = 10, maxAmount = 20},
    },
    ["tier3"] = {
        [1] = {item = "goldbar", minAmount = 2, maxAmount = 4},
    },
}

Config.LockerRewardsPacific = {
    ["tier1"] = {
        [1] = {item = "goldbar", minAmount = 4, maxAmount = 8},
    },
    ["tier2"] = {
        [1] = {item = "goldbar", minAmount = 4, maxAmount = 8},
    },
    ["tier3"] = {
        [1] = {item = "goldbar", minAmount = 4, maxAmount = 8},
    },
}

Config.LockerRewardsMaze = {
    ["tier1"] = {
        [1] = {item = "goldchain", minAmount = 7, maxAmount = 15},
    },
    ["tier2"] = {
        [1] = {item = "rolex", minAmount = 7, maxAmount = 15},
    },
    ["tier3"] = {
        [1] = {item = "goldbar", minAmount = 3, maxAmount = 6},
    },
}

Config.CabinetRewards = {
    ["tier1"] = {
        [1] = {item = "painkillers", maxAmount = 1},
    },
    ["tier2"] = {
        [1] = {item = "phone", maxAmount = 1},
    },
    ["tier3"] = {
        [1] = {item = "bandage", maxAmount = 1},
    },
    ["tier4"] = {
        [1] = {item = "security_card_01", maxAmount = 1},
    },
    ["tier5"] = {
        [1] = {item = "cryptostick", maxAmount = 1},
    },
    ["tier6"] = {
        [1] = {item = "cokebaggy", maxAmount = 1},
    },
    ["tier7"] = {
        [1] = {item = "security_card_02", maxAmount = 1},
    },
}

Config.SmallBanks = {
    [1] = {
        ["label"] = "Lol",
        ["coords"] = {
            ["x"] = 311.15,
            ["y"] = -284.49,
            ["z"] = 54.16,
        },
        ["alarm"] = true,
        ["object"] = GetHashKey("v_ilev_gb_vauldr"),
        ["heading"] = {
            closed = 250.0,
            open = 160.0,
        },
        ["camId"] = 21,
        ["isOpened"] = false,
        ["lockers"] = {
            [1] = {
                x = 311.16, 
                y = -287.71, 
                z = 54.14, 
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [2] = {
                x = 311.86, 
                y = -286.21, 
                z = 54.14, 
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [3] = {
                x = 313.39, 
                y = -289.15, 
                z = 54.14, 
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [4] = {
                x = 311.7, 
                y = -288.45, 
                z = 54.14, 
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [5] = {
                x = 314.23, 
                y = -288.77, 
                z = 54.14, 
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [6] = {
                x = 314.83, 
                y = -287.33, 
                z = 54.14, 
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [7] = {
                x = 315.24, 
                y = -284.85, 
                z = 54.14, 
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [8] = {
                x = 314.08, 
                y = -283.38, 
                z = 54.14, 
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
        },
    },
    [2] = {
        ["label"] = "Legion Square",
        ["coords"] = {
            ["x"] = 146.92,
            ["y"] = -1046.11,
            ["z"] = 29.36,
        },
        ["alarm"] = true,
        ["object"] = GetHashKey("v_ilev_gb_vauldr"),
        ["heading"] = {
            closed = 250.0,
            open = 160.0,
        },
        ["camId"] = 22,
        ["isOpened"] = false,
        ["lockers"] = {
            [1] = {
                x = 149.84, 
                y = -1044.9, 
                z = 29.34,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [2] = {
                x = 151.16, 
                y = -1046.64, 
                z = 29.34,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [3] = {
                x = 147.16, 
                y = -1047.72, 
                z = 29.34,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [4] = {
                x = 146.54, 
                y = -1049.28, 
                z = 29.34,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [5] = {
                x = 146.88, 
                y = -1050.33, 
                z = 29.34,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [6] = {
                x = 150.0, 
                y = -1050.67, 
                z = 29.34,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [7] = {
                x = 149.47, 
                y = -1051.28, 
                z = 29.34,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [8] = {
                x = 150.58, 
                y = -1049.09, 
                z = 29.34,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
        },
    },
    [3] = {
        ["label"] = "Hawick Ave",
        ["coords"] = {
            ["x"] = -353.82,
            ["y"] = -55.37,
            ["z"] = 49.03,
        },
        ["alarm"] = true,
        ["object"] = GetHashKey("v_ilev_gb_vauldr"),
        ["heading"] = {
            closed = 250.0,
            open = 160.0,
        },
        ["camId"] = 23,
        ["isOpened"] = false,
        ["lockers"] = {
            [1] = {
                x = -350.99, 
                y = -54.13, 
                z = 49.01,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [2] = {
                x = -349.53, 
                y = -55.77, 
                z = 49.01,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [3] = {
                x = -353.54, 
                y = -56.94, 
                z = 49.01,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [4] = {
                x = -354.09, 
                y = -58.55, 
                z = 49.01,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [5] = {
                x = -353.81, 
                y = -59.48, 
                z = 49.01,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [6] = {
                x = -349.8, 
                y = -58.3, 
                z = 49.01,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [7] = {
                x = -351.14, 
                y = -60.37, 
                z = 49.01,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [8] = {
                x = -350.4, 
                y = -59.92, 
                z = 49.01,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
        },
    },
    [4] = {
        ["label"] = "Del Perro Blvd",
        ["coords"] = {
            ["x"] = -1210.77,
            ["y"] = -336.57,
            ["z"] = 37.78,
        },
        ["alarm"] = true,
        ["object"] = GetHashKey("v_ilev_gb_vauldr"),
        ["heading"] = {
            closed = 296.863,
            open = 206.863,
        },
        ["camId"] = 24,
        ["isOpened"] = false,
        ["lockers"] = {
            [1] = {
                x = -1209.68, 
                y = -333.65, 
                z = 37.75,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [2] = {
                x = -1207.46, 
                y = -333.77, 
                z = 37.75,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [3] = {
                x = -1209.45, 
                y = -337.47, 
                z = 37.75,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [4] = {
                x = -1208.65, 
                y = -339.06, 
                z = 37.75,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [5] = {
                x = -1207.75, 
                y = -339.42, 
                z = 37.75,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [6] = {
                x = -1205.28,
                y = -338.14, 
                z = 37.75,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [7] = {
                x = -1205.08, 
                y = -337.28, 
                z = 37.75,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [8] = {
                x = -1205.92, 
                y = -335.75, 
                z = 37.75,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
        },
    },
    [5] = {
        ["label"] = "Great Ocean Hwy",
        ["coords"] = {
            ["x"] = -2956.55,
            ["y"] = 481.74,
            ["z"] = 15.69,
        },
        ["alarm"] = true,
        ["object"] = GetHashKey("hei_prop_heist_sec_door"),
        ["heading"] = {
            closed = 357.542,
            open = 267.542,
        },
        ["camId"] = 25,
        ["isOpened"] = false,
        ["lockers"] = {
            [1] = {
                x = -2958.54, 
                y = 484.1, 
                z = 15.67,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [2] = {
                x = -2957.3, 
                y = 485.95, 
                z = 15.67,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [3] = {
                x = -2955.09, 
                y = 482.43, 
                z = 15.67,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [4] = {
                x = -2953.26, 
                y = 482.42, 
                z = 15.67,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [5] = {
                x = -2952.63, 
                y = 483.09, 
                z = 15.67,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [6] = {
                x = -2952.45, 
                y = 485.66, 
                z = 15.67,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [7] = {
                x = -2953.13, 
                y = 486.26, 
                z = 15.67,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [8] = {
                x = -2954.98, 
                y = 486.37, 
                z = 15.67,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
        },
    },
}

Config.BigBanks = {
    ["paleto"] = {
        ["label"] = "Blaine County Savings Bank",
        ["coords"] = {
            ["x"] = -105.61,
            ["y"] = 6472.03,
            ["z"] = 31.62,
        },
        ["alarm"] = true,
        ["object"] = -1185205679,
        ["heading"] = {
            closed = 45.45,
            open = 130.45,
        },
        ["thermite"] = {
            [1] = {
                ["x"] = -106.11,
                ["y"] = 6475.36,
                ["z"] = 31.62,
                ["isOpened"] = false,
                ["doorId"] = 80,
            },
        },
        ["camId"] = 26,
        ["isOpened"] = false,
        ["lockers"] = {
            [1] = {
                x = -107.4, 
                y = 6473.87, 
                z = 31.62,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [2] = {
                x = -107.66, 
                y = 6475.61, 
                z = 31.62,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [3] = {
                x = -103.52, 
                y = 6475.03, 
                z = 31.66,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [4] = {
                x = -102.3, 
                y = 6476.13, 
                z = 31.66,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [5] = {
                x = -102.43, 
                y = 6477.45, 
                z = 31.67,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [6] = {
                x = -103.97, 
                y = 6478.97, 
                z = 31.62,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [7] = {
                x = -105.39, 
                y = 6479.19, 
                z = 31.67,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [8] = {
                x = -106.57, 
                y = 6478.01, 
                z = 31.62,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
        },
    },
    ["pacific"] = {
        ["label"] = "Pacific Standard",
        ["coords"] = {
            [1] = {
                ["x"] = 261.95,
                ["y"] = 223.11,
                ["z"] = 106.28,
            },
            [2] = {
                ["x"] = 253.25,
                ["y"] = 228.44,
                ["z"] = 101.68,
            },
        },
        ["alarm"] = true,
        ["object"] = 961976194,
        ["heading"] = {
            closed = 160.00001,
            open = 70.00001,
        },
        ["thermite"] = {
            [1] = {
                ["x"] = 252.55,
                ["y"] = 221.15,
                ["z"] = 101.68,
                ["isOpened"] = false,
                ["doorId"] = 72,
            },
            [2] = {
                ["x"] = 261.15,
                ["y"] = 215.21,
                ["z"] = 101.68,
                ["isOpened"] = false,
                ["doorId"] = 73,
            },
        },
        ["camId"] = 26,
        ["isOpened"] = false,
        ["lockers"] = {
            [1] = {
                x = 258.57, 
                y = 218.36, 
                z = 101.68,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [2] = {
                x = 260.82, 
                y = 217.62, 
                z = 101.68,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [3] = {
                x = 259.33, 
                y = 213.76, 
                z = 101.68,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [4] = {
                x = 257.09, 
                y = 214.55, 
                z = 101.68,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [5] = {
                x = 263.7, 
                y = 216.48, 
                z = 101.68,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [6] = {
                x = 265.81, 
                y = 215.81, 
                z = 101.68,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [7] = {
                x = 266.43, 
                y = 214.37, 
                z = 101.68,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [8] = {
                x = 265.71, 
                y = 212.49, 
                z = 101.68,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [9] = {
                x = 264.24, 
                y = 211.92, 
                z = 101.68,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [10] = {
                x = 262.21, 
                y = 212.67, 
                z = 101.68,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
        },
    },
    ["maze"] = {
        ["label"] = "Maze Bank",
        ["coords"] = {
            ["x"] = -1303.45,
            ["y"] = -816.64,
            ["z"] = 17.14,
        },
        ["alarm"] = true,
        ["object"] = GetHashKey("maze_v_ilev_bk_vaultdoor"),
        ["heading"] = {
            closed = 37.0,
            open = 230.0,
        },
        ["explosive"] = {
                ["x"] = -1308.32,
                ["y"] = -813.96,
                ["z"] = 17.14,
                ["isOpened"] = false,
                ["doorId"] = 116,
        },
        ["camId"] = 35,
        ["isOpened"] = false,
        ["lockers"] = {
            [1] = {
                x = -1310.31, 
                y = -813.69, 
                z = 17.14,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [2] = {
                x = -1311.13,
                y = -812.59, 
                z = 17.14,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [3] = {
                x = -1311.43, 
                y = -811.23, 
                z = 17.14,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [4] = {
                x = -1310.4, 
                y = -810.48, 
                z = 17.14,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [5] = {
                x = -1309.35, 
                y = -809.69, 
                z = 17.14,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [6] = {
                x = -1307.27, 
                y = -811.43, 
                z = 17.14,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [7] = {
                x = -1308.15, 
                y = -810.3, 
                z = 17.14,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
        },
        ["cabinets"] = {
            [1] = {
                x = -1294.61, 
                y = -825.55, 
                z = 17.14,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [2] = {
                x = -1291.45, 
                y = -825.43, 
                z = 17.14,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [3] = {
                x = -1301.02, 
                y = -830.36, 
                z = 17.14,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [4] = {
                x = -1311.25, 
                y = -819.85, 
                z = 17.14,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [5] = {
                x = -1313.11, 
                y = -822.32, 
                z = 17.14,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [6] = {
                x = -1302.08, 
                y = -831.06, 
                z = 17.14,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
            [7] = {
                x = -1293.62, 
                y = -824.81, 
                z = 17.14,
                ["isBusy"] = false,
                ["isOpened"] = false,
            },
        },
    },
}

Config.MaleNoHandshoes = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = true,
    [14] = true,
    [15] = true,
    [18] = true,
    [26] = true,
    [52] = true,
    [53] = true,
    [54] = true,
    [55] = true,
    [56] = true,
    [57] = true,
    [58] = true,
    [59] = true,
    [60] = true,
    [61] = true,
    [62] = true,
    [112] = true,
    [113] = true,
    [114] = true,
    [118] = true,
    [125] = true,
    [132] = true,
}

Config.FemaleNoHandshoes = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = true,
    [14] = true,
    [15] = true,
    [19] = true,
    [59] = true,
    [60] = true,
    [61] = true,
    [62] = true,
    [63] = true,
    [64] = true,
    [65] = true,
    [66] = true,
    [67] = true,
    [68] = true,
    [69] = true,
    [70] = true,
    [71] = true,
    [129] = true,
    [130] = true,
    [131] = true,
    [135] = true,
    [142] = true,
    [149] = true,
    [153] = true,
    [157] = true,
    [161] = true,
    [165] = true,
}