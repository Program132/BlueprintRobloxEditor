# src/nodes/Math/Pi.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType

class PiNode(Node):
    def __init__(self):
        super().__init__(NodeType.METHOD, "Pi (Math)")
        self.addOutput("result", None)

    def getValue(self):
        result = f"math.pi"
        self.updateValueOutput("result", result)
        return result

    def toLuau(self):
        return None