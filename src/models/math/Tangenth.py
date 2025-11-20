from src.Node import Node

class Tangenth(Node):
    def __init__(self):
        super().__init__("nodes/math/tangenth.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.tanh({a}))"
        self.setOutputValue(name="result", value=r)