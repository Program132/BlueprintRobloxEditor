from src.Nodes.Node import Node

class Radians(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/radians.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.rad({a}))"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "RAD NODE"