from src.Node import Node


class Exponential(Node):
    def __init__(self):
        super().__init__("nodes/math/exponential.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.exp({a}))"
        self.setOutputValue(name="result", value=r)