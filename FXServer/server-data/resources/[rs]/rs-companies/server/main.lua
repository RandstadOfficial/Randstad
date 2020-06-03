RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

Citizen.CreateThread(function()
    RSCore.Functions.ExecuteSql(false, "SELECT * FROM `companies`", function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                Config.Companies[v.name] = {
                    name = v.name,
                    label = v.label,
                    employees = v.employees ~= nil and json.decode(v.employees) or {},
                    owner = v.owner,
                    money = v.money,
                }
            end
        end
        TriggerClientEvent("rs-companies:client:setCompanies", -1, Config.Companies)
    end)
end)

RegisterServerEvent('rs-companies:server:loadCompanies')
AddEventHandler('rs-companies:server:loadCompanies', function()
    local src = source
    TriggerClientEvent("rs-companies:client:setCompanies", src, Config.Companies)
end)

RegisterServerEvent('rs-companies:server:createCompany')
AddEventHandler('rs-companies:server:createCompany', function(name)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local bankAmount = Player.PlayerData.money["bank"]
    local cashAmount = Player.PlayerData.money["cash"]
    if cashAmount >= Config.CompanyPrice or bankAmount >= Config.CompanyPrice then
        if name ~= nil then 
            local companyLabel = escapeSqli(name)
            local companyName = escapeSqli(name:gsub("%s+", ""):lower())
            if companyName ~= "" then
                if IsNameAvailable(companyName) then
                    if cashAmount >= Config.CompanyPrice then
                        Player.Functions.RemoveMoney("cash", Config.CompanyPrice, "company-created")
                        RSCore.Functions.ExecuteSql(false, "INSERT INTO `companies` (`name`, `label`, `owner`) VALUES ('"..companyName.."', '"..companyLabel.."', '"..Player.PlayerData.citizenid.."')")
                        Config.Companies[companyName] = {
                            name = companyName,
                            label = name,
                            employees = {},
                            owner = Player.PlayerData.citizenid,
                            money = 0,
                        }
                        TriggerClientEvent("rs-companies:client:setCompanies", -1, Config.Companies)
                        TriggerClientEvent('RSCore:Notify', src, "Gefeliciteerd, je bent trotse eigenaar van: "..companyLabel)
                    else
                        Player.Functions.RemoveMoney("bank", Config.CompanyPrice, "company-created")
                        RSCore.Functions.ExecuteSql(false, "INSERT INTO `companies` (`name`, `label`, `owner`) VALUES ('"..companyName.."', '"..companyLabel.."', '"..Player.PlayerData.citizenid.."')")
                        Config.Companies[companyName] = {
                            name = companyName,
                            label = name,
                            employees = {},
                            owner = Player.PlayerData.citizenid,
                            money = 0,
                        }
                        TriggerClientEvent("rs-companies:client:setCompanies", -1, Config.Companies)
                        TriggerClientEvent('RSCore:Notify', src, "Gefeliciteerd, je bent trotse eigenaar van: "..companyLabel)
                    end
                else
                    TriggerClientEvent('RSCore:Notify', src, 'De naam: ' .. companyLabel .. ' is bezet..', 'error', 4000)
                end
            else
                TriggerClientEvent('RSCore:Notify', src, 'Naam mag niet leeg zijn..', 'error', 4000)
            end
        else
            TriggerClientEvent('RSCore:Notify', src, 'Naam mag niet leeg zijn..', 'error', 4000)
        end
    else
        TriggerClientEvent('RSCore:Notify', src, 'Je hebt niet genoeg geld..', 'error', 4000)
    end
end)

