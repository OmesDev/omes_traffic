-- Traffic Control System by Omes
local pedDensity = Config.DefaultDensity.pedestrians
local vehicleDensity = Config.DefaultDensity.vehicles
local parkedDensity = Config.DefaultDensity.parkedCars
local randomVehicleDensity = Config.DefaultDensity.randomVehicles
local scenarioPedDensity = Config.DefaultDensity.scenarioPeds

local hasPermissionResult = false
local checkingPermission = false

RegisterNetEvent('omes_traffic:permissionResult')
AddEventHandler('omes_traffic:permissionResult', function(result)
    hasPermissionResult = result
    checkingPermission = false
end)

function SaveDensitySettings()
    local settings = {
        ped = pedDensity,
        vehicle = vehicleDensity,
        parked = parkedDensity,
        random = randomVehicleDensity,
        scenario = scenarioPedDensity
    }
    
    local encodedSettings = json.encode(settings)
    SetResourceKvp(Config.StorageKey, encodedSettings)
    lib.notify({
        title = Config.UI.notifications.success.title,
        description = 'Settings saved successfully',
        type = Config.UI.notifications.success.type
    })
end

function LoadDensitySettings()
    local encodedSettings = GetResourceKvpString(Config.StorageKey)
    
    if encodedSettings then
        local settings = json.decode(encodedSettings)
        
        pedDensity = settings.ped or Config.DefaultDensity.pedestrians
        vehicleDensity = settings.vehicle or Config.DefaultDensity.vehicles
        parkedDensity = settings.parked or Config.DefaultDensity.parkedCars
        randomVehicleDensity = settings.random or Config.DefaultDensity.randomVehicles
        scenarioPedDensity = settings.scenario or Config.DefaultDensity.scenarioPeds
        
        lib.notify({
            title = Config.UI.notifications.info.title,
            description = 'Settings loaded from save',
            type = Config.UI.notifications.info.type
        })
    end
end

function HasPermission(callback)
    if not Config.Permissions.enabled then
        callback(true)
        return
    end
    
    local hasPermission = false
    
    if GetResourceState('es_extended') ~= 'missing' then
        local ESX = exports['es_extended']:getSharedObject()
        if ESX and ESX.GetPlayerData and ESX.GetPlayerData().group then
            local playerGroup = ESX.GetPlayerData().group
            for _, group in ipairs(Config.Permissions.allowedGroups) do
                if playerGroup == group then
                    hasPermission = true
                    break
                end
            end
        end
    end
    
    if not hasPermission and GetResourceState('qb-core') ~= 'missing' then
        local QBCore = exports['qb-core']:GetCoreObject()
        if QBCore and QBCore.Functions.GetPlayerData().job then
            local PlayerJob = QBCore.Functions.GetPlayerData().job
            for _, group in ipairs(Config.Permissions.allowedGroups) do
                if PlayerJob.name == group then
                    hasPermission = true
                    break
                end
            end
        end
    end
    
    if hasPermission then
        callback(true)
        return
    end
    
    checkingPermission = true
    hasPermissionResult = false
    TriggerServerEvent('omes_traffic:checkPermission')
    
    local timeout = 20
    Citizen.CreateThread(function()
        local count = 0
        while checkingPermission and count < timeout do
            Citizen.Wait(50)
            count = count + 1
        end
        
        callback(hasPermissionResult)
        checkingPermission = false
    end)
end

Citizen.CreateThread(function()
    LoadDensitySettings()
end)

RegisterCommand('traffic', function()
    HasPermission(function(allowed)
        if allowed then
            OpenTrafficMenu()
        else
            lib.notify({
                title = Config.UI.notifications.error.title,
                description = 'You do not have permission to use this command',
                type = Config.UI.notifications.error.type
            })
            
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                multiline = true,
                args = {"System", "Access denied for /traffic command. Insufficient permissions."}
            })
        end
    end)
end, false)

