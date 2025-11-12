from src.Nodes.Node import Node

class Logarithm10(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/logarithm10.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.log10({a}))"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "LOG10 NODE"