from src.Node import Node

class Radians(Node):
    def __init__(self):
        super().__init__("nodes/math/radians.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.rad({a}))"
        self.setOutputValue(name="result", value=r)