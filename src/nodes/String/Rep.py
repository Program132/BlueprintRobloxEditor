# src/nodes/String/Rep.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType
from src.nodes.String.StringBaseNode import _StringNodeBase

class RepNode(_StringNodeBase):
    def __init__(self):
        super().__init__(NodeType.METHOD, "Rep / Repeat (String)")
        self.addInput("value", "")
        self.addInput("number", 0)
        self.addOutput("result", None)

    def getValue(self):
        n1 = self._quote_if_needed(self.getValueInput("value"))
        n2 = self.getValueInput("number")
        from src.essentials.Node import Node as BaseNode
        if isinstance(n2, BaseNode):
            n2 = n2.getValue()
        if n2 is None: n2 = 0
        expr = f"string.rep({n1}, {n2})"
        self.updateValueOutput("result", expr)
        return expr

    def toLuau(self): return None