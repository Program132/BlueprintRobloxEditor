# src/nodes/String/Len.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType
from src.nodes.String.StringBaseNode import _StringNodeBase

class LenNode(_StringNodeBase):
    def __init__(self):
        super().__init__(NodeType.METHOD, "Size / Len (String)")
        self.addInput("value", "")
        self.addOutput("result", None)

    def getValue(self):
        n1 = self._quote_if_needed(self.getValueInput("value"))
        expr = f"string.len({n1})"
        self.updateValueOutput("result", expr)
        return expr

    def toLuau(self): return None