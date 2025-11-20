from src.Node import Node

class PI(Node):
    def __init__(self):
        super().__init__("nodes/math/pi.json")

    def toLuau(self):
        r = f"(math.pi)"
        self.setOutputValue(name="result", value=r)