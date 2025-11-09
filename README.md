# Blueprint Roblox Editor

[![Downloads](https://img.shields.io/github/downloads/Program132/BlueprintRobloxEditor/total?style=for-the-badge)](https://github.com/Program132/BlueprintRobloxEditor/releases)
[![Code size](https://img.shields.io/github/languages/code-size/Program132/BlueprintRobloxEditor?style=for-the-badge)](https://github.com/Program132/BlueprintRobloxEditor)
[![Last Release](https://img.shields.io/github/release/Program132/BlueprintRobloxEditor?style=for-the-badge)](https://github.com/Program132/BlueprintRobloxEditor/releases)

**BRE (Blueprint Roblox Editor)** is an open-source project that allows users to use Python or the editor (the web application) to program in Luau, the language used by Roblox, derived from Lua.

The goal is to replicate the same programming system as Unreal Engine 5’s Blueprint, so that programming is done not with lines of code but with blocks. This can also attract people who want to learn programming.

BRE can be customized using block definitions that you can create yourself! Read the documentation to learn more.

## Version actuelle

BRE includes 3 basic blocks: a start event which corresponds to the base event and is essential to begin coding if you are not using Roblox events (such as PlayerAdded, PlayerRemoved, etc.).

Bugs may be present, please report them.

## Contribuer

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

Please send bugs to [Report a Bug (Issues)](https://github.com/Program132/BlueprintRobloxEditor/issues/new?assignees=&labels=bug&projects=&template=bug_report.md&title=) and proposals to [Propose a Node (Issues)](https://github.com/Program132/BlueprintRobloxEditor/issues/new?assignees=&labels=enhancement&projects=&template=feature_request.md&title=).

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

##  Documentation

Read [README](doc/README.md).

You can read as well the post from the devforum: [Roblox DevForum Post](https://devforum.roblox.com/t/blueprint-roblox-editor-visual-programming-tools-for-luau-flow-based/4058664)