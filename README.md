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
