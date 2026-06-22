# Roblox Car Flipping Game

A complete car flipping simulator for Roblox where players buy damaged cars, repair them, and sell for profit.

## Features

- **Economy System**: Buy cars from NPCs at varying prices, repair, and sell for profit
- **Car Management**: Inventory system with car conditions and stats
- **NPC Customers**: Dynamic pricing based on car condition and player reputation
- **Repair System**: Upgrade cars with costs affecting resale value
- **Progression**: Reputation system that unlocks better cars and better deals
- **Player Data**: Persistent wallet, inventory, and statistics

## Installation

1. Open Roblox Studio
2. Create a new place or open an existing one
3. In **ServerScriptService**, create a new Script and copy the contents of `src/Server/CarFlipGame.lua`
4. In **ServerStorage**, create a folder called `Modules` and add all scripts from `src/Server/Modules/`
5. In **StarterPlayer > StarterPlayerScripts**, add scripts from `src/Client/`
6. Configure the game settings in `Config.lua` as needed
7. Test the game!

## File Structure

```
src/
├── Server/
│   ├── CarFlipGame.lua (main server script)
│   └── Modules/
│       ├── Economy.lua (buying/selling system)
│       ├── CarManager.lua (inventory & car stats)
│       ├── NPCSystem.lua (customer behavior)
│       ├── RepairSystem.lua (repair costs & effects)
│       └── PlayerData.lua (data persistence)
├── Client/
│   └── GUI.lua (player interface)
└── Config.lua (game configuration)
```

## Customization

All game values (starting money, car prices, repair costs, etc.) are in `Config.lua`. Modify these to balance your game.

## License

Feel free to modify and use as needed for your Roblox game!
