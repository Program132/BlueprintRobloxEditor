<p align="center">
  <img src="https://i.imgur.com/pqwpsG9.png" width="250" alt="BRE Logo">
</p>

# BlueprintRobloxEditor

BRE (Blueprint Roblox Editor) is a blueprint editor for creating Roblox games using a plugin within Roblox Studio.

The project uses Rojo, a VS Code extension for managing Roblox projects.


DevForum post: https://devforum.roblox.com/t/v11-blueprint-roblox-editor-visual-programming-tools-for-luau/4058664?u=ptitloup132

# Installation

You can clone the repository and build the plugin yourself:
```bash
git clone https://github.com/Program132/BlueprintRobloxEditor.git
cd BlueprintRobloxEditor
rojo build -o BlueprintRobloxEditor.rbxmx
```

You can also download the latest release!

Once you have the plugin, copy it to your Roblox plugins folder:

**Windows (PowerShell):**
```powershell
Copy-Item "BlueprintRobloxEditor.rbxmx" "$env:LOCALAPPDATA\Roblox\Plugins\BlueprintRobloxEditor.rbxmx"
```
- **Windows path:** `%LOCALAPPDATA%\Roblox\Plugins\`
- **Mac path:** `/Users/$USER/Library/Application Support/Roblox/Versions/<version>/Plugins`

# Managing Projects

Roblox plugins have limited access to your local file system, so project management works slightly differently:

## Saving a Project
1. Click the **Save Project** button in the top bar.
2. The plugin will automatically save your state inside Roblox Studio's local plugin settings so you don't lose progress if you close Studio.
3. For backing up to an actual file: The plugin creates a StringValue named __BlueprintExport under the Workspace.
4. Select __BlueprintExport in the Explorer, go to the Properties panel, and **copy the text in the Value property**.
5. Paste this text into a new text file and save it as my_project.json on your computer.

## Loading a Project
1. To load an external project file, click **Open Project** in the top bar.
2. A native file dialog will appear. Select your .json project file.
3. The Blueprint Editor will now load and render the project!

# Controls & Shortcuts

| Action | Control |
| :--- | :--- |
| **Add Node** | Right-click on the canvas to open the node menu. |
| **Move Node** | Drag the header of any node. |
| **Connect Pins** | Drag from an output pin to an input pin. |
| **Delete Node** | Hover over a node and press `Delete` or `Backspace`. |
| **Pan Canvas** | Right-click or Middle-click and drag the background. |
| **Zoom** | Use the Mouse Wheel to zoom in/out. |

# Creating Custom Nodes

Adding a new node to the editor is simple. Each node is a Luau module located in `src/shared/nodes/`.

## 1. Node Structure
Create a new file (e.g., `MyNode.luau`) and follow this template:

```lua
local Node = require(script.Parent.Parent.Node) -- Adjust path
local NodeType = require(script.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.IO)

local MyNode = {}
MyNode.__index = MyNode
setmetatable(MyNode, Node) 

function MyNode.new()
    -- NodeType.METHOD for nodes with Exec pins, NodeType.FUNCTION for pure data nodes
    local self = Node.new("My Node Name", NodeType.METHOD)
    setmetatable(self, MyNode)
    
    -- Customize appearance
    self:editColor(Color3.fromRGB(100, 150, 200))
    
    -- Add pins
    self:addInput(IO.Input.new("Exec", "")) -- Exec pin
    self:addInput(IO.Input.new("Text", '"Hello"'))
    self:addOutput(IO.Output.new("Exec", ""))
    
    return self
end
```

## 2. Examples

### Example A: Print (Method Node)
A node that performs an action and has execution flow.

```lua
function MyNode.new()
    local self = Node.new("Print", NodeType.METHOD)
    setmetatable(self, MyNode)
    self:addInput(IO.Input.new("Exec", ""))
    self:addInput(IO.Input.new("Text", '"Hello"'))
    self:addOutput(IO.Output.new("Exec", ""))
    return self
end

function MyNode:toLuau()
    local text = self:getInput("Text").Value
    return `print({text})\n`
end
```

### Example B: Add (Pure Data Node)
A node that returns a value to be used by other nodes, without execution pins.

```lua
function Add.new()
    local self = Node.new("Add", NodeType.FUNCTION)
    setmetatable(self, Add)
    self:addInput(IO.Input.new("A", "0"))
    self:addInput(IO.Input.new("B", "0"))
    self:addOutput(IO.Output.new("Result", "0"))
    return self
end

function Add:toLuau()
    local a = self:getInput("A").Value
    local b = self:getInput("B").Value
    
    -- We store the expression in the output so other nodes can use it
    self:getOutput("Result").Value = `({a} + {b})`
    
    -- Pure data nodes usually return an empty string because 
    -- they don't generate a standalone line of code.
    return ""
end
```

## 3. Registering the Node
Once created, you must register it in `src/plugin/init.server.luau` and `src/plugin/ui/NodeMenu.luau`.

### In `init.server.luau`:
Add your node to the `Nodes` table:
```lua
local Nodes = {
    ...
    ["My Node Name"] = require(Shared.nodes.MyNode),
}
```

### In `NodeMenu.luau`:
Add it to the `NODES_DATA` table so it appears in the right-click menu:
```lua
local NODES_DATA = {
    {
        category = "My Category",
        color = Color3.fromRGB(100, 150, 200),
        items = {
            { id = "My Node Name", name = "My Custom Node", type = "Method" }
        }
    },
    ...
}
```