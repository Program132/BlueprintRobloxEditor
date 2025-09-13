# Blueprint Roblox Editor

BLE (Blueprint Roblox Editor) is a project created in Python to enable coding using a blueprint-style language similar to that found in Unreal Engine, created by Epic Games.

The goal is to be able to code in Luau, the language used by Roblox, using "Nodes," blocks that are assembled to form a program.

Some developers prefer to work in a graphical environment rather than a traditional one with lines of code, hence the origin of this project, and also to make it seem more fun for beginners.

# Installation

Install & Run the projet:
- Install python: https://www.python.org/downloads/
- Clone the repository: ...
- If you're on Linux, you should use env lib:
`source env/bin/activate`
- Install packages:
  - On Linux: `python3 -m pip install -r requirements.txt`
  - On Windows: `py -m pip install -r requirements.txt`
- Run the program `main.py`:
  - On Linux: `python3 main.py`
  - On Windows: `py main.py`

# Example

You will can find an example of a project using BLE:
```python
from src.Engine import Engine
from src.essentials.ExecutionConnection import ExecutionConnection
from src.nodes.BooleanValue import BooleanValueNode
from src.nodes.DoubleValue import DoubleValueNode
from src.nodes.IntValue import IntValueNode
from src.nodes.Print import PrintNode
from src.nodes.StringValue import StringValueNode
from src.nodes.EventStart import EventStartNode
from src.essentials.DataConnection import DataConnection

engine = Engine()

eventStart = EventStartNode()
print1 = PrintNode()
print2 = PrintNode()
print3 = PrintNode()
print4 = PrintNode()

stringVal = StringValueNode()
stringVal.updateValueOutput("value", "Hello World 2!")
intVal = IntValueNode()
intVal.updateValueOutput("value", 18)
doubleVal = DoubleValueNode()
doubleVal.updateValueOutput("value", 3.14)
boolVal = BooleanValueNode()
boolVal.updateValueOutput("value", True)

exec = ExecutionConnection(eventStart, print1)
conn = DataConnection(stringVal, "value", print1, "value")
conn.propagate()
conn = DataConnection(intVal, "value", print2, "value")
conn.propagate()
conn = DataConnection(doubleVal, "value", print3, "value")
conn.propagate()
conn = DataConnection(boolVal, "value", print4, "value")
conn.propagate()

engine.addNode(eventStart)
engine.addNode(print1)
engine.addNode(print2)
engine.addNode(print3)
engine.addNode(print4)

#engine.generateFile("main.lua")
print(engine)
```

# Next Updates

In next updates, several elements will be added:
- Variable nodes.
- The ability to divide the project into multiple "levels" / scripts.
- Basic nodes such as conditions, loops, etc.

The project's goal is also to have a real interface, a graphical interface.

# Documentation

The documentation for BLE is available in the `doc/` folder:

* [Overview](doc/Overview.md) — General explanation of how BLE works and its architecture.
* [Nodes](doc/Nodes.md) — Detailed documentation for each Node type (PrintNode, StringValueNode, EventStartNode, etc.).
* [Connections](doc/Connections.md) — Explanation of DataConnection and ExecutionConnection, how to link nodes together.
* [Engine](doc/Engine.md) — How the Engine class works, adding nodes, generating Luau code, and saving to file.