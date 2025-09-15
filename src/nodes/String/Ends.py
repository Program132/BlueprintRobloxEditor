# src/nodes/String/Ends.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType
from src.nodes.String.StringBaseNode import _StringNodeBase


class EndsNode(_StringNodeBase):
    def __init__(self):
        super().__init__(NodeType.METHOD, "Ends (String)")
        self.addInput("value", "")
        self.addInput("suffix", "")
        self.addOutput("result", None)

    def getValue(self):
        n1 = self._quote_if_needed(self.getValueInput("value"))
        n2 = self._quote_if_needed(self.getValueInput("suffix"))
        expr = f"string.ends({n1}, {n2})"
        self.updateValueOutput("result", expr)
        return expr

    def toLuau(self): return None