RegisterServerEvent('rs-companies:server:removeCompany')
AddEventHandler('rs-companies:server:removeCompany', function(companyName)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    if companyName ~= nil then 
        if IsCompanyOwner(companyName, Player.PlayerData.citizenid) then
            companyLabel = Config.Companies[companyName].label
            RSCore.Functions.ExecuteSql(true, "DELETE FROM `companies` WHERE `name` = '"..escapeSqli(companyName).."'")
            Config.Companies[companyName] = nil
            TriggerClientEvent("rs-companies:client:setCompanies", -1, Config.Companies)
            TriggerClientEvent("rs-phone:client:setupCompanies", src)
            TriggerClientEvent("rs-phone:client:InPhoneNotify", src, "Bedrijven", "success", "Je hebt " .. companyLabel .. " verwijderd!")
        else
            TriggerClientEvent('RSCore:Notify', src, 'Je bent geen eigenaar van dit bedrijf..', 'error', 4000)
        end
    else
        TriggerClientEvent('RSCore:Notify', src, 'Naam mag niet leeg zijn..', 'error', 4000)
    end
end)

RegisterServerEvent('rs-companies:server:quitCompany')
AddEventHandler('rs-companies:server:quitCompany', function(companyName)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    if companyName ~= nil then 
        if IsEmployee(companyName, Player.PlayerData.citizenid) then
            companyLabel = Config.Companies[companyName].label
            Config.Companies[companyName].employees[Player.PlayerData.citizenid] = nil

            TriggerClientEvent("rs-companies:client:setCompanies", -1, Config.Companies)
            TriggerClientEvent("rs-phone:client:setupCompanies", src)
            TriggerClientEvent("rs-phone:client:InPhoneNotify", src, "Bedrijven", "success", "Je hebt ontslag genomen bij" .. companyLabel .. "!")

            local updatedEmployees = {}
            for employee, info in pairs(Config.Companies[companyName].employees) do
                updatedEmployees[employee] = info
            end
            RSCore.Functions.ExecuteSql(false, "UPDATE `companies` SET `employees` = '"..json.encode(updatedEmployees).."' WHERE `name` = '"..escapeSqli(companyName).."'")
        else
            TriggerClientEvent('RSCore:Notify', src, 'Je bent geen eigenaar van dit bedrijf..', 'error', 4000)
        end
    else
        TriggerClientEvent('RSCore:Notify', src, 'Naam mag niet leeg zijn..', 'error', 4000)
    end
end)

RegisterServerEvent('rs-companies:server:addEmployee')
AddEventHandler('rs-companies:server:addEmployee', function(playerCitizenId, companyName, rank)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local OtherPlayer = RSCore.Functions.GetPlayerByCitizenId(playerCitizenId)
    local rank = tonumber(rank)
    if OtherPlayer ~= nil then 
        if IsCompanyOwner(companyName, Player.PlayerData.citizenid) then
            if rank > 0 and rank < Config.MaxRank then
                Config.Companies[companyName].employees[OtherPlayer.PlayerData.citizenid] {
                    name = OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname,
                    citizenid = OtherPlayer.PlayerData.citizenid,
                    rank = rank,
                }
                RSCore.Functions.ExecuteSql(false, "UPDATE `companies` SET `employees` = '"..json.encode(Config.Companies[companyName].employees).."' WHERE `name` = '"..escapeSqli(companyName).."'")
                TriggerClientEvent("rs-companies:client:setCompanies", -1, Config.Companies)
                TriggerClientEvent('RSCore:Notify', src, 'Je hebt ' .. OtherPlayer.PlayerData.firstname .. ' ' .. OtherPlayer.PlayerData.lastname .. ' toegevoegd bij werknemers (rank: '..rank..')')
                TriggerClientEvent('RSCore:Notify', OtherPlayer.PlayerData.source, 'Je bent toegevoegd bij bedrijf ' .. Config.Companies[companyName].label .. "(rank: " ..rank..")")
            else
                TriggerClientEvent('RSCore:Notify', src, 'Min rank is 1 en max rank is '..(Config.MaxRank-1)..'..', 'error', 4000)
            end
        else
            TriggerClientEvent('RSCore:Notify', src, 'Je bent geen eigenaar van dit bedrijf..', 'error', 4000)
        end
    else
        TriggerClientEvent('RSCore:Notify', src, 'Persoon is niet aanwezig..', 'error', 4000)
    end
end)

