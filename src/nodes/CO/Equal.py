# src/nodes/CO/Equal.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType

class EqualNode(Node):
    def __init__(self):
        super().__init__(NodeType.METHOD, "Equal (==)")
        self.addInput("value1", None)
        self.addInput("value2", None)
        self.addOutput("result", None)

    def getValue(self):
        n1 = self.getValueInput("value1")
        n2 = self.getValueInput("value2")
        if isinstance(n1, Node):
            n1 = n1.getValue()
        if isinstance(n2, Node):
            n2 = n2.getValue()
        if n1 is None: n1 = 0
        if n2 is None: n2 = 0

        expr = f"{n1} == {n2}"
        self.updateValueOutput("result", expr)
        return expr

    def toLuau(self):
        return None