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
        var_node = self.getValueInput("ref")
        if isinstance(var_node, VariableNode):
            self.updateValueOutput("value", var_node)
            return var_node
        self.updateValueOutput("value", None)
        return None

    def toLuau(self):
        return None
