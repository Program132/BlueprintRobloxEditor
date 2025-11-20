from src.Node import Node

class Arctangent(Node):
    def __init__(self):
        super().__init__("nodes/math/arctangent.json")

    def toLuau(self):
        a = self.getInputValue("a")
        r = f"(math.atan({a}))"
        self.setOutputValue(name="result", value=r)