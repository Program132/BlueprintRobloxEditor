from src.Node import Node

class PositiveInfinity(Node):
    def __init__(self):
        super().__init__("nodes/math/positiveinfinity.json")
    def toLuau(self):
        r = f"(math.huge)"
        self.setOutputValue(name="result", value=r)