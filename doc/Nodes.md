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

## Math Nodes

### `AbsoluteValueNode`
**Purpose:**  
Returns the absolute value of a number.

| Inputs   | Type   | Description            |
|----------|--------|------------------------|
| `number` | Number | The number to evaluate |

| Outputs | Type   | Description                 |
|---------|--------|-----------------------------|
| `result` | Number | Absolute value of the input |

**Example Luau output:**
```lua
math.abs(-5)
-- 5
```

---

### `AdditionNode`
**Purpose:**  
Adds two numbers together.

| Inputs    | Type   | Description    |
|-----------|--------|----------------|
| `number1` | Number | First operand  |
| `number2` | Number | Second operand |

| Outputs | Type   | Description      |
|---------|--------|------------------|
| `result` | Number | Sum of the inputs |

**Example Luau output:**
```lua
3 + 7
-- 10
```

---

### `ArcCosNode`
**Purpose:**  
Returns the arc cosine (inverse cosine) of a number.

| Inputs   | Type   | Description            |
|----------|--------|------------------------|
| `number` | Number | The value in radians   |

| Outputs | Type   | Description                     |
|---------|--------|---------------------------------|
| `result` | Number | Arc cosine of the input (radians) |

**Example Luau output:**
```lua
math.acos(0.5)
```

---

### `ArcSinNode`
**Purpose:**  
Returns the arc sine (inverse sine) of a number.

| Inputs   | Type   | Description          |
|----------|--------|----------------------|
| `number` | Number | The value in radians |

| Outputs | Type   | Description                   |
|---------|--------|-------------------------------|
| `result` | Number | Arc sine of the input (radians) |

**Example Luau output:**
```lua
math.asin(0.5)
```

---

### `ArcTanNode`
**Purpose:**  
Returns the arc tangent (inverse tangent) of a number.

| Inputs   | Type   | Description          |
|----------|--------|----------------------|
| `number` | Number | The value in radians |

| Outputs | Type   | Description                    |
|---------|--------|--------------------------------|
| `result` | Number | Arc tangent of the input (radians) |

**Example Luau output:**
```lua
math.atan(1)
```

---

### `CosNode`
**Purpose:**  
Returns the cosine of a number (in radians).

| Inputs   | Type   | Description         |
|----------|--------|---------------------|
| `number` | Number | Value in radians    |

| Outputs | Type   | Description            |
|---------|--------|------------------------|
| `result` | Number | Cosine of the input    |

**Example Luau output:**
```lua
math.cos(math.pi)
-- -1
```

---

### `CoshNode`
**Purpose:**  
Returns the hyperbolic cosine of a number.

| Inputs   | Type   | Description     |
|----------|--------|-----------------|
| `number` | Number | Input value     |

| Outputs | Type   | Description             |
|---------|--------|-------------------------|
| `result` | Number | Hyperbolic cosine value |

**Example Luau output:**
```lua
math.cosh(0)
-- 1
```

---

### `DegreeNode`
**Purpose:**  
Converts radians to degrees.

| Inputs   | Type   | Description        |
|----------|--------|--------------------|
| `number` | Number | Value in radians   |

| Outputs | Type   | Description              |
|---------|--------|--------------------------|
| `result` | Number | Value converted to degrees |

**Example Luau output:**
```lua
math.deg(math.pi)
-- 180
```

---

### `DivisionNode`
**Purpose:**  
Divides one number by another.

| Inputs    | Type   | Description    |
|-----------|--------|----------------|
| `number1` | Number | Dividend       |
| `number2` | Number | Divisor        |

| Outputs | Type   | Description           |
|---------|--------|-----------------------|
| `result` | Number | Quotient of the inputs |

**Example Luau output:**
```lua
10 / 2
-- 5
```

---

### `ExponentialNode`
**Purpose:**  
Returns e raised to the given number.

| Inputs   | Type   | Description         |
|----------|--------|---------------------|
| `number` | Number | Exponent            |

| Outputs | Type   | Description                    |
|---------|--------|--------------------------------|
| `result` | Number | e raised to the given exponent |

**Example Luau output:**
```lua
math.exp(1)
-- 2.718...
```

---

### `FloorDivisionNode`
**Purpose:**  
Performs floor division between two numbers.

| Inputs    | Type   | Description    |
|-----------|--------|----------------|
| `number1` | Number | Dividend       |
| `number2` | Number | Divisor        |

| Outputs | Type   | Description              |
|---------|--------|--------------------------|
| `result` | Number | Floor division quotient   |

**Example Luau output:**
```lua
10 // 3
-- 3
```

---

### `LogarithmNode`
**Purpose:**  
Returns the natural logarithm of a number.

| Inputs   | Type   | Description   |
|----------|--------|---------------|
| `number` | Number | Input value   |

