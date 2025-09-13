# src/nodes/Print.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType

class PrintNode(Node):
    def __init__(self):
        super().__init__(NodeType.FUNCTION, "Print")
        self.addInput("value", "")

    def getValue(self):
        v = self.getValueInput("value")
        if isinstance(v, bool):
            return "true" if v else "false"
        if isinstance(v, (int, float)):
            return str(v)
        if isinstance(v, str) and v.lower() in ("true", "false"):
            return v.lower()
        if isinstance(v, str):
            return f"\"{v}\""

        # Fallback
        return str(v)

    def toLuau(self):
        return f'print({self.getValue()})'
