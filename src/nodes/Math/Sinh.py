# src/nodes/Math/Sinh.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType

class SinhNode(Node):
    def __init__(self):
        super().__init__(NodeType.METHOD, "Sinus Hyperbolic / sinh (Math)")
        self.addInput("number", 0)
        self.addOutput("result", None)

    def getValue(self):
        n1 = self.getValueInput("number")

        if isinstance(n1, Node): n1 = n1.getValue()
        if n1 is None: n1 = 0

        result = f"math.sinh({n1})"
        self.updateValueOutput("result", result)
        return result

    def toLuau(self):
        return None