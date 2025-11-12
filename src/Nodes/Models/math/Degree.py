from src.Nodes.Node import Node

class Degree(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/degree.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.deg({a}))"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "DEG NODE"