RegisterServerEvent('rs-companies:server:alterEmployee')
AddEventHandler('rs-companies:server:alterEmployee', function(playerCitizenId, companyName, isPromote)
    local src = source
    local Player = RSCore.Functions.GetPlayer(src)
    local otherCitizenId = playerCitizenId:upper()
    if CanAlterEmployee(companyName, Player.PlayerData.citizenid) then
        if Config.Companies[companyName].employees[otherCitizenId] ~= nil then 
            if isPromote then
                local newRank = Config.Companies[companyName].employees[otherCitizenId].rank + 1
                if newRank < Config.MaxRank then
                    Config.Companies[companyName].employees[otherCitizenId].rank = newRank
                    RSCore.Functions.ExecuteSql(false, "UPDATE `companies` SET `employees` = '"..json.encode(Config.Companies[companyName].employees).."' WHERE `name` = '"..escapeSqli(companyName).."'")
                    TriggerClientEvent("rs-companies:client:setCompanies", -1, Config.Companies)
                    TriggerClientEvent('RSCore:Notify', src, 'Werknemer rank geupdate naar: ' ..newRank)
                else
                    TriggerClientEvent('RSCore:Notify', src, 'Persoon kan niet verder gepromoveerd worden..', 'error', 4000)
                end
            else
                local newRank = Config.Companies[companyName].employees[otherCitizenId].rank - 1
                if newRank > 0 then
                    Config.Companies[companyName].employees[otherCitizenId].rank = newRank
                    RSCore.Functions.ExecuteSql(false, "UPDATE `companies` SET `employees` = '"..json.encode(Config.Companies[companyName].employees).."' WHERE `name` = '"..escapeSqli(companyName).."'")
                    TriggerClientEvent("rs-companies:client:setCompanies", -1, Config.Companies)
                    TriggerClientEvent('RSCore:Notify', src, 'Werknemer rank geupdate naar: ' ..newRank)
                else
                    TriggerClientEvent('RSCore:Notify', src, 'Persoon kan niet verder omlaag..', 'error', 4000)
                end
            end
        else
            TriggerClientEvent('RSCore:Notify', src, 'Persoon is geen werknemer van jouw bedrijf..', 'error', 4000)
        end
    else
        TriggerClientEvent('RSCore:Notify', src, 'Je bent geen eigenaar van dit bedrijf..', 'error', 4000)
    end
end)

function IsEmployee(companyName, citizenid)
    local retval = false
    if Config.Companies[companyName] ~= nil then 
        if Config.Companies[companyName].employees ~= nil then 
            if Config.Companies[companyName].employees[citizenid] ~= nil then 
                retval = true
            elseif Config.Companies[companyName].owner == citizenid then
                retval = true
            end
        else
            if Config.Companies[companyName].owner == citizenid then
                retval = true
            end
        end
    end
    return retval
end

function CanAlterEmployee(companyName, citizenid)
    local retval = false
    if Config.Companies[companyName] ~= nil then 
        if Config.Companies[companyName].owner == citizenid then
            retval = true
        elseif Config.Companies[companyName].employees[citizenid] ~= nil then 
            if Config.Companies[companyName].employees[citizenid].rank == (Config.MaxRank - 1) then
                retval = true
            end
        end
    end
    return retval
end

function IsCompanyOwner(companyName, citizenid)
    local retval = false
    if Config.Companies[companyName] ~= nil then 
        if Config.Companies[companyName].owner == citizenid then
            retval = true
        end
    end
    return retval
end

function IsNameAvailable(name)
    local retval = false
    RSCore.Functions.ExecuteSql(true, "SELECT * FROM `companies` WHERE `name` = '"..name.."'", function(result)
        print(result[1])
        if result[1] ~= nil then 
            retval = false
        else
            retval = true
        end
    end)
    return retval
end

function escapeSqli(str)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return str:gsub( "['\"]", replacements ) -- or string.gsub( source, "['\"]", replacements )
end