RSCore = {}
RSCore.Config = RSConfig
RSCore.Shared = RSShared
RSCore.ServerCallbacks = {}
RSCore.UseableItems = {}

function GetCoreObject()
	return RSCore
end

RegisterServerEvent('RSCore:GetObject')
AddEventHandler('RSCore:GetObject', function(cb)
	cb(GetCoreObject())
end)