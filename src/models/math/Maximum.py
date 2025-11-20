from src.Node import Node

class Maximum(Node):
    def __init__(self):
        super().__init__("nodes/math/maximum.json")

    def toLuau(self):
        a = self.getInputValue("a")
        b = self.getInputValue("b")
        r = f"(math.min({a}, {b}))"
        self.setOutputValue(name="result", value=r)