from src.Nodes.Node import Node

class ExtractMantissaExponent(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/extractmantissaexponent.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.frexp({a}))"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "FREXP NODE"