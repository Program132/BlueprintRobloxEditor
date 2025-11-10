from src.Nodes.Node import Node

class Cosinush(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/cosinush.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.cosh({a}))"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "COSH NODE"