| Outputs | Type   | Description                 |
|---------|--------|-----------------------------|
| `result` | Number | Natural logarithm of input |

**Example Luau output:**
```lua
math.log(10)
```

---

### `ModuloNode`
**Purpose:**  
Returns the remainder of division between two numbers.

| Inputs    | Type   | Description    |
|-----------|--------|----------------|
| `number1` | Number | Dividend       |
| `number2` | Number | Divisor        |

| Outputs | Type   | Description       |
|---------|--------|-------------------|
| `result` | Number | Remainder of division |

**Example Luau output:**
```lua
math.fmod(10, 3)
-- 1
```

---

### `MultiplicationNode`
**Purpose:**  
Multiplies two numbers together.

| Inputs    | Type   | Description    |
|-----------|--------|----------------|
| `number1` | Number | First operand  |
| `number2` | Number | Second operand |

| Outputs | Type   | Description        |
|---------|--------|--------------------|
| `result` | Number | Product of inputs  |

**Example Luau output:**
```lua
4 * 5
-- 20
```

---

### `PiNode`
**Purpose:**  
Returns the mathematical constant π.

| Inputs | Type | Description |
|--------|------|-------------|
| (none) | —    | —           |

| Outputs | Type   | Description     |
|---------|--------|-----------------|
| `result` | Number | Value of π (pi) |

**Example Luau output:**
```lua
math.pi
```

---

### `PowerNode`
**Purpose:**  
Raises one number to the power of another.

| Inputs    | Type   | Description    |
|-----------|--------|----------------|
| `number1` | Number | Base number    |
| `number2` | Number | Exponent       |

| Outputs | Type   | Description     |
|---------|--------|-----------------|
| `result` | Number | Base^Exponent   |

**Example Luau output:**
```lua
2 ^ 3
-- 8
```

---

### `RadianNode`
**Purpose:**  
Converts degrees to radians.

| Inputs   | Type   | Description       |
|----------|--------|-------------------|
| `number` | Number | Value in degrees  |

| Outputs | Type   | Description            |
|---------|--------|------------------------|
| `result` | Number | Value converted to radians |

**Example Luau output:**
```lua
math.rad(180)
-- 3.14159...
```

---

### `RandomNode`
**Purpose:**  
Generates a random number between two values.

| Inputs    | Type   | Description      |
|-----------|--------|------------------|
| `number1` | Number | Lower bound      |
| `number2` | Number | Upper bound      |

| Outputs | Type   | Description                |
|---------|--------|----------------------------|
| `result` | Number | Random number in the range |

**Example Luau output:**
```lua
math.random(1, 10)
```

---

### `SinNode`
**Purpose:**  
Returns the sine of a number (in radians).

| Inputs   | Type   | Description       |
|----------|--------|-------------------|
| `number` | Number | Value in radians  |

| Outputs | Type   | Description         |
|---------|--------|---------------------|
| `result` | Number | Sine of the input   |

**Example Luau output:**
```lua
math.sin(math.pi/2)
-- 1
```

---

### `SinhNode`
**Purpose:**  
Returns the hyperbolic sine of a number.

| Inputs   | Type   | Description |
|----------|--------|-------------|
| `number` | Number | Input value |

| Outputs | Type   | Description             |
|---------|--------|-------------------------|
| `result` | Number | Hyperbolic sine of input |

**Example Luau output:**
```lua
math.sinh(0)
-- 0
```

---

### `SquarerootNode`
**Purpose:**  
Returns the square root of a number.

| Inputs   | Type   | Description   |
|----------|--------|---------------|
| `number` | Number | Input value   |

| Outputs | Type   | Description             |
|---------|--------|-------------------------|
| `result` | Number | Square root of the input |

**Example Luau output:**
```lua
math.sqrt(9)
-- 3
```

---

### `SubtractionNode`
**Purpose:**  
Subtracts the second number from the first.

| Inputs    | Type   | Description    |
|-----------|--------|----------------|
| `number1` | Number | Minuend        |
| `number2` | Number | Subtrahend     |

| Outputs | Type   | Description               |
|---------|--------|---------------------------|
| `result` | Number | Result of the subtraction |

**Example Luau output:**
```lua
7 - 2
-- 5
```

---

### `TanNode`
**Purpose:**  
Returns the tangent of a number (in radians).

| Inputs   | Type   | Description       |
|----------|--------|-------------------|
| `number` | Number | Value in radians  |

| Outputs | Type   | Description           |
|---------|--------|-----------------------|
| `result` | Number | Tangent of the input  |

**Example Luau output:**
```lua
math.tan(math.pi/4)
-- 1
```

---

### `TanhNode`
**Purpose:**  
Returns the hyperbolic tangent of a number.

| Inputs   | Type   | Description |
|----------|--------|-------------|
| `number` | Number | Input value |

