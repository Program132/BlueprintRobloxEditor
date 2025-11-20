from src.Node import Node


class Tangent(Node):
    def __init__(self):
        super().__init__("nodes/math/tangent.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.tan({a}))"
        self.setOutputValue(name="result", value=r)