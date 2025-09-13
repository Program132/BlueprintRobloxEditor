# Overview

## Introduction

**BLE (Blueprint Roblox Editor)** is a Python-based project that allows you to create **Luau** code (the scripting language used by Roblox) using a **node-based visual system**, inspired by Unreal Engine's **Blueprints**.

The goal is to provide a visual alternative to writing code, ideal for:
- Beginners who want to learn programming logic in a more playful way.
- Developers who prefer working with blocks and connections instead of plain text.
- Roblox creators who want to quickly prototype scripts.

---

## Core Architecture

BLE is built around three main concepts:

### 1. **Nodes**
Nodes are the building blocks of the system.  
Each Node represents an action, a value, or an event.  
Examples:
- `EventStartNode` → Entry point of the program.
- `PrintNode` → Prints a value to the console.
- `StringValueNode` → Holds a string value.
- `IntValueNode`, `DoubleValueNode`, `BooleanValueNode` → Hold numeric or boolean values.

Each Node has:
- **Inputs**: Values or execution signals it receives.
- **Outputs**: Values or execution signals it sends.
- A `toLuau()` method that generates the corresponding Luau code.

---

### 2. **Connections**
Connections link Nodes together.

Two types exist:
- **DataConnection** → Transfers data (string, int, bool, etc.) from one Node to another.
- **ExecutionConnection** → Transfers execution flow (like the white wires in UE5).

These connections form a logical graph where values flow and execution order is defined.

---

### 3. **Engine**
The **Engine** is the core manager:
- Stores all Nodes.
- Maintains execution order.
- Generates the final Luau code via `print(engine)` or `engine.generateFile("script.luau")`.

---

## Minimal Example

```python
from src.Engine import Engine
from src.nodes.EventStart import EventStartNode
from src.nodes.Print import PrintNode
from src.nodes.StringValue import StringValueNode
from src.essentials.DataConnection import DataConnection
from src.essentials.ExecutionConnection import ExecutionConnection

engine = Engine()

eventStart = EventStartNode()
printNode = PrintNode()
stringVal = StringValueNode()
stringVal.updateValueOutput("value", "Hello World!")

# Connections
ExecutionConnection(eventStart, printNode)
DataConnection(stringVal, "value", printNode, "value").propagate()

# Add nodes to the engine
engine.addNode(eventStart)
engine.addNode(printNode)

# Get lua code
print(engine)
```

Output:
```
-- START
print("Hello World!")
```