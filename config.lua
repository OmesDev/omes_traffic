Config = {}

-- Default density values (0.0 = none, 1.0 = normal GTA default)
Config.DefaultDensity = {
    pedestrians = 1.0,      -- Pedestrian density
    vehicles = 1.0,         -- Vehicle density
    parkedCars = 1.0,       -- Parked car density
    randomVehicles = 1.0,   -- Random vehicles on roads
    scenarioPeds = 1.0      -- Scenario peds (people doing activities)
}

-- Sync configuration
Config.NotifyOnSync = false      -- Notify players when traffic settings are synced
Config.SaveSyncedSettings = false -- Save synced settings locally (persists through player restarts)

-- Permission settings
Config.Permissions = {
    enabled = true,                      -- Set to false to allow anyone to use the command
    acePermission = "traffic.control",   -- ACE permission required (if ace is used)
    allowedGroups = {                    -- Player groups that can use the command
        "admin",
        "superadmin",
        "mod"
    }
}

-- UI Configuration
Config.UI = {
    menuPosition = 'top-right',  -- Menu position: 'top-right', 'top-left', 'bottom-right', 'bottom-left'
    notifications = {
        success = {
            title = 'Traffic System',
            type = 'success'
        },
        info = {
            title = 'Traffic System',
            type = 'info'
        },
        error = {
            title = 'Traffic System',
            type = 'error'
        }
    }
}

-- Emergency and special vehicles configuration
Config.EmergencyServices = {
    disable = true,              -- Set to false to allow emergency vehicles
    disableGarbageTrucks = true, -- Set to false to allow garbage trucks
    disableRandomBoats = true    -- Set to false to allow random boats
}

-- KVP Storage key
Config.StorageKey = 'omes_traffic:settings' 
