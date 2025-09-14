# src/nodes/Math/Tan.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType

class TanNode(Node):
    def __init__(self):
        super().__init__(NodeType.METHOD, "Tangent  / tan (Math)")
        self.addInput("number", 0)
        self.addOutput("result", None)

    def getValue(self):
        n1 = self.getValueInput("number")

        if n1 is None: n1 = 0

        result = f"math.tan({n1})"
        self.updateValueOutput("result", result)
        return result

    def toLuau(self):
        return None