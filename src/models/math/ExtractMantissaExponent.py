from src.Node import Node

class ExtractMantissaExponent(Node):
    def __init__(self):
        super().__init__("nodes/math/extractmantissaexponent.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.frexp({a}))"
        self.setOutputValue(name="result", value=r)