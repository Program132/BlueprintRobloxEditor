from src.Nodes.Node import Node

class PI(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/pi.json")

    def toLuau(self):
        r = f"(math.pi)"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "PI NODE"