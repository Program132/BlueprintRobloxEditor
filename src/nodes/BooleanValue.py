# src/nodes/BooleanValue.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType

class BooleanValueNode(Node):
    def __init__(self):
        super().__init__(NodeType.FUNCTION, "Boolean Value")
        self.addOutput("value", "")

    def getValue(self):
        v = self.getValueOutput("value")
        if isinstance(v, bool):
            return "true" if v else "false"
        if v in ("0", 0):
            return "false"
        if v in ("1", 1):
            return "true"
        return "true" if v else "false"

    def toLuau(self):
        return self.getValue()
