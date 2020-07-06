Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Config = {}

Config.MinZOffset = 45

Config.MinimumHouseRobberyPolice = 3

Config.MinimumTime = 22
Config.MaximumTime = 5

Config.Rewards = {
    [1] = {
        ["cabin"] = {
            "plastic",
            "diamond_ring",
            "goldchain",
        },
        ["kitchen"] = {
            "tosti",
            "sandwich",
            "goldchain",
        },
        ["chest"] = {
            "plastic",
            "rolex",
            "diamond_ring",
            "goldchain",
        },
    },
    [3] = {
        ["cabin"] = {
            "plastic",
            "diamond_ring",
            "goldchain",
        },
        ["kitchen"] = {
            "tosti",
            "sandwich",
            "goldchain",
        },
        ["chest"] = {
            "plastic",
            "rolex",
            "diamond_ring",
            "goldchain",
        },
        ["safe"] = {
            "plastic",
            "rolex",
            "diamond_ring",
            "goldchain",
            "goldbar"
        },
        ["nightstand"] = {
            "rolex",
            "diamond_ring",
            "goldchain"
        },
    }
}

Config.Houses = {
    ["smallhouse1"] = { 
        ["coords"] = {
            ["x"] = -1678.29,
            ["y"] = -401.25,
            ["z"] = 47.52,
            ["h"] = 226.5,
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Keuken kastjes doorzoeken"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kist doorzoeken"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Nachtkastje doorzoeken"
            },
        }
    },
    ["smallhouse2"] = {
        ["coords"] = {
            ["x"] = 67.42,
            ["y"] = -103.67,
            ["z"] = 58.65,
            ["h"] = 71.5,
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Keuken kastjes doorzoeken"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kist doorzoeken"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Nachtkastje doorzoeken"
            },
        }
    },
    ["smallhouse3"] = {
        ["coords"] = {
            ["x"] = 952.83,
            ["y"] = -252.47,
            ["z"] = 67.96,
            ["h"] = 237.6,
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Keuken kastjes doorzoeken"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kist doorzoeken"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Nachtkastje doorzoeken"
            },
        }
    },
    ["smallhouse4"] = {
        ["coords"] = {
            ["x"] = 1250.95,
            ["y"] = -620.27,
            ["z"] = 69.57,
            ["h"] = 28.2,
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Keuken kastjes doorzoeken"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kist doorzoeken"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Nachtkastje doorzoeken"
            },
        }
    },
    ["smallhouse5"] = {
        ["coords"] = {
            ["x"] = 148.78, 
            ["y"] = -1904.50, 
            ["z"] = 23.53, 
            ["h"] = 157.6
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Keuken kastjes doorzoeken"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kist doorzoeken"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Nachtkastje doorzoeken"
            },
        }
    },
    ["smallhouse6"] = {
        ["coords"] = {
            ["x"] = -50.32, 
            ["y"] = -1783.31, 
            ["z"] = 28.30, 
            ["h"] = 315.5
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Keuken kastjes doorzoeken"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kist doorzoeken"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Nachtkastje doorzoeken"
            },
        }
    },
    ["smallhouse7"] = {
        ["coords"] = {
            ["x"] = 454.90, 
            ["y"] = -1580.25, 
            ["z"] = 32.82, 
            ["h"] = 138.8
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Keuken kastjes doorzoeken"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kist doorzoeken"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Nachtkastje doorzoeken"
            },
        }
    },
    ["smallhouse8"] = { 
        ["coords"] = {
            ["x"] = 1010.41, 
            ["y"] = -423.39, 
            ["z"] = 65.34, 
            ["h"] = 133.5
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Keuken kastjes doorzoeken"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kist doorzoeken"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Nachtkastje doorzoeken"
            },
        }
    },
    ["smallhouse9"] = { 
        ["coords"] = {
            ["x"] = 1358.40, 
            ["y"] = -1752.18, 
            ["z"] = 64.45, 
            ["h"] = 281.1
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Keuken kastjes doorzoeken"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kist doorzoeken"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Nachtkastje doorzoeken"
            },
        }
    },
    ["smallhouse10"] = {
        ["coords"] = {
            ["x"] = 514.37, 
            ["y"] = -1780.92, 
            ["z"] = 28.91, 
            ["h"] = 269.7
        },
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 3.1,
                    ["y"] = -4.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -3.5,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 0.9,
                    ["y"] = -6.3,
                    ["z"] = 2.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Keuken kastjes doorzoeken"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = 9.3,
                    ["y"] = -1.3,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kist doorzoeken"
            },
            [5] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 5.85,
                    ["y"] = 2.6,
                    ["z"] = 2.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Nachtkastje doorzoeken"
            },
        }
    },
    ["mansion1"] = {
        ["coords"] = {
            ["x"] = -1899.16, 
            ["y"] = 132.44, 
            ["z"] = 81.98, 
            ["h"] = 126.8
        },
        ["opened"] = false,
        ["tier"] = 3,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -5.18,
                    ["y"] = -2.24,
                    ["z"] = 5.9,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -4.78,
                    ["y"] = 4.29,
                    ["z"] = 5.9,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 9.74,
                    ["y"] = 5.09,
                    ["z"] = 1.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Keuken kastjes doorzoeken"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = -4.22,
                    ["y"] = -7.55,
                    ["z"] = 5.2,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kist doorzoeken"
            },
            [5] = {
                ["type"] = "nightstand",
                ["coords"] = {
                    ["x"] = -9.41,
                    ["y"] = 5.3,
                    ["z"] = 5.2,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Nachtkastje doorzoeken"
            },
            [6] = {
                ["type"] = "safe",
                ["coords"] = {
                    ["x"] = -7.2,
                    ["y"] = -0.93,
                    ["z"] = 5.2,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kluis doorzoeken"
            },
            [7] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 1.42,
                    ["y"] = -11.11,
                    ["z"] = 5.9,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [8] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -0.19,
                    ["y"] = -1.79,
                    ["z"] = 1.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [9] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -7.82,
                    ["y"] = 0.95,
                    ["z"] = 1.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
        }
    },
    ["mansion2"] = {
        ["coords"] = {
            ["x"] = -340.31, 
            ["y"] = 668.76, 
            ["z"] = 172.78, 
            ["h"] = 74.5,
        },
        ["opened"] = false,
        ["tier"] = 3,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -5.18,
                    ["y"] = -2.24,
                    ["z"] = 5.9,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -4.78,
                    ["y"] = 4.29,
                    ["z"] = 5.9,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 9.74,
                    ["y"] = 5.09,
                    ["z"] = 1.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Keuken kastjes doorzoeken"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = -4.22,
                    ["y"] = -7.55,
                    ["z"] = 5.2,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kist doorzoeken"
            },
            [5] = {
                ["type"] = "nightstand",
                ["coords"] = {
                    ["x"] = -9.41,
                    ["y"] = 5.3,
                    ["z"] = 5.2,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Nachtkastje doorzoeken"
            },
            [6] = {
                ["type"] = "safe",
                ["coords"] = {
                    ["x"] = -7.2,
                    ["y"] = -0.93,
                    ["z"] = 5.2,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kluis doorzoeken"
            },
            [7] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 1.42,
                    ["y"] = -11.11,
                    ["z"] = 5.9,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [8] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -0.19,
                    ["y"] = -1.79,
                    ["z"] = 1.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [9] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -7.82,
                    ["y"] = 0.95,
                    ["z"] = 1.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
        }
    },
    ["mansion3"] = {
        ["coords"] = {
            ["x"] = -824.74, 
            ["y"] = 421.99, 
            ["z"] = 92.13, 
            ["h"] = 185.1,
        },
        ["opened"] = false,
        ["tier"] = 3,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -5.18,
                    ["y"] = -2.24,
                    ["z"] = 5.9,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -4.78,
                    ["y"] = 4.29,
                    ["z"] = 5.9,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 9.74,
                    ["y"] = 5.09,
                    ["z"] = 1.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Keuken kastjes doorzoeken"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = -4.22,
                    ["y"] = -7.55,
                    ["z"] = 5.2,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kist doorzoeken"
            },
            [5] = {
                ["type"] = "nightstand",
                ["coords"] = {
                    ["x"] = -9.41,
                    ["y"] = 5.3,
                    ["z"] = 5.2,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Nachtkastje doorzoeken"
            },
            [6] = {
                ["type"] = "safe",
                ["coords"] = {
                    ["x"] = -7.2,
                    ["y"] = -0.93,
                    ["z"] = 5.2,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kluis doorzoeken"
            },
            [7] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 1.42,
                    ["y"] = -11.11,
                    ["z"] = 5.9,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [8] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -0.19,
                    ["y"] = -1.79,
                    ["z"] = 1.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [9] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -7.82,
                    ["y"] = 0.95,
                    ["z"] = 1.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
        }
    },
    ["mansion4"] = {
        ["coords"] = {
            ["x"] = -1031.26, 
            ["y"] = -902.99, 
            ["z"] = 3.69, 
            ["h"] = 213.5,
        },
        ["opened"] = false,
        ["tier"] = 3,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -5.18,
                    ["y"] = -2.24,
                    ["z"] = 5.9,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -4.78,
                    ["y"] = 4.29,
                    ["z"] = 5.9,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 9.74,
                    ["y"] = 5.09,
                    ["z"] = 1.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Keuken kastjes doorzoeken"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = -4.22,
                    ["y"] = -7.55,
                    ["z"] = 5.2,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kist doorzoeken"
            },
            [5] = {
                ["type"] = "nightstand",
                ["coords"] = {
                    ["x"] = -9.41,
                    ["y"] = 5.3,
                    ["z"] = 5.2,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Nachtkastje doorzoeken"
            },
            [6] = {
                ["type"] = "safe",
                ["coords"] = {
                    ["x"] = -7.2,
                    ["y"] = -0.93,
                    ["z"] = 5.2,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kluis doorzoeken"
            },
            [7] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 1.42,
                    ["y"] = -11.11,
                    ["z"] = 5.9,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [8] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -0.19,
                    ["y"] = -1.79,
                    ["z"] = 1.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [9] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -7.82,
                    ["y"] = 0.95,
                    ["z"] = 1.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
        }
    },
    ["mansion5"] = {
        ["coords"] = {
            ["x"] = -902.18, 
            ["y"] = 191.56, 
            ["z"] = 69.45, 
            ["h"] = 271.1,
        },
        ["opened"] = false,
        ["tier"] = 3,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -5.18,
                    ["y"] = -2.24,
                    ["z"] = 5.9,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -4.78,
                    ["y"] = 4.29,
                    ["z"] = 5.9,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 9.74,
                    ["y"] = 5.09,
                    ["z"] = 1.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Keuken kastjes doorzoeken"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = -4.22,
                    ["y"] = -7.55,
                    ["z"] = 5.2,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kist doorzoeken"
            },
            [5] = {
                ["type"] = "nightstand",
                ["coords"] = {
                    ["x"] = -9.41,
                    ["y"] = 5.3,
                    ["z"] = 5.2,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Nachtkastje doorzoeken"
            },
            [6] = {
                ["type"] = "safe",
                ["coords"] = {
                    ["x"] = -7.2,
                    ["y"] = -0.93,
                    ["z"] = 5.2,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kluis doorzoeken"
            },
            [7] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 1.42,
                    ["y"] = -11.11,
                    ["z"] = 5.9,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [8] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -0.19,
                    ["y"] = -1.79,
                    ["z"] = 1.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [9] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -7.82,
                    ["y"] = 0.95,
                    ["z"] = 1.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
        }
    },
    ["mansion6"] = {
        ["coords"] = {
            ["x"] = -418.10, 
            ["y"] = 568.71, 
            ["z"] = 125.48, 
            ["h"] = 329.8,
        },
        ["opened"] = false,
        ["tier"] = 3,
        ["furniture"] = {
            [1] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -5.18,
                    ["y"] = -2.24,
                    ["z"] = 5.9,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [2] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -4.78,
                    ["y"] = 4.29,
                    ["z"] = 5.9,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [3] = {
                ["type"] = "kitchen",
                ["coords"] = {
                    ["x"] = 9.74,
                    ["y"] = 5.09,
                    ["z"] = 1.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Keuken kastjes doorzoeken"
            },
            [4] = {
                ["type"] = "chest",
                ["coords"] = {
                    ["x"] = -4.22,
                    ["y"] = -7.55,
                    ["z"] = 5.2,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kist doorzoeken"
            },
            [5] = {
                ["type"] = "nightstand",
                ["coords"] = {
                    ["x"] = -9.41,
                    ["y"] = 5.3,
                    ["z"] = 5.2,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Nachtkastje doorzoeken"
            },
            [6] = {
                ["type"] = "safe",
                ["coords"] = {
                    ["x"] = -7.2,
                    ["y"] = -0.93,
                    ["z"] = 5.2,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kluis doorzoeken"
            },
            [7] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = 1.42,
                    ["y"] = -11.11,
                    ["z"] = 5.9,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [8] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -0.19,
                    ["y"] = -1.79,
                    ["z"] = 1.5,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
            [9] = {
                ["type"] = "cabin",
                ["coords"] = {
                    ["x"] = -7.82,
                    ["y"] = 0.95,
                    ["z"] = 1.0,
                },
                ["searched"] = false,
                ["isBusy"] = false,
                ["text"] = "Kastje doorzoeken"
            },
        }
    }       
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
    [16] = true,
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