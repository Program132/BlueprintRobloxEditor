from src.Nodes.Node import Node

class Power(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/maximum.json")

    def toLuau(self):
        a = self.getInputValue("a")
        x = self.getInputValue("x")
        r = f"(math.pow({x}, {a}))"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "MIN NODE"