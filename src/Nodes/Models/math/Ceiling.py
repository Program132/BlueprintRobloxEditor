from src.Nodes.Node import Node

class Ceiling(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/ceiling.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.ceil({a}))"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "CEIL NODE"