from src.Node import Node, NodeType

class Break(Node):
    def __init__(self):
        super().__init__("nodes/statement/break.json")

    def toLuau(self) -> str:
        return "break"