# src/nodes/EventStart.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType

class EventStartNode(Node):
    def __init__(self):
        super().__init__(NodeType.EVENT, "Event Start")

    def getValue(self):
        return "-- START"

    def toLuau(self):
        return self.getValue()