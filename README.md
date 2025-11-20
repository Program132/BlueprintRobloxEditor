# Blueprint Roblox Editor

![Latest version](https://img.shields.io/github/v/release/Program132/BlueprintRobloxEditor?style=for-the-badge&include_prereleases)
![Code size](https://img.shields.io/github/languages/code-size/Program132/BlueprintRobloxEditor?style=for-the-badge&logo=github)
![Downloads](https://img.shields.io/github/downloads/Program132/BlueprintRobloxEditor/total?color=%2324cc24&style=for-the-badge&logo=github)
![Open Issues](https://img.shields.io/github/issues/Program132/BlueprintRobloxEditor?style=for-the-badge&logo=github)
![Closed Issues](https://img.shields.io/github/issues-closed/Program132/BlueprintRobloxEditor?style=for-the-badge&logo=github)

**BRE (Blueprint Roblox Editor)** is an open-source project that allows users to use Python or the editor (the web application) to program in Luau, the language used by Roblox, derived from Lua.

The goal is to replicate the same programming system as Unreal Engine 5’s Blueprint, so that programming is done not with lines of code but with blocks. This can also attract people who want to learn programming.

BRE can be customized using block definitions that you can create yourself! Read the documentation to learn more.

Please send bugs to [Report a Bug (Issues)](https://github.com/Program132/BlueprintRobloxEditor/issues/new?assignees=&labels=bug&projects=&template=bug_report.md&title=) and proposals to [Propose a Node (Issues)](https://github.com/Program132/BlueprintRobloxEditor/issues/new?assignees=&labels=enhancement&projects=&template=feature_request.md&title=).

## Contribute

To help the project evolve, you can report vulnerabilities/bugs, whether on the site or in the backend (API).

Additionally, it is possible to propose your own node. Please follow the format below:
```json
{
    "type": "METHOD",
    "inputs": {
        "input_name": {
            "defaultValue": "default_input_value"
        }
    },
    "outputs": [
        "output_name"
    ]
}
```
Note: outputs and inputs can be empty:
```json
{
    "type": "METHOD",
    "inputs": {},
    "outputs": []
}
```
⚠️ IMPORTANT: Write the type in uppercase as follows:
- METHOD = exec connection
- FUNCTION = no exec connection
- EVENT = one exec output

Once that's done you need to create the node in Python on the backend, create a file in `src/models`, you need to complete the `toLuau` function and indicate your **.json** file in the constructor then the type of the node.
```python
from src.Node import Node, NodeType

class MyNode(Node):
    def __init__(self):
        super().__init__("nodes/MyNode.json")

    def toLuau(self):
        return "My node"
```

Note: If you create custom events and there is "more than 1 event" in your node, like CharacterAdded, make sure to give a value to `events_count`, example:
```py 
from typing import Optional
from src.Node import Node


class PlayerAdded(Node):
    def __init__(self) -> None:
        super().__init__("nodes/events/playeradded.json")
        self.events_count = 1 # here, PlayerAdded is "one event"

    def toLuau(self) -> Optional[str]:
        output_names = [o.name for o in self.outputs]
        args = ", ".join(output_names)
        r = f'game:GetService("Players").PlayerAdded:Connect(function({args})'
        return r
```
```py 
from typing import Optional
from src.Node import Node


class CharacterAdded(Node):
    def __init__(self) -> None:
        super().__init__("nodes/events-characteradded.json")
        self.event_count = 2 # there is PlayerAdded and CharacterAdded events

    def toLuau(self) -> Optional[str]:
        r = (f'game:GetService("Players").PlayerAdded:Connect(function(Player)\n'
             f'Player.CharacterAdded:Connect(function(Character)')
        return r
```
 
You can implement several things in the "translation" function, I advise you to look at the already existing nodes.


WARNING: If you create custom statement, like if, loops etc. make sure to have a "exec output" named "Continue" !
Example (for range):
```json
  {
      "title": "For (Range)",
      "color": [200,200,200],
      "type": "METHOD",
      "inputs": {
          "variable": {
              "defaultValue": "i"
          },
          "start": {
              "defaultValue": 1
          },
          "end": {
              "defaultValue": 10
          },
          "step": {
              "defaultValue": 1
          }
      },
      "exec": [
          "Loop Body",
          "Continue"
      ],
      "outputs": []
  }
```

## Installation

Run the following commands in a folder where you want the project to be located:

Linux:
```bash
git clone https://github.com/Program132/BlueprintRobloxEditor.git
cd BlueprintRobloxEditor
python3 -m venv env
source env/bin/activate
python3 -m pip install -r webeditor/requirements.txt
python3 webditor/app.py
```

Windows:
```bash
git clone https://github.com/Program132/BlueprintRobloxEditor.git
cd BlueprintRobloxEditor
py -m venv env
env/bin/activate
py -m pip install -r webeditor/requirements.txt
py webditor/app.py
```
Now move to http://127.0.0.1:80/

Download the lastest release if you want something stable:
```bash
git clone https://github.com/Program132/BlueprintRobloxEditor.git
cd BlueprintRobloxEditor
git fetch --tags
git checkout $(git describe --tags `git rev-list --tags --max-count=1`)
```

##  Documentation

Read [README](doc/README.md).

You can read as well the post from the devforum: [Roblox DevForum Post](https://devforum.roblox.com/t/blueprint-roblox-editor-visual-programming-tools-for-luau-flow-based/4058664)