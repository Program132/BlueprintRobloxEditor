from src.Nodes.Node import Node

class Logarithm(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/logarithm.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.log({a}))"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "LOG NODE"