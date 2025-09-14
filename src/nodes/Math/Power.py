# src/nodes/Math/Power.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType

class PowerNode(Node):
    def __init__(self):
        super().__init__(NodeType.METHOD, "Power (Math)")
        self.addInput("number1", 0)
        self.addInput("number2", 0)
        self.addOutput("result", None)

    def getValue(self):
        n1 = self.getValueInput("number1")
        n2 = self.getValueInput("number2")

        if isinstance(n1, Node): n1 = n1.getValue()
        if isinstance(n2, Node): n2 = n2.getValue()
        if n1 is None: n1 = 0
        if n2 is None: n2 = 0

        result = f"{n1} ^ {n2}"
        self.updateValueOutput("result", result)
        return result

    def toLuau(self):
        return None