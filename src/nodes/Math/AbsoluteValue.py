# src/nodes/Math/AbsoluteValue.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType

class AbsoluteValueNode(Node):
    def __init__(self):
        super().__init__(NodeType.METHOD, "Absolute Value (Math)")
        self.addInput("number", 0)
        self.addOutput("result", None)

    def getValue(self):
        n1 = self.getValueInput("number")

        if isinstance(n1, Node): n1 = n1.getValue()
        if n1 is None: n1 = 0

        result = f"math.abs({n1})"
        self.updateValueOutput("result", result)
        return result

    def toLuau(self):
        return None