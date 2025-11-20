from src.Node import Node

class Logarithm10(Node):
    def __init__(self):
        super().__init__("nodes/math/logarithm10.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.log10({a}))"
        self.setOutputValue(name="result", value=r)