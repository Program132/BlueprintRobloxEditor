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


### `VariableNode`

Purpose: Declares a local variable and assigns it an initial value.

| Inputs | Type | Description |
|--------|------|-------------|
| (none) |------|-------------|

| Outputs | Type           | Description    |
|-------|----------------|----------------|
| `ref` | Node Reference | Reference to this variable node (used by Get/Set Variable nodes) |
| `value` | Any            |  Current value of the variable |

Example Luau output:
```lua
local score = 10
```

### `GetVariableNode`

Purpose: Retrieves a reference to a declared variable for use in expressions or other nodes. Does not generate a standalone line of code — instead, it returns the variable name when used inside another node (e.g., print(score)).

| Inputs | Type | Description |
|--------|------|-------------|
| `ref` | Node Reference | Reference to a VariableNode |

| Outputs | Type           | Description                            |
|-------|----------------|----------------------------------------|
| `value` | Any            | Reference to the targeted VariableNode |


Example Luau usage:
```lua
print(score)
```

### `SetVariableNode`

Purpose: Assigns a new value to an existing variable.

| Inputs | Type | Description |
|--------|------|-------------|
| `ref` | Node Reference | Reference to a VariableNode |
| `value` | Any            | New value to assign |

| Outputs | Type           | Description                            |
|-------|----------------|----------------------------------------|
| `value` | Any            | Updated value |


Example Luau output:
```lua
score = 42
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