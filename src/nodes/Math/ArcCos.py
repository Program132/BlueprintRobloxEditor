# src/nodes/Math/ArcCos.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType

class ArcCosNode(Node):
    def __init__(self):
        super().__init__(NodeType.METHOD, "Arc Cosinus / acos (Math)")
        self.addInput("number", 0)
        self.addOutput("result", None)

    def getValue(self):
        n1 = self.getValueInput("number")

        if isinstance(n1, Node): n1 = n1.getValue()
        if n1 is None: n1 = 0

        result = f"math.acos({n1})"
        self.updateValueOutput("result", result)
        return result

    def toLuau(self):
        return None