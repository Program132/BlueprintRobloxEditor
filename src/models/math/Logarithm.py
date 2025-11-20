from src.Node import Node

class Logarithm(Node):
    def __init__(self):
        super().__init__("nodes/math/logarithm.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.log({a}))"
        self.setOutputValue(name="result", value=r)