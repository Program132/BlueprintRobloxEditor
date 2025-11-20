from src.Node import Node

class Absolute(Node):
    def __init__(self):
        super().__init__("nodes/math/absolute.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.abs({a}))"
        self.setOutputValue(name="result", value=r)