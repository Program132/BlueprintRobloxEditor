# src/nodes/Math/Modulo.py
from src.essentials.Node import Node
from src.essentials.NodeType import NodeType

class ModuloNode(Node):
    def __init__(self):
        super().__init__(NodeType.METHOD, "Modulo (Math)")
        self.addInput("number1", 0)
        self.addInput("number2", 0)
        self.addOutput("result", None)

    def getValue(self):
        n1 = self.getValueInput("number1")
        n2 = self.getValueInput("number2")

        if n1 is None: n1 = 0
        if n2 is None: n2 = 0

        result = f"math.fmod({n1},{n2})"
        self.updateValueOutput("result", result)
        return result

    def toLuau(self):
        return None