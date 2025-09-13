#src/essentials/NodeType.py
from enum import Enum

class NodeType(Enum):
    EVENT = "EVENT"
    FUNCTION = "FUNCTION"
    METHOD = "METHOD"