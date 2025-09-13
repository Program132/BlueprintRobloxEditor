# Connections

Connections are the links between **Nodes** in BLE.  
They define how **data** flows and how **execution order** is determined, just like the wires in Unreal Engine's Blueprint system.

There are two main types of connections:

---

## 1. DataConnection

**Purpose:**  
Transfers **data values** (string, number, boolean, etc.) from the output of one Node to the input of another.

**Constructor:**
```python
DataConnection(output_node, output_name, input_node, input_name)
```

| Parameter     | Type   | Description |
|---------------|--------|------------|
| `output_node` | Node   | The Node providing the value |
| `output_name` | String | The name of the output pin on the source Node |
| `input_node`  | Node   | The Node receiving the value |
| `input_name`  | String   | The name of the input pin on the target Node |

Key method:
```python
d = DataConnection(output_node, output_name, input_node, input_name)
d.propagate()
```

Copies the value from the output pin of the source Node into the input pin of the target Node.
Example:
```python
stringVal = StringValueNode()
stringVal.updateValueOutput("value", "Hello World!")

printNode = PrintNode()

conn = DataConnection(stringVal, "value", printNode, "value")
conn.propagate()
```
Effect: The PrintNode now has "Hello World!" in its value input.

## 2. ExecutionConnection

Transfers execution flow from one Node to another (like the white execution wires in UE5). Determines the order in which Nodes run.

Constructor:
```python
ExecutionConnection(from_node, to_node)
```

| Parameter     | Type   | Description |
|---------------|--------|------------|
| `from_node` | Node   | The Node that triggers execution |
| `to_node` | Node | The Node to execute next |

Example:
```python
eventStart = EventStartNode()
printNode = PrintNode()

execConn = ExecutionConnection(eventStart, printNode)
```
When eventStart executes, it will trigger printNode next.


## Best Practices

Always propagate data before generating code, so all Nodes have the correct values.

Keep execution flow clear and linear when possible — complex branching can be added later.

Use descriptive names for pins (value, message, number) to make graphs easier to read.