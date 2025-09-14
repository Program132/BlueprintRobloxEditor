# src/nodes/Variable.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType

class VariableNode(Node):
    def __init__(self, var_name: str):
        super().__init__(NodeType.FUNCTION, f"Variable {var_name}")
        self.var_name = var_name
        self.addOutput("ref", self)  # self-reference
        self.addInput("value", None)
        self.addOutput("value", None)

    def updateValue(self, value):
        self.updateValueOutput("value", value)

    def getValue(self):
        v = self.getValueInput("value")
        if isinstance(v, Node):
            v = v.getValue()
        self.updateValueOutput("value", v)
        return v

    def toLuau(self):
        value = self.getValue()
        return f"local {self.var_name} = {value}"
