# BlueprintRobloxEditor


BRE (Blueprint Roblox Editor) est un éditeur de Blueprint pour la création de jeux Roblox depuis un plugin sous Roblox Studio.

Le projet utilise Rojo, une extension de VS Code pour gérer les projets Roblox.

# Installation

If you have rojo:
```bash
git clone https://github.com/Program132/BlueprintRobloxEditor.git
cd BlueprintRobloxEditor
rojo build -o "BlueprintRobloxEditor.rbxlx"
```

If you don't have rojo, you can download it from [here](https://rojo.space/docs/rojo/download).
Else, you can use the `.rbxm` file provided in the releases.

# Roadmap

## Phase 1 : Core

### Classes
- [ ] Node
- [ ] Graph
- [ ] Pin
- [ ] Transition

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