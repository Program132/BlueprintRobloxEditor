from src.Node import Node

class Squareroot(Node):
    def __init__(self):
        super().__init__("nodes/math/squareroot.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.sqrt({a}))"
        self.setOutputValue(name="result", value=r)