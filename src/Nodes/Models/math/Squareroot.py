from src.Nodes.Node import Node

class Squareroot(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/squareroot.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.sqrt({a}))"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "SQRT NODE"