| Outputs | Type   | Description               |
|---------|--------|---------------------------|
| `result` | Number | Hyperbolic tangent result |

**Example Luau output:**
```lua
math.tanh(0)
-- 0
```

## String Nodes

### `ByteNode`
**Purpose:**  
Returns the internal numeric codes of the characters in a string.

| Inputs  | Type   | Description              |
|---------|--------|--------------------------|
| `value` | String | The input string         |

| Outputs | Type   | Description                |
|---------|--------|----------------------------|
| `result` | Number | ASCII code of first character |

**Example Luau output:**
```lua
string.byte("A")
-- 65
```

---

### `CharNode`
**Purpose:**  
Converts one or more integers to their corresponding characters.

| Inputs  | Type   | Description             |
|---------|--------|-------------------------|
| `value` | Number | Numeric character code  |

| Outputs | Type   | Description                 |
|---------|--------|-----------------------------|
| `result` | String | Character for the given code |

**Example Luau output:**
```lua
string.char(65)
-- "A"
```

---

### `EndsNode`
**Purpose:**  
Checks if a string ends with a given suffix.

| Inputs   | Type   | Description              |
|----------|--------|--------------------------|
| `value`  | String | The string to check      |
| `suffix` | String | The suffix to match      |

| Outputs | Type    | Description                      |
|---------|---------|----------------------------------|
| `result` | Boolean | True if string ends with suffix |

**Example Luau output:**
```lua
string.ends("HelloWorld", "World")
-- true
```

---

### `FindNode`
**Purpose:**  
Finds the first occurrence of a pattern in a string.

| Inputs    | Type   | Description                |
|-----------|--------|----------------------------|
| `value`   | String | The string to search in    |
| `pattern` | String | The pattern to search for  |

| Outputs | Type   | Description                        |
|---------|--------|------------------------------------|
| `result` | Number | Position of the first occurrence   |

**Example Luau output:**
```lua
string.find("Hello World", "World")
-- 7
```

---

### `LenNode`
**Purpose:**  
Returns the length of a string.

| Inputs  | Type   | Description       |
|---------|--------|-------------------|
| `value` | String | The string input  |

| Outputs | Type   | Description         |
|---------|--------|---------------------|
| `result` | Number | Length of the string |

**Example Luau output:**
```lua
string.len("Hello")
-- 5
```

---

### `ConcatNode`
**Purpose:**  
Concatenates two strings together.

| Inputs  | Type   | Description        |
|---------|--------|--------------------|
| `str1`  | String | First string       |
| `str2`  | String | Second string      |

| Outputs | Type   | Description         |
|---------|--------|---------------------|
| `result` | String | Concatenated string |

**Example Luau output:**
```lua
"Hello " .. "World"
-- "Hello World"
```

---

### `LowerNode`
**Purpose:**  
Converts all characters in a string to lowercase.

| Inputs  | Type   | Description       |
|---------|--------|-------------------|
| `value` | String | Input string      |

| Outputs | Type   | Description                 |
|---------|--------|-----------------------------|
| `result` | String | String in lowercase letters |

**Example Luau output:**
```lua
string.lower("HELLO")
-- "hello"
```

---

### `UpperNode`
**Purpose:**  
Converts all characters in a string to uppercase.

| Inputs  | Type   | Description       |
|---------|--------|-------------------|
| `value` | String | Input string      |

| Outputs | Type   | Description                 |
|---------|--------|-----------------------------|
| `result` | String | String in uppercase letters |

**Example Luau output:**
```lua
string.upper("hello")
-- "HELLO"
```

---

### `RepNode`
**Purpose:**  
Repeats a string a given number of times.

| Inputs   | Type   | Description            |
|----------|--------|------------------------|
| `value`  | String | The string to repeat   |
| `number` | Number | Number of repetitions  |

| Outputs | Type   | Description         |
|---------|--------|---------------------|
| `result` | String | Repeated string     |

**Example Luau output:**
```lua
string.rep("ha", 3)
-- "hahaha"
```

---

### `ReverseNode`
**Purpose:**  
Reverses the characters of a string.

| Inputs  | Type   | Description      |
|---------|--------|------------------|
| `value` | String | Input string     |

| Outputs | Type   | Description             |
|---------|--------|-------------------------|
| `result` | String | Reversed string result |

**Example Luau output:**
```lua
string.reverse("Hello")
-- "olleH"
```

---

### `StartsNode`
**Purpose:**  
Checks if a string starts with a given prefix.

| Inputs   | Type   | Description             |
|----------|--------|-------------------------|
| `value`  | String | The string to check     |
| `prefix` | String | The prefix to match     |

| Outputs | Type    | Description                       |
|---------|---------|-----------------------------------|
| `result` | Boolean | True if string starts with prefix |

**Example Luau output:**
```lua
string.starts("HelloWorld", "Hello")
-- true
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