# Nodes

This document lists all available **Nodes** in BLE, their purpose, inputs, outputs, and example Luau code.

---

## Event Nodes

### `EventStartNode`
**Purpose:**  
Entry point of the program. Similar to Unreal Engine's `Event BeginPlay`.  
Executes connected nodes when the program starts.

| Inputs | Type | Description |
|--------|------|-------------|
| *(none)* | — | — |

| Outputs | Type | Description |
|---------|------|-------------|
| `exec` | Execution | Triggers the next node in the execution chain |

**Example Luau output:**
```lua
-- START
```

## Function Nodes

### `PrintNode`

Purpose: Prints a value to the output console.

| Inputs | Type | Description |
|--------|------|-------------|
| *value* | Any | The value to print (string, number, boolean) |

| Outputs | Type | Description |
|---------|---|-------------|
|---------|------|-------------|

Example Luau output:
```lua
print("Hello World!")
```


### `StringValueNode`

Purpose: Stores a string value.

| Inputs | Type | Description |
|--------|------|-------------|
| (none) |------|-------------|

| Outputs | Type   | Description       |
|---------|--------|-------------------|
| *value* | String | The stored string |

Example Luau output:
```lua
"Hello World!"
```

### `IntValueNode`

Purpose: Stores a int value.

| Inputs | Type | Description |
|--------|------|-------------|
| (none) |------|-------------|

| Outputs | Type | Description    |
|---------|------|----------------|
| *value* | Int  | The stored int |

Example Luau output:
```lua
5
```

### `DoubleValueNode`

Purpose: Stores a double value.

| Inputs | Type | Description |
|--------|------|-------------|
| (none) |------|-------------|

| Outputs | Type   | Description    |
|---------|--------|----------------|
| *value* | Double | The stored double |

Example Luau output:
```lua
3.14
```

### `BooleanValueNode`

Purpose: Stores a boolean value.

| Inputs | Type | Description |
|--------|------|-------------|
| (none) |------|-------------|

| Outputs | Type    | Description    |
|---------|---------|----------------|
| *value* | Boolean | The stored boolean |

Example Luau output:
```lua
true
false
```

# Create your own Node

To create a new Node:
- Create a new Python class in src/nodes/.
- Inherit from Node.
- Define its inputs and/or outputs in the constructor.
- Implement getValue() to return the internal value.
- Implement toLuau() to return the Luau code representation.

Template example:
```python 
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType

class MyCustomNode(Node):
    def __init__(self):
        super().__init__(NodeType.FUNCTION, "My Custom Node")
        self.addInput("value", "")
        self.addOutput("result", "")

    def getValue(self):
        return self.getValueInput("value")

    def toLuau(self):
        return f'-- Custom Luau code here'
```