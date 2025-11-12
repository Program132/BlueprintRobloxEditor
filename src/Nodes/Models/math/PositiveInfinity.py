from src.Nodes.Node import Node

class PositiveInfinity(Node):
    def __init__(self):
        super().__init__()
        self.loadFromJson("nodes/math/positiveinfinity.json")

    def toLuau(self):
        r = f"(math.huge)"
        self.setOutputValue(name="result", value=r)

    def __str__(self):
        return "HUGE NODE"