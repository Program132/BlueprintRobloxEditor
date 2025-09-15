# src/nodes/String/Char.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType
from src.nodes.String.StringBaseNode import _StringNodeBase

class CharNode(_StringNodeBase):
    def __init__(self):
        super().__init__(NodeType.METHOD, "Char (String)")
        self.addInput("value", "")
        self.addOutput("result", None)

    def getValue(self):
        # Char prend un code numérique → pas de guillemets forcés
        n1 = self.getValueInput("value")
        from src.essentials.Node import Node as BaseNode
        if isinstance(n1, BaseNode):
            n1 = n1.getValue()
        if n1 is None: n1 = 0
        expr = f"string.char({n1})"
        self.updateValueOutput("result", expr)
        return expr

    def toLuau(self): return None