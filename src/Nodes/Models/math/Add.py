from src.Nodes.NodeColor import NodeColor
from src.Nodes.NodeType import NodeType
from src.Nodes.Node import Node


class Add(Node):
    def __init__(self):
        #super().__init__(NodeType.FUNCTION, NodeColor(0, 255, 0))
        super().__init__()
        self.loadFromJson("nodes/math/add.json")

    def toLuau(self):
        a = self.getInputValue("a")
        b = self.getInputValue("b")
        r = f"({a} + {b})"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "ADD NODE"