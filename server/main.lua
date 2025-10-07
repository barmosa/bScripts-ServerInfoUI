print("bScripts - https://discord.gg/XQW9YJNk32")

local Framework = (Config and Config.Framework) or 'qb'

local function GetExactPlayerCount()
    return #GetPlayers()
end

if Framework == 'qb' then
    local QBCore = exports['qb-core']:GetCoreObject()
    QBCore.Functions.CreateCallback('bScripts-logoui:getCurrentPlayers', function(source, cb)
        cb(GetExactPlayerCount())
    end)
else
    local ESX
    if exports['es_extended'] and exports['es_extended'].getSharedObject then
        ESX = exports['es_extended']:getSharedObject()
    else
        AddEventHandler('esx:getSharedObject', function(obj) ESX = obj end)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end

    if ESX and ESX.RegisterServerCallback then
        ESX.RegisterServerCallback('bScripts-logoui:getCurrentPlayers', function(source, cb)
            cb(GetExactPlayerCount())
        end)
    else
        RegisterNetEvent('bScripts-logoui:requestPlayersCount')
        AddEventHandler('bScripts-logoui:requestPlayersCount', function()
            TriggerClientEvent('bScripts-logoui:playersCount', source, GetExactPlayerCount())
        end)
    end
end
