from src.Nodes.Node import Node

class Tangenth(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/tangenth.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.tanh({a}))"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "TANH NODE"