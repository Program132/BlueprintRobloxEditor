# src/nodes/StringValue.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType

class StringValueNode(Node):
    def __init__(self):
        super().__init__(NodeType.FUNCTION, "String Value")
        self.addOutput("value", "")

    def getValue(self):
        return self.getValueOutput("value")

    def toLuau(self):
        return f'{self.getValue()}'