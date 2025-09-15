# src/nodes/String/Concat.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType
from src.nodes.String.StringBaseNode import _StringNodeBase

class ConcatNode(_StringNodeBase):
    def __init__(self):
        super().__init__(NodeType.METHOD, "Concat (String)")
        self.addInput("str1", "")
        self.addInput("str2", "")
        self.addOutput("result", None)

    def getValue(self):
        n1 = self._quote_if_needed(self.getValueInput("str1"))
        n2 = self._quote_if_needed(self.getValueInput("str2"))
        expr = f"{n1} .. {n2}"  # en Lua, concat = ..
        self.updateValueOutput("result", expr)
        return expr

    def toLuau(self): return None