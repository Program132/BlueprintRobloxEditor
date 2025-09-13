# Engine

The **Engine** is the central manager of BLE (Blueprint Roblox Editor).  
It stores all the Nodes in your project, maintains their order, and generates the final **Luau** code.

---

## Purpose

- Keep track of all Nodes in the graph.
- Maintain execution order (currently based on the order Nodes are added).
- Generate Luau code for the entire project.
- Optionally write the generated code to a `.luau` file.

---

## Class Overview

**Location:**  
`src/Engine.py`

**Key Methods:**

| Method | Description |
|--------|-------------|
| `addNode(node)` | Adds a Node to the Engine's list. |
| `__str__()` | Returns the generated Luau code for all Nodes in order. |
| `generateFile(filename)` | Writes the generated Luau code to a `.luau` file. |

---

## Basic Usage

```python
from src.Engine import Engine
from src.nodes.EventStart import EventStartNode
from src.nodes.Print import PrintNode
from src.nodes.StringValue import StringValueNode
from src.essentials.DataConnection import DataConnection
from src.essentials.ExecutionConnection import ExecutionConnection

# Create the engine
engine = Engine()

# Create nodes
eventStart = EventStartNode()
printNode = PrintNode()
stringVal = StringValueNode()
stringVal.updateValueOutput("value", "Hello World!")

# Connect execution
ExecutionConnection(eventStart, printNode)

# Connect data
DataConnection(stringVal, "value", printNode, "value").propagate()

# Add nodes to the engine
engine.addNode(eventStart)
engine.addNode(printNode)

# Print generated Luau code
print(engine)

# Save to file
engine.generateFile("main.luau")
```