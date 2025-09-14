# src/nodes/GetVariable.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType
from src.nodes.Variable import VariableNode

class GetVariableNode(Node):
    def __init__(self):
        super().__init__(NodeType.FUNCTION, "Get Variable")
        self.addInput("ref", None)
        self.addOutput("value", None)

    def getValue(self):
        ref = self.getValueInput("ref")
        if isinstance(ref, VariableNode):
            return ref.var_name
        return None

    def toLuau(self):
        return None
