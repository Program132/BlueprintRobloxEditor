# BlueprintRobloxEditor

BRE (Blueprint Roblox Editor) is a blueprint editor for creating Roblox games using a plugin within Roblox Studio.

The project uses Rojo, a VS Code extension for managing Roblox projects.

# Roadmap

## Phase 1 : Core

### Classes
- [X] Node & NodeType
- [ ] Graph
- [ ] Block
- [X] Input
- [X] Output
- [X] Transition & TransitionType

## Phase 2 : UI

### UI
- [ ] Editor Window
    - [ ] Search Node Modal (menu to add nodes)
    - [ ] Node editor: add & delete nodes
    - [ ] Moving through the graph
    - [ ] 

- [ ] Explorer Windows
    - [ ] Variables Explorer
    - [ ] Functions Explorer
    - [ ] Modules Explorer

## Phase 3 : Customizable Nodes

- [ ] Custom node defined in Luau
    - [ ] Custom title
    - [ ] Custom Color
    - [ ] Custom Description
    - [ ] Custom transitions


# Installation

You can clone the repository and build the plugin yourself:
```bash
git clone https://github.com/Program132/BlueprintRobloxEditor.git
cd BlueprintRobloxEditor
rojo build -o BlueprintRobloxEditor.rbxmx
```

You can as well download the lastest release!

Once you have the plugin, open Roblox Studio and move the plugin to your plugin folder.
Windows path: `%LOCALAPPDATA%\Roblox\Plugins`
Mac path: `/Users/%USERNAME%/Library/Application Support/Roblox/Versions/version/Plugins`