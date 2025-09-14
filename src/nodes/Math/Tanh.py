# src/nodes/Math/Tanh.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType

class TanhNode(Node):
    def __init__(self):
        super().__init__(NodeType.METHOD, "Tangent Hyperbolic / tanh (Math)")
        self.addInput("number", 0)
        self.addOutput("result", None)

    def getValue(self):
        n1 = self.getValueInput("number")

        if n1 is None: n1 = 0

        result = f"math.tanh({n1})"
        self.updateValueOutput("result", result)
        return result

    def toLuau(self):
        return None