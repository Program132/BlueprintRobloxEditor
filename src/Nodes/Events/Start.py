from src.Nodes.Node import Node
from src.Nodes.NodeColor import NodeColor
from src.Nodes.NodeType import NodeType

class Start(Node):
    def __init__(self):
        super().__init__(NodeType.EVENT, NodeColor(0,0,255))

    def toLuau(self):
        return None