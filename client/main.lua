local Framework = (Config and Config.Framework) or 'qb'
local QBCore, ESX

if Framework == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
else
    if exports['es_extended'] and exports['es_extended'].getSharedObject then
        ESX = exports['es_extended']:getSharedObject()
    else
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end

local function UpdateUI()
    local serverId = GetPlayerServerId(PlayerId())

    local playerJobLabel = 'N/A'
    local jobName, jobLabelFull, jobGradeLabel

    if Framework == 'qb' and QBCore then
        local PlayerData = QBCore.Functions.GetPlayerData() or {}
        local job = (PlayerData.job or {})
        local grade = (job.grade or {})
        playerJobLabel = grade.label or grade.name or job.label or job.name or 'N/A'
        jobName = job.name
        jobLabelFull = job.label
        jobGradeLabel = grade.label or grade.name
    elseif Framework == 'esx' and ESX then
        local PD = ESX.GetPlayerData() or {}
        local job = (PD.job or {})
        playerJobLabel = job.grade_label or job.grade_name or job.label or job.name or 'N/A'
        jobName = job.name
        jobLabelFull = job.label or playerJobLabel
        jobGradeLabel = job.grade_label or job.grade_name
    end

    local function send(count)
        SendNUIMessage({
            type = 'UPDATE_UI',
            data = {
                id = serverId,
                players = count or 0,
                maxPlayers = (Config and Config.MaxPlayers) or GetConvarInt('sv_maxclients', 64),
                serverName = (Config and Config.ServerName) or 'Server',
                colors = (Config and Config.Colors) or {},
                job = playerJobLabel,
                jobGradeLabel = jobGradeLabel,
                jobName = jobName,
                jobLabelFull = jobLabelFull,
            }
        })
    end

    if Framework == 'qb' and QBCore then
        QBCore.Functions.TriggerCallback('bScripts-logoui:getCurrentPlayers', function(count)
            send(count)
        end)
    elseif Framework == 'esx' and ESX then
        ESX.TriggerServerCallback('bScripts-logoui:getCurrentPlayers', function(count)
            send(count)
        end)
    else
        send(0)
    end
end

Citizen.CreateThread(function()
    while true do
        UpdateUI()
        Wait(1000)
    end
end)

if Framework == 'qb' then
    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        UpdateUI()
    end)
    AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
        UpdateUI()
    end)
elseif Framework == 'esx' then
    AddEventHandler('esx:playerLoaded', function()
        UpdateUI()
    end)
    AddEventHandler('esx:setJob', function(job)
        UpdateUI()
    end)
end
