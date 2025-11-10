from src.Nodes.Node import Node

class Exponential(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/exponential.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.exp({a}))"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "EXP NODE"