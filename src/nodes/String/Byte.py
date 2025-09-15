# src/nodes/String/Byte.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType
from src.nodes.String.StringBaseNode import _StringNodeBase


class ByteNode(_StringNodeBase):
    def __init__(self):
        super().__init__(NodeType.METHOD, "Byte (String)")
        self.addInput("value", "")
        self.addOutput("result", None)

    def getValue(self):
        n1 = self._quote_if_needed(self.getValueInput("value"))
        expr = f"string.byte({n1})"
        self.updateValueOutput("result", expr)
        return expr

    def toLuau(self): return None