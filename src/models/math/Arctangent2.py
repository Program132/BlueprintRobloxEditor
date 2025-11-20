from src.Node import Node

class Arctangent2(Node):
    def __init__(self):
        super().__init__("nodes/math/arctangent2.json")

    def toLuau(self):
        x = self.getInputValue("x")
        y = self.getInputValue("y")
        r = f"(math.atan2({y}, {x}))"
        self.setOutputValue(name="result", value=r)