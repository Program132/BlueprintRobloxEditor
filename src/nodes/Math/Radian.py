# src/nodes/Math/Radian.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType

class RadianNode(Node):
    def __init__(self):
        super().__init__(NodeType.METHOD, "Radians / rad (Math)")
        self.addInput("number", 0)
        self.addOutput("result", None)

    def getValue(self):
        n1 = self.getValueInput("number")

        if n1 is None: n1 = 0

        result = f"math.rad({n1})"
        self.updateValueOutput("result", result)
        return result

    def toLuau(self):
        return None