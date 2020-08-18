Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

Config = {}

Config.MenuItems = {
    [1] = {
        id = 'citizen',
        title = 'Burger',
        icon = '#citizen',
        items = {
            {
                id    = 'givenum',
                title = 'Geef Contact Gegevens',
                icon = '#nummer',
                type = 'client',
                event = 'rs-phone:client:GiveContactDetails',
                shouldClose = true,
            },
            {
                id    = 'getintrunk',
                title = 'Stap in kofferbak',
                icon = '#vehiclekey',
                type = 'client',
                event = 'rs-trunk:client:GetIn',
                shouldClose = true,
            },
            {
                id    = 'cornerselling',
                title = 'Corner Selling',
                icon = '#cornerselling',
                type = 'client',
                event = 'rs-drugs:client:cornerselling',
                shouldClose = true,
            },
            {
                id    = 'togglehotdogsell',
                title = 'Hotdog Verkoop',
                icon = '#cornerselling',
                type = 'client',
                event = 'rs-hotdogjob:client:ToggleSell',
                shouldClose = true,
            },
            {
                id = 'interactions',
                title = 'Interactie',
                icon = '#illegal',
                items = {
                    {
                        id    = 'handcuff',
                        title = 'Boeien',
                        icon = '#general',
                        type = 'client',
                        event = 'police:client:CuffPlayerSoft',
                        shouldClose = true,
                    },
                    {
                        id    = 'playerinvehicle',
                        title = 'Zet in voertuig',
                        icon = '#general',
                        type = 'client',
                        event = 'police:client:PutPlayerInVehicle',
                        shouldClose = true,
                    },
                    {
                        id    = 'playeroutvehicle',
                        title = 'Haal uit voertuig',
                        icon = '#general',
                        type = 'client',
                        event = 'police:client:SetPlayerOutVehicle',
                        shouldClose = true,
                    },
                    {
                        id    = 'stealplayer',
                        title = 'Beroven',
                        icon = '#general',
                        type = 'client',
                        event = 'police:client:RobPlayer',
                        shouldClose = true,
                    },
                    {
                        id    = 'escort',
                        title = 'Kidnappen',
                        icon = '#general',
                        type = 'client',
                        event = 'police:client:KidnapPlayer',
                        shouldClose = true,
                    },
                    {
                        id    = 'escort2',
                        title = 'Escorteren',
                        icon = '#general',
                        type = 'client',
                        event = 'police:client:EscortPlayer',
                        shouldClose = true,
                    },
                    {
                        id    = 'escort554',
                        title = 'Hostage',
                        icon = '#general',
                        type = 'client',
                        event = 'A5:Client:TakeHostage',
                        shouldClose = true,
                    },
                }
            },
        }
    },
    [2] = {
        id = 'general',
        title = 'Algemeen',
        icon = '#general',
        items = {
            {
                id = 'house',
                title = 'Huis Interactie',
                icon = '#house',
                items = {
                    {
                        id    = 'givehousekey',
                        title = 'Geef Huis Sleutel',
                        icon = '#vehiclekey',
                        type = 'client',
                        event = 'rs-houses:client:giveHouseKey',
                        shouldClose = true,
                        items = {},
                    },
                    {
                        id    = 'removehousekey',
                        title = 'Verwijder Huis Sleutel',
                        icon = '#vehiclekey',
                        type = 'client',
                        event = 'rs-houses:client:removeHouseKey',
                        shouldClose = true,
                        items = {},
                    },
                    {
                        id    = 'togglelock',
                        title = 'Toggle Deurslot',
                        icon = '#vehiclekey',
                        type = 'client',
                        event = 'rs-houses:client:toggleDoorlock',
                        shouldClose = true,
                    },
                    {
                        id    = 'decoratehouse',
                        title = 'Decoreer huis',
                        icon = '#vehiclekey',
                        type = 'client',
                        event = 'rs-houses:client:decorate',
                        shouldClose = true,
                    },            
                    {
                        id = 'houseLocations',
                        title = 'Interactie Locaties',
                        icon = '#house',
                        items = {
                            {
                                id    = 'setstash',
                                title = 'Stash Instellen',
                                icon = '#vehiclekey',
                                type = 'client',
                                event = 'rs-houses:client:setLocation',
                                shouldClose = true,
                            },
                            {
                                id    = 'setoutift',
                                title = 'Outfit Instellen',
                                icon = '#vehiclekey',
                                type = 'client',
                                event = 'rs-houses:client:setLocation',
                                shouldClose = true,
                            },
                            {
                                id    = 'setlogout',
                                title = 'Logout Instellen',
                                icon = '#vehiclekey',
                                type = 'client',
                                event = 'rs-houses:client:setLocation',
                                shouldClose = true,
                            },
                        }
                    },
                }
            },
        }
    },
    [3] = {
        id = 'vehicle',
        title = 'Voertuig',
        icon = '#vehicle',
        items = {
            {
                id    = 'vehicledoors',
                title = 'Voertuig Deuren',
                icon = '#vehicledoors',
                items = {
                    {
                        id    = 'door0',
                        title = 'Links Voor',
                        icon = '#leftdoor',
                        type = 'client',
                        event = 'rs-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                    {
                        id    = 'door4',
                        title = 'Motorkap',
                        icon = '#idkaart',
                        type = 'client',
                        event = 'rs-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                    {
                        id    = 'door1',
                        title = 'Rechts Voor',
                        icon = '#rightdoor',
                        type = 'client',
                        event = 'rs-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                    {
                        id    = 'door3',
                        title = 'Rechts Achter',
                        icon = '#rightdoor',
                        type = 'client',
                        event = 'rs-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                    {
                        id    = 'door5',
                        title = 'Kofferbak',
                        icon = '#idkaart',
                        type = 'client',
                        event = 'rs-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                    {
                        id    = 'door2',
                        title = 'Links Achter',
                        icon = '#leftdoor',
                        type = 'client',
                        event = 'rs-radialmenu:client:openDoor',
                        shouldClose = false,
                    },
                }
            },
            {
                id    = 'vehicleextras',
                title = 'Voertuig Extras',
                icon = '#plus',
                items = {
                    {
                        id    = 'extra1',
                        title = 'Extra 1',
                        icon = '#plus',
                        type = 'client',
                        event = 'rs-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra2',
                        title = 'Extra 2',
                        icon = '#plus',
                        type = 'client',
                        event = 'rs-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra3',
                        title = 'Extra 3',
                        icon = '#plus',
                        type = 'client',
                        event = 'rs-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra4',
                        title = 'Extra 4',
                        icon = '#plus',
                        type = 'client',
                        event = 'rs-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra5',
                        title = 'Extra 5',
                        icon = '#plus',
                        type = 'client',
                        event = 'rs-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra6',
                        title = 'Extra 6',
                        icon = '#plus',
                        type = 'client',
                        event = 'rs-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra7',
                        title = 'Extra 7',
                        icon = '#plus',
                        type = 'client',
                        event = 'rs-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra8',
                        title = 'Extra 8',
                        icon = '#plus',
                        type = 'client',
                        event = 'rs-radialmenu:client:setExtra',
                        shouldClose = false,
                    },
                    {
                        id    = 'extra9',
                        title = 'Extra 9',
                        icon = '#plus',
                        type = 'client',
                        event = 'rs-radialmenu:client:setExtra',
                        shouldClose = false,
                    },                                                                                                                  
                }
            },
            {
                id    = 'vehicleseats',
                title = 'Voertuig Stoelen',
                icon = '#vehicledoors',
                items = {
                    {
                        id    = 'door0',
                        title = 'Bestuurder',
                        icon = '#plus',
                        type = 'client',
                        event = 'rs-radialmenu:client:ChangeSeat',
                        shouldClose = false,
                    },
                }
            },
            {
                id    = 'vehicleflip',
                title = 'Voertuig flippen',
                icon = '#flip',
                type = 'client',
                event = 'FlipVehicle',
                shouldClose = true,
            },
        }
    },
    [4] = {
        id = 'jobinteractions',
        title = 'Werk',
        icon = '#work',
        items = {},
    },
}

