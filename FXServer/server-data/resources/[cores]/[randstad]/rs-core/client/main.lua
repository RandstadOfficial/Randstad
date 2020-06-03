RSCore = {}
RSCore.PlayerData = {}
RSCore.Config = RSConfig
RSCore.Shared = RSShared
RSCore.ServerCallbacks = {}

isLoggedIn = false

function GetCoreObject()
	return RSCore
end

RegisterNetEvent('RSCore:GetObject')
AddEventHandler('RSCore:GetObject', function(cb)
	cb(GetCoreObject())
end)

RegisterNetEvent('RSCore:Client:OnPlayerLoaded')
AddEventHandler('RSCore:Client:OnPlayerLoaded', function()
	ShutdownLoadingScreenNui()
	isLoggedIn = true
end)

RegisterNetEvent('RSCore:Client:OnPlayerUnload')
AddEventHandler('RSCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)
