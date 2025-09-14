# src/nodes/SetVariable.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType
from src.nodes.Variable import VariableNode

class SetVariableNode(Node):
    def __init__(self):
        super().__init__(NodeType.FUNCTION, "Set Variable")
        self.addInput("ref", None)
        self.addInput("value", None)
        self.addOutput("value", None)

    def getValue(self):
        new_value = self.getValueInput("value")
        var_node = self.getValueInput("ref")
        if isinstance(var_node, Node):
            var_node.updateValueOutput("value", new_value)
            self.updateValueOutput("value", new_value)
            return new_value
        return None

    def toLuau(self):
        var_node = self.getValueInput("ref")
        new_value = self.getValueInput("value")
        if isinstance(var_node, VariableNode):
            if isinstance(new_value, str):
                new_value = f'"{new_value}"'
            elif isinstance(new_value, bool):
                new_value = "true" if new_value else "false"
            return f'{var_node.var_name} = {new_value}'
        return "-- invalid set operation"