function OpenTrafficMenu()
    lib.registerMenu({
        id = 'traffic_control_menu',
        title = 'Traffic Control System',
        position = Config.UI.menuPosition,
        options = {
            {label = 'Pedestrian Density: ' .. pedDensity},
            {label = 'Vehicle Density: ' .. vehicleDensity},
            {label = 'Parked Vehicle Density: ' .. parkedDensity},
            {label = 'Random Vehicle Density: ' .. randomVehicleDensity},
            {label = 'Scenario Ped Density: ' .. scenarioPedDensity},
            {label = 'Save Settings', description = 'Save current settings'},
            {label = 'Reset All Settings'}
        }
    }, function(selected)
        if selected == 1 then
            local input = lib.inputDialog('Pedestrian Density', {
                {type = 'slider', label = 'Density', default = pedDensity * 100, min = 0, max = 100}
            })
            if input then
                pedDensity = input[1] / 100
                lib.notify({
                    title = Config.UI.notifications.success.title,
                    description = 'Pedestrian density set to ' .. pedDensity,
                    type = Config.UI.notifications.success.type
                })
                OpenTrafficMenu()
            end
        elseif selected == 2 then
            local input = lib.inputDialog('Vehicle Density', {
                {type = 'slider', label = 'Density', default = vehicleDensity * 100, min = 0, max = 100}
            })
            if input then
                vehicleDensity = input[1] / 100
                lib.notify({
                    title = Config.UI.notifications.success.title,
                    description = 'Vehicle density set to ' .. vehicleDensity,
                    type = Config.UI.notifications.success.type
                })
                OpenTrafficMenu()
            end
        elseif selected == 3 then
            local input = lib.inputDialog('Parked Vehicle Density', {
                {type = 'slider', label = 'Density', default = parkedDensity * 100, min = 0, max = 100}
            })
            if input then
                parkedDensity = input[1] / 100
                lib.notify({
                    title = Config.UI.notifications.success.title,
                    description = 'Parked vehicle density set to ' .. parkedDensity,
                    type = Config.UI.notifications.success.type
                })
                OpenTrafficMenu()
            end
        elseif selected == 4 then
            local input = lib.inputDialog('Random Vehicle Density', {
                {type = 'slider', label = 'Density', default = randomVehicleDensity * 100, min = 0, max = 100}
            })
            if input then
                randomVehicleDensity = input[1] / 100
                lib.notify({
                    title = Config.UI.notifications.success.title,
                    description = 'Random vehicle density set to ' .. randomVehicleDensity,
                    type = Config.UI.notifications.success.type
                })
                OpenTrafficMenu()
            end
        elseif selected == 5 then
            local input = lib.inputDialog('Scenario Ped Density', {
                {type = 'slider', label = 'Density', default = scenarioPedDensity * 100, min = 0, max = 100}
            })
            if input then
                scenarioPedDensity = input[1] / 100
                lib.notify({
                    title = Config.UI.notifications.success.title,
                    description = 'Scenario ped density set to ' .. scenarioPedDensity,
                    type = Config.UI.notifications.success.type
                })
                OpenTrafficMenu()
            end
        elseif selected == 6 then
            SaveDensitySettings()
            OpenTrafficMenu()
        elseif selected == 7 then
            pedDensity = Config.DefaultDensity.pedestrians
            vehicleDensity = Config.DefaultDensity.vehicles
            parkedDensity = Config.DefaultDensity.parkedCars
            randomVehicleDensity = Config.DefaultDensity.randomVehicles
            scenarioPedDensity = Config.DefaultDensity.scenarioPeds
            lib.notify({
                title = Config.UI.notifications.success.title,
                description = 'All settings reset to default values',
                type = Config.UI.notifications.success.type
            })
            OpenTrafficMenu()
        end
    end)
    
    lib.showMenu('traffic_control_menu')
end

Citizen.CreateThread(function()
    while true do
        SetPedDensityMultiplierThisFrame(pedDensity)
        SetVehicleDensityMultiplierThisFrame(vehicleDensity)
        SetParkedVehicleDensityMultiplierThisFrame(parkedDensity)
        SetRandomVehicleDensityMultiplierThisFrame(randomVehicleDensity)
        SetScenarioPedDensityMultiplierThisFrame(scenarioPedDensity, scenarioPedDensity)
        
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        if Config.EmergencyServices.disable then
            for i = 1, 12 do
                EnableDispatchService(i, false)
            end
        end
        
        if Config.EmergencyServices.disableGarbageTrucks then
            SetGarbageTrucks(false)
        end
        
        if Config.EmergencyServices.disableRandomBoats then
            SetRandomBoats(false)
        end
        
        Citizen.Wait(1000)
    end
end)
