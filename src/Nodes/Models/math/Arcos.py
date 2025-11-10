from src.Nodes.Node import Node

class Arcos(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/arcos.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.acos({a}))"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "ACOS NODE"