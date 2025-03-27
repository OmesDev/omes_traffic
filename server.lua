-- Server-side permission checker
RegisterNetEvent('omes_traffic:checkPermission')
AddEventHandler('omes_traffic:checkPermission', function()
    local src = source
    local hasPermission = false
    local player = source
    
    if not Config.Permissions.enabled then
        hasPermission = true
    else
        if IsPlayerAceAllowed(player, Config.Permissions.acePermission) then
            hasPermission = true
        end
        
        if not hasPermission and GetResourceState('es_extended') ~= 'missing' then
            local ESX = exports['es_extended']:getSharedObject()
            if ESX and ESX.GetPlayerFromId then
                local xPlayer = ESX.GetPlayerFromId(player)
                if xPlayer then
                    for _, group in ipairs(Config.Permissions.allowedGroups) do
                        if xPlayer.getGroup() == group then
                            hasPermission = true
                            break
                        end
                    end
                end
            end
        end
        
        if not hasPermission and GetResourceState('qb-core') ~= 'missing' then
            local QBCore = exports['qb-core']:GetCoreObject()
            if QBCore and QBCore.Functions.GetPlayer then
                local Player = QBCore.Functions.GetPlayer(player)
                if Player then
                    for _, group in ipairs(Config.Permissions.allowedGroups) do
                        if Player.PlayerData.job.name == group then
                            hasPermission = true
                            break
                        end
                    end
                end
            end
        end
    end
    
    if not hasPermission then
        TriggerClientEvent('chat:addMessage', src, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "Access denied for /traffic command. Insufficient permissions."}
        })
    end
    
    TriggerClientEvent('omes_traffic:permissionResult', src, hasPermission)
end) 