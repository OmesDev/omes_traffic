# Omes Traffic Control System

A FiveM resource for managing and adjusting traffic density in your server.

- [Omes Traffic](https://imgur.com/XPkhb2G)

## Features

- Control multiple aspects of traffic density:
  - Pedestrian density
  - Vehicle density on roads
  - Parked car density
  - Random vehicle density
  - Scenario ped density (NPCs doing activities)
- User-friendly ox_lib menu interface
- Save/load settings using FiveM's KVP storage
- Comprehensive permission system (ACE, ESX, QBCore)
- Emergency services & special vehicles control
- Fully configurable through config.lua

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib) - Required for the UI

## Installation

1. Download the resource
2. Place it in your server's `resources` folder
3. Add `ensure omes_traffic` to your server.cfg
4. Configure permissions in config.lua if needed
5. Restart your server

## Configuration

All settings can be configured in `config.lua`:

### Default Density Values

```lua
Config.DefaultDensity = {
    pedestrians = 1.0,      -- Pedestrian density
    vehicles = 1.0,         -- Vehicle density
    parkedCars = 1.0,       -- Parked car density
    randomVehicles = 1.0,   -- Random vehicles on roads
    scenarioPeds = 1.0      -- Scenario peds (people doing activities)
}
```

### Permissions

```lua
Config.Permissions = {
    enabled = true,                      -- Set to false to allow anyone to use the command
    acePermission = "traffic.control",   -- ACE permission required
    allowedGroups = {                    -- Player groups that can use the command
        "admin",
        "superadmin",
        "mod"
    }
}
```

### UI Configuration

```lua
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
```

### Emergency Services

```lua
Config.EmergencyServices = {
    disable = true,              -- Set to false to allow emergency vehicles
    disableGarbageTrucks = true, -- Set to false to allow garbage trucks
    disableRandomBoats = true    -- Set to false to allow random boats
}
```

## Usage

### Commands

- `/traffic` - Opens the traffic control menu

### Menu Options

1. **Pedestrian Density** - Control how many pedestrians appear in the world
2. **Vehicle Density** - Control how many vehicles drive around
3. **Parked Vehicle Density** - Control how many parked cars appear
4. **Random Vehicle Density** - Control random vehicles on roads
5. **Scenario Ped Density** - Control NPCs doing activities (sitting, talking, etc.)
6. **Save Settings** - Save your current settings (persists through restarts)
7. **Reset All Settings** - Restore default values from config

## Permissions

The script supports three permission systems:

1. **ACE Permissions** - Use `add_ace group.admin traffic.control allow` in your server.cfg
2. **ESX Permissions** - Define allowed groups in config.lua (admin, superadmin, etc.)
3. **QBCore Permissions** - Define allowed jobs in config.lua

## Performance Impact

This resource has minimal performance impact:
- Main traffic density loop runs every frame but only sets multipliers
- Emergency services loop runs once per second
- Menu only activates when command is used

## Credits

- Created by Omes
- Using ox_lib by Overextended team

## License

This resource is released under the MIT License. See LICENSE file for details.

## Support

For issues, suggestions or contributions, please visit [repository URL] or contact Omes on the FiveM forums. 
