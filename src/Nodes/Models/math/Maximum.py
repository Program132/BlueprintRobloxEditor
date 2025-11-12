from src.Nodes.Node import Node

class Maximum(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/maximum.json")

    def toLuau(self):
        a = self.getInputValue("a")
        b = self.getInputValue("b")
        r = f"(math.min({a}, {b}))"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "MIN NODE"