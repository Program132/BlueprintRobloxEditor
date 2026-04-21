# BlueprintRobloxEditor

BRE (Blueprint Roblox Editor) is a blueprint editor for creating Roblox games using a plugin within Roblox Studio.

The project uses Rojo, a VS Code extension for managing Roblox projects.


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

**Windows path:** `%LOCALAPPDATA%\Roblox\Plugins\`
**Mac path:** `/Users/$USER/Library/Application Support/Roblox/Versions/<version>/Plugins`