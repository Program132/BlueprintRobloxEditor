from src.Nodes.Node import Node

class Arctangent(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/arctangent.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.atan({a}))"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "ATAN NODE"