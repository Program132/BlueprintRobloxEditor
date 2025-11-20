from src.Node import Node

class Cosinush(Node):
    def __init__(self):
        super().__init__("nodes/math/cosinush.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.cosh({a}))"
        self.setOutputValue(name="result", value=r)