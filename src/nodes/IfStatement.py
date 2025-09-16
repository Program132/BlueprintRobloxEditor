# src/nodes/IfStatement.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType
from src.nodes.CO.Different import DifferentNode
from src.nodes.CO.Equal import EqualNode
from src.nodes.CO.Greater import GreaterNode
from src.nodes.CO.GreaterEqual import GreaterEqualNode
from src.nodes.CO.Lower import LowerNode
from src.nodes.CO.LowerEqual import LowerEqualNode


class IfStatementNode(Node):
    def __init__(self):
        super().__init__(NodeType.FUNCTION, "If")
        self.addInput("value1", None)
        self.addInput("value2", None)
        self.addInput("operator", "==")
        self.addOutput("success", [])
        self.addOutput("fail", [])

    def getValue(self):
        n1 = self.getValueInput("value1")
        n2 = self.getValueInput("value2")
        o = self.getValueInput("operator")

        if isinstance(o, EqualNode) or isinstance(o, DifferentNode) or isinstance(o, LowerNode) or isinstance(o, LowerEqualNode) or isinstance(o, GreaterNode) or isinstance(o, GreaterEqualNode) :
            o = o.getValue()
            expr = f'if {o} then'
        else:
            if isinstance(o, Node):
                o = o.getValue()
            if isinstance(n1, Node):
                n1 = n1.getValue()
            if isinstance(n2, Node):
                n2 = n2.getValue()
            if n1 is None: n1 = 0
            if n2 is None: n2 = 0
            if o not in ["==", "~=", ">=", "<=", ">", "<"]: o = "=="

            expr = f"if {n1} {o} {n2} then"
        return expr

    def toLuau(self):
        return self.getValue()