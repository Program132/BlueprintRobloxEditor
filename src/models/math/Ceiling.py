from src.Node import Node

class Ceiling(Node):
    def __init__(self):
        super().__init__("nodes/math/ceiling.json")
    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.ceil({a}))"
        self.setOutputValue(name="result", value=r)