Config.JobInteractions = {
    ["ambulance"] = {
        {
            id    = 'statuscheck',
            title = 'Onderzoek Persoon',
            icon = '#general',
            type = 'client',
            event = 'hospital:client:CheckStatus',
            shouldClose = true,
        },
        {
            id    = 'treatwounds',
            title = 'Genees Wonden',
            icon = '#general',
            type = 'client',
            event = 'hospital:client:TreatWounds',
            shouldClose = true,
        },
        {
            id    = 'reviveplayer',
            title = 'Help Omhoog',
            icon = '#general',
            type = 'client',
            event = 'hospital:client:RevivePlayer',
            shouldClose = true,
        },
        {
            id    = 'emergencybutton2',
            title = 'Noodknop',
            icon = '#general',
            type = 'client',
            event = 'police:client:SendPoliceEmergencyAlert',
            shouldClose = true,
        },
        {
            id    = 'escort',
            title = 'Escorteren',
            icon = '#general',
            type = 'client',
            event = 'police:client:EscortPlayer',
            shouldClose = true,
        },
        {
            id = 'brancardoptions',
            title = 'Brandcard',
            icon = '#vehicle',
            items = {
                {
                    id    = 'spawnbrancard',
                    title = 'Brancard Plaatsen',
                    icon = '#general',
                    type = 'client',
                    event = 'hospital:client:TakeBrancard',
                    shouldClose = false,
                },
                {
                    id    = 'despawnbrancard',
                    title = 'Brancard Verwijderen',
                    icon = '#general',
                    type = 'client',
                    event = 'hospital:client:RemoveBrancard',
                    shouldClose = false,
                },
            },
        },
    },
    ["taxi"] = {
        {
            id    = 'togglemeter',
            title = 'Show/Hide Meter',
            icon = '#general',
            type = 'client',
            event = 'rs-taxi:client:toggleMeter',
            shouldClose = false,
        },
        {
            id    = 'togglemouse',
            title = 'Start/Stop Meter',
            icon = '#general',
            type = 'client',
            event = 'rs-taxi:client:enableMeter',
            shouldClose = true,
        },
        {
            id    = 'npc_mission',
            title = 'NPC Missie',
            icon = '#general',
            type = 'client',
            event = 'rs-taxi:client:DoTaxiNpc',
            shouldClose = true,
        },
    },
    ["tow"] = {
        {
            id    = 'togglenpc',
            title = 'Toggle NPC',
            icon = '#general',
            type = 'client',
            event = 'jobs:client:ToggleNpc',
            shouldClose = true,
        },
        {
            id    = 'towvehicle',
            title = 'Takel Voertuig',
            icon = '#vehicle',
            type = 'client',
            event = 'rs-tow:client:TowVehicle',
            shouldClose = true,
        },
    },
    ["police"] = {
        {
            id    = 'emergencybutton',
            title = 'Noodknop',
            icon = '#general',
            type = 'client',
            event = 'police:client:SendPoliceEmergencyAlert',
            shouldClose = true,
        },
        {
            id    = 'checkvehstatus',
            title = 'Check Tune Status',
            icon = '#vehiclekey',
            type = 'client',
            event = 'rs-tunerchip:server:TuneStatus',
            shouldClose = true,
        },
        {
            id    = 'resethouse',
            title = 'Reset Huisslot',
            icon = '#vehiclekey',
            type = 'client',
            event = 'rs-houses:client:ResetHouse',
            shouldClose = true,
        },
        {
            id    = 'takedriverlicense',
            title = 'Neem Rijbewijs',
            icon = '#vehicle',
            type = 'client',
            event = 'police:client:SeizeDriverLicense',
            shouldClose = true,
        },
        {
            id = 'policeinteraction',
            title = 'Politie Interactie',
            icon = '#house',
            items = {
                {
                    id    = 'statuscheck',
                    title = 'Onderzoek Persoon',
                    icon = '#general',
                    type = 'client',
                    event = 'hospital:client:CheckStatus',
                    shouldClose = true,
                },
                {
                    id    = 'checkstatus',
                    title = 'Status Check',
                    icon = '#general',
                    type = 'client',
                    event = 'police:client:CheckStatus',
                    shouldClose = true,
                },
                {
                    id    = 'escort',
                    title = 'Escorteren',
                    icon = '#general',
                    type = 'client',
                    event = 'police:client:EscortPlayer',
                    shouldClose = true,
                },
                {
                    id    = 'searchplayer',
                    title = 'Fouilleren',
                    icon = '#general',
                    type = 'client',
                    event = 'police:client:SearchPlayer',
                    shouldClose = true,
                },
                {
                    id    = 'jailplayer',
                    title = 'Gevangenis',
                    icon = '#general',
                    type = 'client',
                    event = 'police:client:JailPlayer',
                    shouldClose = true,
                },
                {
                    id    = 'lockhouse',
                    title = 'Deur vergrendelen',
                    icon = '#general',
                    type = 'client',
                    event = 'rs-houserobbery:client:PoliceLockHouse',
                    shouldClose = true,
                },
            }
        },
        {
            id = 'policeobjects',
            title = 'Objecten',
            icon = '#house',
            items = {
                {
                    id    = 'spawnpion',
                    title = 'Pion',
                    icon = '#vehiclekey',
                    type = 'client',
                    event = 'police:client:spawnCone',
                    shouldClose = false,
                },
                {
                    id    = 'spawnhek',
                    title = 'Hek',
                    icon = '#vehiclekey',
                    type = 'client',
                    event = 'police:client:spawnBarier',
                    shouldClose = false,
                },
                {
                    id    = 'spawnschotten',
                    title = 'Schotten',
                    icon = '#vehiclekey',
                    type = 'client',
                    event = 'police:client:spawnSchotten',
                    shouldClose = false,
                },
                {
                    id    = 'spawntent',
                    title = 'Tent',
                    icon = '#vehiclekey',
                    type = 'client',
                    event = 'police:client:spawnTent',
                    shouldClose = false,
                },
                {
                    id    = 'spawnverlichting',
                    title = 'Verlichting',
                    icon = '#vehiclekey',
                    type = 'client',
                    event = 'police:client:spawnLight',
                    shouldClose = false,
                },
                {
                    id    = 'spikestrip',
                    title = 'Spikestrip Plaatsen',
                    icon = '#vehiclekey',
                    type = 'client',
                    event = 'police:client:SpawnSpikeStrip',
                    shouldClose = false,
                },
                {
                    id    = 'deleteobject',
                    title = 'Object Verwijderen',
                    icon = '#vehiclekey',
                    type = 'client',
                    event = 'police:client:deleteObject',
                    shouldClose = false,
                },
            }
        },
    },
    ["hotdog"] = {
        {
            id    = 'togglesell',
            title = 'Toggle Verkoop',
            icon = '#general',
            type = 'client',
            event = 'rs-hotdogjob:client:ToggleSell',
            shouldClose = true,
        },
    },
}

Config.TrunkClasses = {
    [0]  = { allowed = true, x = 0.0, y = -1.5, z = 0.0 }, --Coupes  
    [1]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Sedans  
    [2]  = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --SUVs  
    [3]  = { allowed = true, x = 0.0, y = -1.5, z = 0.0 }, --Coupes  
    [4]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Muscle  
    [5]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Sports Classics  
    [6]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Sports  
    [7]  = { allowed = true, x = 0.0, y = -2.0, z = 0.0 }, --Super  
    [8]  = { allowed = false, x = 0.0, y = -1.0, z = 0.25 }, --Motorcycles  
    [9]  = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Off-road  
    [10] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Industrial  
    [11] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Utility  
    [12] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Vans  
    [13] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Cycles  
    [14] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Boats  
    [15] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Helicopters  
    [16] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Planes  
    [17] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Service  
    [18] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Emergency  
    [19] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Military  
    [20] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Commercial  
    [21] = { allowed = true, x = 0.0, y = -1.0, z = 0.25 }, --Trains  
}