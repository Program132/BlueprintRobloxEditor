# src/nodes/EndStatement.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType

class EndStatementNode(Node):
    def __init__(self):
        super().__init__(NodeType.FUNCTION, "End (Auto)")
        self.addInput("result", "==")

    def getValue(self):
        expr = f"end"
        self.updateValueOutput("result", expr)
        return expr

    def toLuau(self):
        return self.getValue()