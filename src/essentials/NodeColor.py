#src/essentials/NodeColor.py
from enum import Enum
from src.essentials.NodeType import NodeType

class NodeColor(Enum):
    EVENT = "#de1818" # red
    FUNCTION = "#1882de" # cyan
    METHOD = "#18de99" # green

    @staticmethod
    def getColor(nodeType: 'NodeType'):
        if nodeType == NodeType.EVENT:
            return NodeColor.EVENT
        elif nodeType == NodeType.FUNCTION:
            return NodeColor.FUNCTION
        elif nodeType == NodeType.METHOD:
            return NodeColor.METHOD
        return None