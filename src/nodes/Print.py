# src/nodes/Print.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType
from src.nodes.Variable import VariableNode
from src.nodes.GetVariable import GetVariableNode

class PrintNode(Node):
    def __init__(self):
        super().__init__(NodeType.FUNCTION, "Print")
        self.addInput("value", "")

    def getValue(self):
        v = self.getValueInput("value")
        if isinstance(v, VariableNode):
            return v.var_name

        if isinstance(v, GetVariableNode):
            ref = v.getValueInput("ref")
            if isinstance(ref, VariableNode):
                return ref.var_name

        if v is None:
            return '"undefined"'

        if isinstance(v, bool):
            return "true" if v else "false"
        if isinstance(v, (int, float)):
            return str(v)
        if isinstance(v, str) and v.lower() in ("true", "false"):
            return v.lower()
        if isinstance(v, str):
            return f'"{v}"'

        return str(v)

    def toLuau(self):
        return f'print({self.getValue()})'
